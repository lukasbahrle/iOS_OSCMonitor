//
//  MessageListViewModelInputTests.swift
//  OSC MonitorTests
//
//  Created by Lukas Bahrle Santana on 29/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//
import Combine
import XCTest
@testable import OSC_Monitor

class MessageListViewModelInputTests: XCTestCase {

    var viewModel : MessageListViewModel!
    //var useCase:MessageListUseCase!
    //var groupByAddressPublisher:PassthroughSubject<Bool, Never>!
    //var clearPublisher:PassthroughSubject<Void, Never>!
    //var togglePublisher:PassthroughSubject<Void, Never>!
    //var clearTriggerCounter = 0
    //var togglePauseCounter = 0
    
    
    
    
    override func setUp() {
        super.setUp()
        
        //groupByAddressPublisher = PassthroughSubject<Bool, Never>()
        //clearPublisher = PassthroughSubject<Void, Never>()
        //togglePublisher = PassthroughSubject<Void, Never>()
        
        //clearTriggerCounter = 0
        //togglePauseCounter = 0
        //useCase = MessageListUseCase(clear: {self.clearTriggerCounter+=1}, togglePaused: {self.togglePauseCounter+=1})
        self.viewModel = MessageListViewModel()
        
        //self.viewModel.bind(to: MessageListViewModelInput(groupByAddress: groupByAddressPublisher.eraseToAnyPublisher(), clear: clearPublisher.eraseToAnyPublisher(), togglePaused: togglePublisher.eraseToAnyPublisher()))
              
    }

    override func tearDown() {
        self.viewModel = nil
        //self.useCase = nil
        super.tearDown()
    }

    func testUpdateMessages() {
        
        let message_0 = Message(addressPattern: "address_message_0", arguments: [1])
        let message_1 = Message(addressPattern: "address_message_1", arguments: [1])
        let message_2 = Message(addressPattern: "address_message_2", arguments: [1])
        
        var messages = [message_0]

        self.viewModel.update(items: messages, addresses: [], addressesLastMessage: [:], addressFilters: Set<String>())
        
        XCTAssertEqual(self.viewModel.items.count, 1)
        
        messages.append(message_1)
        messages.append(message_2)
        
        
        self.viewModel.update(items: messages, addresses: [], addressesLastMessage: [:], addressFilters: Set<String>())
        
        XCTAssertEqual(self.viewModel.items.count, 3)
        
        XCTAssertEqual(self.viewModel.items[1].id, message_1.id)
        
        XCTAssertEqual(self.viewModel.items[1].address, message_1.addressPattern)
        
        // empty
        self.viewModel.update(items: [], addresses: [], addressesLastMessage: [:], addressFilters: Set<String>())
        
        XCTAssertEqual(self.viewModel.items.count, 0)
        
    }
    
    
    func testGroupByAddresses() {
        
        let messages = [
            Message(addressPattern: "address_message_0", arguments: [1]),
            Message(addressPattern: "address_message_1", arguments: [1]),
            Message(addressPattern: "address_message_0", arguments: [2]),
            Message(addressPattern: "address_message_1", arguments: [3]),
            Message(addressPattern: "address_message_2", arguments: [1]),
            Message(addressPattern: "address_message_1", arguments: [4]),
            Message(addressPattern: "address_message_1", arguments: [0])
        ]
        
        let addresses = [
            "address_message_0",
            "address_message_1",
            "address_message_2"
        ]
        
        let addressesLastMessage = [
            "address_message_0": 2,
            "address_message_1": 6,
            "address_message_2": 4
        ]
        
        let filters = Set<String>()

        self.viewModel.update(items: messages, addresses: addresses, addressesLastMessage: addressesLastMessage, addressFilters: filters)
        
        XCTAssertEqual(self.viewModel.items.count, 7)
        
        XCTAssertFalse(self.viewModel.isGroupedByAddress)
        
        
        viewModel.update(isGroupedByAddress: true)
        
        XCTAssertTrue(self.viewModel.isGroupedByAddress)
        
        // check message count
        XCTAssertEqual(self.viewModel.items.count, 3)
        
        // check order addresses
        XCTAssertEqual(self.viewModel.items[0].address, "address_message_0")
        XCTAssertEqual(self.viewModel.items[1].address, "address_message_1")
        XCTAssertEqual(self.viewModel.items[2].address, "address_message_2")
        
        // check if arguments from last message with this address
        XCTAssertEqual("\(self.viewModel.items[0].arguments[0])", "2")
        XCTAssertEqual("\(self.viewModel.items[1].arguments[0])", "0")
        XCTAssertEqual("\(self.viewModel.items[2].arguments[0])", "1")
    }
    
    
    func testAddressFilters(){
        let messages = [
            Message(addressPattern: "address_message_0", arguments: [1]),
            Message(addressPattern: "address_message_1", arguments: [1]),
            Message(addressPattern: "address_message_0", arguments: [2]),
            Message(addressPattern: "address_message_1", arguments: [3]),
            Message(addressPattern: "address_message_2", arguments: [1]),
            Message(addressPattern: "address_message_1", arguments: [4]),
            Message(addressPattern: "address_message_1", arguments: [0])
        ]
        
        let addresses = [
            "address_message_0",
            "address_message_1",
            "address_message_2"
        ]
        
        let addressesLastMessage = [
            "address_message_0": 2,
            "address_message_1": 6,
            "address_message_2": 4
        ]
        
        var filters = Set<String>()

        self.viewModel.update(items: messages, addresses: addresses, addressesLastMessage: addressesLastMessage, addressFilters: filters)
        
        XCTAssertEqual(self.viewModel.items.count, 7)
        
        filters.insert("address_message_0")
        
        self.viewModel.update(items: messages, addresses: addresses, addressesLastMessage: addressesLastMessage, addressFilters: filters)
              
        XCTAssertEqual(self.viewModel.items.count, 2)
        
        filters.insert("address_message_1")
        
        self.viewModel.update(items: messages, addresses: addresses, addressesLastMessage: addressesLastMessage, addressFilters: filters)
        
        XCTAssertEqual(self.viewModel.items.count, 6)
        
        filters.removeAll()
        
        self.viewModel.update(items: messages, addresses: addresses, addressesLastMessage: addressesLastMessage, addressFilters: filters)
        
        XCTAssertEqual(self.viewModel.items.count, 7)
    }
    
    
//    func testClearUseCase(){
//        self.clearPublisher.send()
//        XCTAssertEqual(self.clearTriggerCounter, 1)
//    }
//
//    func testTooglePauseUseCase(){
//        self.togglePublisher.send()
//        XCTAssertEqual(self.togglePauseCounter, 1)
//    }
//
    


}

