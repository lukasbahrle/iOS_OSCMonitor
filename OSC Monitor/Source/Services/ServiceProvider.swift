//
//  ServiceProvider.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 11/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation

class ServicesProvider {
    let messages: MessagesServiceType
    let defaultValues: DefaultValuesServiceType

    static func defaultProvider() -> ServicesProvider {
        let messages = MessagesService()
        let defaultValues = DefaultValuesService()
        return ServicesProvider(messages: messages, defaultValues: defaultValues)
    }

    init(messages: MessagesServiceType, defaultValues: DefaultValuesServiceType) {
        self.messages = messages
        self.defaultValues = defaultValues
    }
}
