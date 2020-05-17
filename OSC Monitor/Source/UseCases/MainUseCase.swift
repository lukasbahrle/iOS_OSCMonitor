//
//  MainUseCase.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 18/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine

protocol MainUseCaseType {
    /**
    Connects to a given port
     
     - Parameter port: Port number
     
     - Returns: Publisher that can throw an conection error or complete with a MessagesServiceItemType publisher
     */
    func connect(to port: UInt16) -> AnyPublisher<MessageServicePublisher, Error>
    
    /// Disconnects the current conexion
    func disconnect()
    
    /**
    Retrieves the default values
     
     - Returns: Publisher that completes with the MainDefaultValues
     */
    func getDefaultValues() -> AnyPublisher<MainDefaultValues, Never>
    
    /// Saves the defult values
    func set(defaultValues: MainDefaultValues)
}


final class MainUseCase: MainUseCaseType {
    
    private let messageService: MessagesServiceType
    private let defaultValuesService: DefaultValuesServiceType
    
    init(messageService: MessagesServiceType, defaultValuesService: DefaultValuesServiceType) {
        self.messageService = messageService
        self.defaultValuesService = defaultValuesService
    }
    
    func connect(to port: UInt16) -> AnyPublisher<MessageServicePublisher, Error>{
        return self.messageService.connect(to: port)
    }
    
    func disconnect() {
        self.messageService.disconnect()
    }

    func getDefaultValues() -> AnyPublisher<MainDefaultValues, Never>{
        let portPublisher: AnyPublisher<UInt16?, Never> = defaultValuesService.get(key: .port)
        let isGrouedByAddressPublisher: AnyPublisher<Bool?, Never> = defaultValuesService.get(key: .groupedByAddress)
        
        return Publishers.Zip(portPublisher, isGrouedByAddressPublisher)
            .map{ (port, isGrouped) -> MainDefaultValues in
                return MainDefaultValues(port: port ?? 8080, isGroupedByAddress: isGrouped ?? false)
        }
        .eraseToAnyPublisher()
    }
    
    func set(defaultValues: MainDefaultValues){
        defaultValuesService.set(value: .port(defaultValues.port))
        defaultValuesService.set(value: .groupedByAddress(defaultValues.isGroupedByAddress))
    }
}
