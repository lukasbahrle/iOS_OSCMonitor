//
//  ConnectionViewModelInputOutput.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 13/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine

protocol ConnectionViewModelInputType {
    var portInput: AnyPublisher<String, Never> {get}
    var connect: AnyPublisher<String, Never> {get}
    var disconnect: AnyPublisher<Void, Never> {get}
}

struct ConnectionViewModelInput: ConnectionViewModelInputType {
    let portInput: AnyPublisher<String, Never>
    let connect: AnyPublisher<String, Never>
    let disconnect: AnyPublisher<Void, Never>
}


protocol ConnectionViewModelOutputType {
    var localIPAddress: String {get}
    var portText: String {get}
    var portPlaceholder: String {get}
    var publishers: ConnectionViewModelOutputPublishers {get}
}

struct ConnectionViewModelOutputPublishers {
    let localIPAddress: AnyPublisher<String, Never>
    let portText: AnyPublisher<String, Never>
    let portPlaceholder: AnyPublisher<String, Never>
    let connectionButtonState: AnyPublisher<ConnectionButtonState, Never>
}


