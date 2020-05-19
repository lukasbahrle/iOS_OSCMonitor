//
//  MainViewModel.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 11/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine



final class MainViewModel: MainViewModelType{
   
    private(set) var components: MainViewModelComponents

    let messages = Messages()
    let addressFilters = AddressFilters()
    
    private let stateMachine = MainStateMachine()
     
    private weak var navigator: MainNavigator?
    private let useCase: MainUseCaseType
    private var cancellables: [AnyCancellable] = []
    
    init(useCase: MainUseCaseType, navigator: MainNavigator, components: MainViewModelComponents? = nil) {
        self.useCase = useCase
        self.navigator = navigator
        
        self.components = components ?? MainViewModelComponentsFactory().mainViewModelComponents()
    }
    
    func bind(input: MainViewModelInput) {
       cancellables.forEach { $0.cancel() }
       cancellables.removeAll()
        
       input.load
        .sink(receiveValue: { [unowned self]_ in
            /// load initial values
            self.useCase.getDefaultValues()
                .sink(receiveCompletion: { (error) in }) { [weak self](defaultValues) in
                    self?.components.connectionViewModel.port = defaultValues.port
                    self?.components.messageListViewModel.update(isGroupedByAddress: defaultValues.isGroupedByAddress)
                    /// autoconnect
                    self?.stateMachine.connect(port: defaultValues.port)
            }
            .store(in: &self.cancellables)
            
        })
        .store(in: &cancellables)
       
        
        input.enterBackground
        .sink(receiveValue: { [weak self] _ in
            self?.onEnterBackground()
        })
        .store(in: &cancellables)
        
        
        input.enterForeground
        .sink(receiveValue: { [weak self] _ in
            self?.onEnterForeground()
        })
        .store(in: &cancellables)
        
        input.traitCollectionDidChange
        .sink(receiveValue: { [weak self] size in
            self?.onTraitCollectionDidChange(size: size)
        })
        .store(in: &cancellables)
        
        
        input.portInput
        .sink(receiveValue: { [unowned self] portText in
            self.components.connectionViewModel.update(portText: portText)
        })
        .store(in: &cancellables)
        
        
        input.connect
        .sink(receiveValue: { [weak self] portText in
            /// update main state when connect action is triggered
            if let port = UInt16(portText) {
                self?.stateMachine.connect(port: port)
            }
            else{
                self?.stateMachine.connectionFail()
            }
        })
        .store(in: &cancellables)
        
    
        input.disconnect
        .sink(receiveValue: { [weak self] _ in
            /// update to disconnect state if is currently in a connected or connecting state
            self?.stateMachine.disconnect()
         })
        .store(in: &cancellables)
        
        
        input.clear
         .sink(receiveValue: { [weak self] _ in
            /// clears the message list
            self?.messages.clear()
            self?.addressFilters.clear()
         })
        .store(in: &cancellables)
        
        
        input.togglePaused
         .sink(receiveValue: { [weak self] _ in
            /// pauses  or resumesthe current conexion
            self?.stateMachine.tooglePause()
         })
        .store(in: &cancellables)
        
        
        input.groupByAddress
         .sink(receiveValue: { [weak self] isGrouped in
            /// group the current messages by address
            self?.components.messageListViewModel.update(isGroupedByAddress: isGrouped)
         })
        .store(in: &cancellables)
        
        
        input.selectAddressFilterItem
         .sink(receiveValue: { [weak self] index in
            /// update address filters
            guard let address = self?.messages.address(at: index) else {return}
            self?.addressFilters.toggleActiveState(for: address)
         })
        .store(in: &cancellables)
        
        
        /// on data update
        Publishers.Merge(messages.updatePublisher, addressFilters.updatePublisher)
            .throttle(for: 0.02, scheduler: DispatchQueue.global(), latest: true)
            .sink(receiveValue: { [weak self] _ in
                guard let messages = self?.messages, let addressFilters = self?.addressFilters else {return}
                
                self?.components.messageListViewModel.update(items: messages.items, addresses: messages.addresses, addressesLastMessage: messages.addressesLastMessage, addressFilters: addressFilters.items)
                self?.components.addressListViewModel.update(addresses: messages.addresses, filters: addressFilters.items)
            })
            .store(in: &cancellables)
        
        /// on state update
        stateMachine.statePublisher
            .sink(receiveValue: { [weak self] state in
                self?.onStateUpdate(state: state)
            })
        .store(in: &cancellables)
    }
}



// MARK: View States

extension MainViewModel{
    
    private func onEnterBackground(){
        stateMachine.disconnect()
        /// save default values when app enters the background
        saveDefaultValues()
    }
    
    private func onEnterForeground(){
        let port = components.connectionViewModel.port
        stateMachine.connect(port: port)
    }
    
    private func onTraitCollectionDidChange(size: TraitCollectionSize){
        components.messageListViewModel.onTraitCollectionDidChange(size: size)
    }
    
}


// MARK: State

extension MainViewModel{
    private func onStateUpdate(state:MainState){
       messages.pause(state.isPaused)
       components.connectionViewModel.state = state.connectionState()
       components.messageListViewModel.update(state: state.massageListState())
       switch state {
           case .connect(let port):
               handleConnectState(port: port)
           case .disconnect:
               handleDisconnectState()
       default:
           break
       }
   }
}



// MARK: Connection

extension MainViewModel{
    
   private func handleConnectState(port: UInt16){
        messages.stop()
        messages.clear()
        addressFilters.clear()
       
       let connectionPublisher = self.useCase.connect(to: port)

       connectionPublisher
           .sink(receiveCompletion: { [weak self] completion in
               switch completion{
               case .failure(_):
                    self?.stateMachine.connectionFail()
               case .finished:
                   self?.stateMachine.connectionSuccess()
               }
               
           }) { [weak self] messagesPublisher in
            self?.messages.start(messagesPublisher: messagesPublisher)
       }
       .store(in: &cancellables)
       
   }
   
   private func handleDisconnectState(){
       self.useCase.disconnect()
       stateMachine.disconnect()
   }
}




// MARK: Default Values

extension MainViewModel{
    
    private func saveDefaultValues(){
        let defaultValues = MainDefaultValues(port: self.components.connectionViewModel.port, isGroupedByAddress: self.components.messageListViewModel.isGroupedByAddress)
        useCase.set(defaultValues: defaultValues)
    }
}


