//
//  MessageListViewModelInputOutput.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 13/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine

protocol MessageListViewModelInputType {
    var groupByAddress: AnyPublisher<Bool, Never> {get}
    var clear: AnyPublisher<Void, Never> {get}
    var togglePaused: AnyPublisher<Void, Never> {get}
}

struct MessageListViewModelInput: MessageListViewModelInputType {
    let groupByAddress: AnyPublisher<Bool, Never>
    let clear: AnyPublisher<Void, Never>
    let togglePaused: AnyPublisher<Void, Never>
}


protocol MessageListViewModelOutputType {
    var items: [MessageCellViewModel] {get}
    var isGroupedByAddress: Bool {get}
    var state: MessageListState {get}
    var publishers: MessageListViewModelOutputPublishers {get}
}

struct MessageListViewModelOutputPublishers{
    let items: AnyPublisher<[MessageCellViewModel], Never>
    var isGroupedByAddress: AnyPublisher<Bool, Never>
    var state: AnyPublisher<MessageListState, Never>
}
