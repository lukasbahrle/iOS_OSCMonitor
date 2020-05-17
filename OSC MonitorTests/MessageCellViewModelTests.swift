//
//  MessageCellViewModelTests.swift
//  OSC MonitorTests
//
//  Created by Lukas Bahrle Santana on 30/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import XCTest
@testable import OSC_Monitor

class MessageCellViewModelTests: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
       
    }

    func testData(){
        let viewModel_1 = MessageCellViewModel(id: UUID(), address: "address_message_0", arguments: ["value", 1.0, 0.2, 0.4445], isTopSeparator: false)
        
        XCTAssertEqual(viewModel_1.argumentsToText, "value  1.0  0.2  0.4445")
        XCTAssertEqual(viewModel_1.address, "address_message_0")
        
        let viewModel_2 = MessageCellViewModel(id: UUID(), address: "address_message_0", arguments: [1.0], isTopSeparator: false)
        
        XCTAssertEqual(viewModel_2.argumentsToText, "1.0")
    }
    
    func testEquatable(){
        let id = UUID()
        let viewModel_1 = MessageCellViewModel(id: id, address: "address_message_0", arguments: ["value", 1.0, 0.2, 0.4445], isTopSeparator: false)
        let viewModel_2 = MessageCellViewModel(id: id, address: "address_message_2", arguments: [1.0], isTopSeparator: false)
        
        XCTAssertEqual(viewModel_1 == viewModel_2, true)
        
        let viewModel_3 = MessageCellViewModel(id: UUID(), address: "address_message_2", arguments: [1.0], isTopSeparator: false)
        
        XCTAssertEqual(viewModel_2 == viewModel_3, false)
    }

}
