//
//  MainViewModelTests.swift
//  OSC MonitorTests
//
//  Created by Lukas Bahrle Santana on 30/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import XCTest
@testable import OSC_Monitor
import Combine

class MainViewModelTests: XCTestCase {

    var viewModel : MainViewModel!
    var useCase: MockMainUseCase!
    var load:PassthroughSubject<Void, Never>!
    var appear:PassthroughSubject<Void, Never>!
    var enterBackground:PassthroughSubject<Void, Never>!
    var enterForeground:PassthroughSubject<Void, Never>!
    var portInput:PassthroughSubject<String, Never>!
    var connection:PassthroughSubject<String, Never>!
    var disconnection:PassthroughSubject<Void, Never>!
    var groupByAddress:PassthroughSubject<Bool, Never>!
    var clear:PassthroughSubject<Void, Never>!
    var togglePaused:PassthroughSubject<Void, Never>!
    var selectAddressFilterItem:PassthroughSubject<Int, Never>!
    
    
    override func setUp() {
        super.setUp()
        
        load = PassthroughSubject<Void, Never>()
        appear = PassthroughSubject<Void, Never>()
        enterBackground = PassthroughSubject<Void, Never>()
        enterForeground = PassthroughSubject<Void, Never>()
        portInput = PassthroughSubject<String, Never>()
        connection = PassthroughSubject<String, Never>()
        disconnection = PassthroughSubject<Void, Never>()
        groupByAddress = PassthroughSubject<Bool, Never>()
        clear = PassthroughSubject<Void, Never>()
        togglePaused = PassthroughSubject<Void, Never>()
        selectAddressFilterItem = PassthroughSubject<Int, Never>()
        
        self.useCase = MockMainUseCase()
        self.viewModel = MainViewModel(useCase: self.useCase, navigator: StubAppCoordinator())
        
        let input = MainViewModelInput(load: load.eraseToAnyPublisher(), appear: appear.eraseToAnyPublisher(), enterBackground: enterBackground.eraseToAnyPublisher(), enterForeground: enterForeground.eraseToAnyPublisher(), portInput: portInput.eraseToAnyPublisher(), connect: connection.eraseToAnyPublisher(), disconnect: disconnection.eraseToAnyPublisher(), groupByAddress: groupByAddress.eraseToAnyPublisher(), clear: clear.eraseToAnyPublisher(), togglePaused: togglePaused.eraseToAnyPublisher(), selectAddressFilterItem: selectAddressFilterItem.eraseToAnyPublisher())
        
        self.viewModel.bind(input: input)
    }
    
    override func tearDown() {
        super.tearDown()
        self.useCase = nil
        self.viewModel = nil
        
    }


    func testConnect() {
         
        connection.send("3000")
        
        XCTAssertEqual(self.useCase.connectionCalls.count, 1)
        
        XCTAssertEqual(self.useCase.connectionCalls[0], 3000)
        
        connection.send("3001")
        
        XCTAssertEqual(self.useCase.connectionCalls.count, 2)
        
        XCTAssertEqual(self.useCase.connectionCalls[1], 3001)
    }
    
    func testConnectInvalid() {
         
        connection.send("3000")
        
        XCTAssertEqual(self.useCase.connectionCalls.count, 1)
        
        XCTAssertEqual(self.useCase.connectionCalls[0], 3000)
        
        connection.send("3001d")
        
        XCTAssertEqual(self.useCase.connectionCalls.count, 1)
        
        XCTAssertEqual(self.useCase.connectionCalls[0], 3000)
    }
    
    func testDisconnect() {
        disconnection.send()
        XCTAssertEqual(self.useCase.disconnectionCalls, 0)
        
        connection.send("3000")
        
        disconnection.send()
        XCTAssertEqual(self.useCase.disconnectionCalls, 1)
        
        disconnection.send()
        XCTAssertEqual(self.useCase.disconnectionCalls, 1)
    }
    
    func testClear(){
        XCTAssertEqual(viewModel.messages.items.count, 0)
        
        viewModel.messages.add(message: Message.stub())
        viewModel.messages.add(message: Message.stub())
        viewModel.messages.add(message: Message.stub())
        viewModel.messages.add(message: Message.stub())
        
        XCTAssertEqual(viewModel.messages.items.count, 4)
        
        clear.send()
        
        XCTAssertEqual(viewModel.messages.items.count, 0)
    }

    func testReceiveMessages(){
        XCTAssertEqual(viewModel.messages.items.count, 0)
        
        connection.send("8000")
        
        self.useCase.testSendMessage(message: Message.stub())
        
        XCTAssertEqual(viewModel.messages.items.count, 1)
        
        self.useCase.testSendMessage(message: Message.stub())
        self.useCase.testSendMessage(message: Message.stub())
        self.useCase.testSendMessage(message: Message.stub())
        self.useCase.testSendMessage(message: Message.stub())
        self.useCase.testSendMessage(message: Message.stub())
        
        XCTAssertEqual(viewModel.messages.items.count, 6)
        
        let expectation = XCTestExpectation(description: "Message list should also be updated")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            XCTAssertEqual(self?.viewModel.components.messageListViewModel.items.count, 6)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

}


class MockMainUseCase: MainUseCaseType{
    
   private var messagesSubject = PassthroughSubject<MessagesServiceItemType, Never>()
    
   var connectionCalls: [UInt16] = []
   var disconnectionCalls: Int = 0
   var setDefaulsCalls: Int = 0
    
    func connect(to port: UInt16) -> AnyPublisher<MessageServicePublisher, Error> {
        connectionCalls.append(port)
        return Future<MessageServicePublisher, Error> { [weak self] promise in
            guard let messagesSubject = self?.messagesSubject else{
                return promise(.failure(NSError(domain: "", code: 0, userInfo: [:])))
            }
            promise(.success(messagesSubject.eraseToAnyPublisher()))
        }.eraseToAnyPublisher()
    }
    
    func disconnect() {
        disconnectionCalls += 1
    }
    
    func getDefaultValues() -> AnyPublisher<MainDefaultValues, Never> {
        return Just(MainDefaultValues(port: 3000, isGroupedByAddress: true)).eraseToAnyPublisher()
    }
    
    func set(defaultValues: MainDefaultValues) {
        setDefaulsCalls += 1
    }
    
    func connect(to port: UInt16) -> Error? {
        connectionCalls.append(port)
        return nil
    }
    
    func testSendMessage(message: MessagesServiceItemType? = nil){
        messagesSubject.send(message ?? Message.stub())
    }
}


class StubAppCoordinator: MainNavigator{
    
}


