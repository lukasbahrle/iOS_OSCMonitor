//
//  MainViewController.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 03/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import UIKit
import Combine

class MainViewController: UIViewController, StoryboardBased, ViewModelBased, AppStateNotifiable {
    var appStateNotifier: AppStateNotifierType!
    var viewModel: MainViewModel!
    
    private var cancellables: [AnyCancellable] = []
    private let load = PassthroughSubject<Void, Never>()
    private let appear = PassthroughSubject<Void, Never>()
    private let enterBackground = PassthroughSubject<Void, Never>()
    private let enterForeground = PassthroughSubject<Void, Never>()
    private let connection = PassthroughSubject<String, Never>()
    private let clear = PassthroughSubject<Void, Never>()
    
    var vcConnectionViewController: ConnectionViewController?
    var vcInputMessagesViewController: MessageListViewController?
    var vcAddressListViewController: AddressListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appStateNotifier.onEnterBackground = {
            self.appEnterBackground()
        }
        
        appStateNotifier.onEnterForeground = {
            self.appEnterForeground()
        }
        
        bind(to: viewModel )

        vcConnectionViewController?.initialize(viewModel: viewModel.components.connectionViewModel)
        vcInputMessagesViewController?.initialize(viewModel: viewModel.components.messageListViewModel)
        vcAddressListViewController?.initialize(viewModel: viewModel.components.addressListViewModel)
        
        apply(theme: Appearance.shared.theme)
        
        navigationItem.title = "OSC Monitor"
        
        load.send()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let vc as ConnectionViewController:
        vcConnectionViewController = vc
        case let vc as MessageListViewController:
            vcInputMessagesViewController = vc
        case let vc as AddressListViewController:
            vcAddressListViewController = vc
        default:
            break
        }
    }
}


// MARK: App state notifier

extension MainViewController{
    private func appEnterBackground() {
        /// app moved to background
        enterBackground.send()
    }
    
    private func appEnterForeground() {
        /// app moved to background
        enterForeground.send()
    }
}


// MARK: Theming

extension MainViewController: Themeable{
    func apply(theme: Theme) {
        //force dark theme
        overrideUserInterfaceStyle = .dark
        self.navigationController?.overrideUserInterfaceStyle = .dark
        
        view.backgroundColor = theme.backgroundColor
        
        vcInputMessagesViewController?.apply(theme: theme)
        vcAddressListViewController?.apply(theme: theme)
        vcConnectionViewController?.apply(theme: theme)
    }
}


// MARK: View model

extension MainViewController{
    private func bind(to viewModel: MainViewModelType) {
        guard let vcConnection = vcConnectionViewController, let vcMessageList = vcInputMessagesViewController, let vcAddressList = vcAddressListViewController else {return}
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let connectionInput = vcConnection.viewModelInput()
        let messageListInput = vcMessageList.viewModelInput()
        let addressListInput = vcAddressList.viewModelInput()
        let input = MainViewModelInput(
            load: load.eraseToAnyPublisher(),
            appear: appear.eraseToAnyPublisher(),
                                       enterBackground: enterBackground.eraseToAnyPublisher(),
                                       enterForeground: enterForeground.eraseToAnyPublisher(),
                                       portInput: connectionInput.portInput,
                                       connect: connectionInput.connect,
                                       disconnect: connectionInput.disconnect,
                                       groupByAddress: messageListInput.groupByAddress,
            clear: messageListInput.clear,
            togglePaused: messageListInput.togglePaused,
            selectAddressFilterItem: addressListInput.selectAddressFilterItem
        )

        viewModel.bind(input: input)
    }
}


