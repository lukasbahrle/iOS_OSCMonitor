//
//  AddressCellViewModelTests.swift
//  OSC MonitorTests
//
//  Created by Lukas Bahrle Santana on 03/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import XCTest
@testable import OSC_Monitor

class AddressCellViewModelTests: XCTestCase {

    override func setUp() {
       
    }

    override func tearDown() {
       
    }

     func testData(){
            let viewModel = AddressCellViewModel(id: "address_1", isSelected: true, title: "address_1", isTopSeparator: false)
            
            XCTAssertEqual(viewModel.title, "address_1")
            XCTAssertEqual(viewModel.isSelected, true)
            XCTAssertEqual(viewModel.isTopSeparator, false)
       }

}
