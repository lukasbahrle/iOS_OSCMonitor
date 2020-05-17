//
//  OSCService.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 12/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import OSCKit
import Combine


protocol MessagesServiceType {
    func connect(to port:UInt16) -> AnyPublisher<MessageServicePublisher, Error>
    func disconnect()
}


typealias MessageServicePublisher = AnyPublisher<MessagesServiceItemType, Never>

class MessagesService: MessagesServiceType{
    
    private let oscPublisher: PassthroughSubject<MessagesServiceItemType, Never>
    private let server = OSCServer()
    
    /// client to verify that the connection succeded
    private let client = OSCClient()
    
    private var testMessageArrived = false
    private var testing_mode = false
    
    init(testing_mode: Bool = false) {
        self.testing_mode = testing_mode
        oscPublisher = PassthroughSubject<MessagesServiceItemType, Never>()
    }
    
   
    func connect(to port:UInt16) -> AnyPublisher<MessageServicePublisher, Error>{
        server.stopListening()
        
        server.port = port
        server.delegate = self
        
        do{
            try server.startListening()
        }
        catch{
            return Fail<MessageServicePublisher, Error>(error: error).eraseToAnyPublisher()
        }
        
        testMessageArrived = false
        sendTestMessage(port: port)
        
        return Future<MessageServicePublisher, Error> { promise in
            
            // check if test message arrived
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let testMessageArrived = self?.testMessageArrived, testMessageArrived, let oscPublisher = self?.oscPublisher else{
                    return promise(.failure(NSError(domain: "messages", code: 404, userInfo: [:])))
                }
                return promise(.success(oscPublisher.eraseToAnyPublisher()))
            }
            
        }.eraseToAnyPublisher()
        
    }
    
    func disconnect() {
        server.stopListening()
    }
}


// MARK: Receive messages and bundles

extension MessagesService: OSCPacketDestination{
    
    /// recieves a messages
    func take(message: OSCMessage) {
        guard testMessageArrived else{
            testMessageArrived = true
            
            if !testing_mode {
                client.disconnect()
            }
            return
        }

        DispatchQueue.global().async { [weak self] in
            self?.oscPublisher.send(Message(addressPattern: message.addressPattern, arguments: message.arguments))
        }
    }
    
    /// receives a bundle
    func take(bundle: OSCBundle) {
        DispatchQueue.global().async { [weak self] in
        var bundleMessages = [MessageType]()
        
        for packet in bundle.elements{
            if let message = packet as? OSCMessage {
                bundleMessages.append(Message(addressPattern: message.addressPattern, arguments: message.arguments))
            }
        }
        
        let messageBundle = BundleModel(timeTag: bundle.timeTag.date(), messages: bundleMessages)
            self?.oscPublisher.send(messageBundle)
        }
    }
}



// MARK: Test message

extension MessagesService{
    func sendTestMessage(port: UInt16){
        
        /// send a test message to verify the connection
        client.port = port
        let message = OSCMessage(messageWithAddressPattern: "/test/message" + String(Int.random(in: 0 ..< 10)), arguments: [1, Float.random(in: 0.0 ..< 10.0), "test", 0.21312312, 0.434435345, 0.45435456456, "test"])
        client.send(packet: message)
        
        /// keep sending test messages in `testing_mode`
        if testing_mode {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.sendTestMessage(port: port)
            }
        }
    }
}
