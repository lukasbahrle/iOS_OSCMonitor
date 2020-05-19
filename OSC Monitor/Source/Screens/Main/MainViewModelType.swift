//
//  MainViewModelType.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 11/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine


struct MainViewModelInput: AddressListViewModelInputType, MessageListViewModelInputType{//}, ConnectionViewModelInputType {
    /// called when the view is loaded
    let load: AnyPublisher<Void, Never>
     /// called when the view appears
    let appear: AnyPublisher<Void, Never>
     /// called when the app will enters the background
    let enterBackground: AnyPublisher<Void, Never>
    /// called when the app will enters the foreground
    let enterForeground: AnyPublisher<Void, Never>
    /// called when the trait collection changes
    let traitCollectionDidChange: AnyPublisher<TraitCollectionSize, Never>
     /// called when the port input textfield is changed
    let portInput: AnyPublisher<String, Never>
    /// called when the connect action is triggered
    let connect: AnyPublisher<String, Never>
    /// called when the disconnect action is triggered
    let disconnect: AnyPublisher<Void, Never>
    /// called when the groupByAddress action is triggered
    let groupByAddress: AnyPublisher<Bool, Never>
    /// called when the clear action is triggered
    let clear: AnyPublisher<Void, Never>
    /// called when the pause / resume action is triggered
    let togglePaused: AnyPublisher<Void, Never>
    /// called when an address is selected from the address list
    let selectAddressFilterItem: AnyPublisher<Int, Never>
}


protocol MainViewModelType{
    func bind(input: MainViewModelInput)
}
