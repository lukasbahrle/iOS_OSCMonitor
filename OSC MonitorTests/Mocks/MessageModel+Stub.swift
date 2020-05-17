//
//  MessageModel+Stub.swift
//  OSC MonitorTests
//
//  Created by Lukas Bahrle Santana on 04/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
@testable import OSC_Monitor


extension Message{
    static func stub(address: String = "message_address", arguments: [Any] = []) -> Message{
        return Message(addressPattern: address, arguments: arguments)
    }
}
