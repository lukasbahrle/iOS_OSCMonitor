//
//  InputMessagesViewModel.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 14/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine


class MessageListViewModel: MessageListViewModelOutputType{
    
    // subjects
    private var itemsSubject = CurrentValueSubject<[MessageCellViewModel], Never>([])
    private var isGroupedByAddressSubject = CurrentValueSubject<Bool, Never>(false)
    private var stateSubject = CurrentValueSubject<MessageListState, Never>(.notconnected)
   
    // output
    var items: [MessageCellViewModel] {itemsSubject.value}
    var isGroupedByAddress: Bool {isGroupedByAddressSubject.value}
    var state: MessageListState {stateSubject.value}
    var publishers: MessageListViewModelOutputPublishers{
        MessageListViewModelOutputPublishers(items: itemsSubject.eraseToAnyPublisher(), isGroupedByAddress: isGroupedByAddressSubject.eraseToAnyPublisher(), state: stateSubject.eraseToAnyPublisher())
    }
    
    private var cancellables: [AnyCancellable] = []
    
    private var addresses = [String]()
    private var addressesLastMessage = [String: Int]()
    private var addressFilters = Set<String>()
    private var allItems = [MessageCellViewModel]()
    
    init(){}
    
    func update(items: [MessageType], addresses:  [String], addressesLastMessage: [String: Int], addressFilters: Set<String>){
        self.allItems = items.enumerated().map{ (index, item) -> MessageCellViewModel in
            MessageCellViewModel(id: item.id, address: item.addressPattern, arguments: item.arguments, isTopSeparator: index > 0 && !(item.bundleIndex >= 0 && !item.firstItemInBundle))}
        
        self.addresses = addresses
        self.addressesLastMessage = addressesLastMessage
        self.addressFilters = addressFilters
        onUpdate()
    }
    
    func update(state: MessageListState){
        self.stateSubject.send(state)
    }
    
    func update(isGroupedByAddress isGrouped: Bool){
        self.isGroupedByAddressSubject.send(isGrouped)
        onUpdate()
    }
    
    private func onUpdate(){
        if !isGroupedByAddress {
            if addressFilters.count == 0 {
                self.itemsSubject.send(allItems)
            }
            else{
                self.itemsSubject.send(allItems.filter{addressFilters.contains($0.address)})
            }
        }
        else{
            var groupedItems = [MessageCellViewModel]()
            
            for item in addresses {
                if let lastMessageIndex = addressesLastMessage[item], addressFilters.count == 0 || addressFilters.contains(item){
                     groupedItems.append(allItems[lastMessageIndex])
                }
            }
            self.itemsSubject.send(groupedItems)
           // itemsSubject.send(self.items)
        }
        
    }
    
}
