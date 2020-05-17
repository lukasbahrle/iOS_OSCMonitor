//
//  MainComponentsFactory.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 15/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation

struct MainViewModelComponents{
    var connectionViewModel: ConnectionViewModel
    var messageListViewModel: MessageListViewModel
    var addressListViewModel: AddressListViewModel
}


final class MainViewModelComponentsFactory {
    func mainViewModelComponents() -> MainViewModelComponents {
        let connectionViewModel = ConnectionViewModel()
        let messagesViewModel = MessageListViewModel()
        let addressListViewModel = AddressListViewModel()
        return MainViewModelComponents(connectionViewModel: connectionViewModel, messageListViewModel: messagesViewModel, addressListViewModel: addressListViewModel)
    }
}
