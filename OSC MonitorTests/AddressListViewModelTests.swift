//
//  AddressListViewModelTests.swift
//  OSC MonitorTests
//
//  Created by Lukas Bahrle Santana on 03/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import XCTest
@testable import OSC_Monitor

class AddressListViewModelTests: XCTestCase {

    var viewModel : AddressListViewModel!
    
    override func setUp() {
        super.setUp()
        self.viewModel = AddressListViewModel()
    }

    override func tearDown() {
        super.tearDown()
        self.viewModel = nil
    }

    func testUpdate(){
        XCTAssertEqual(self.viewModel.items.count, 0)
        
        self.viewModel.update(addresses: ["address_1", "address_2", "address_3"], filters: Set<String>())
        
        XCTAssertEqual(self.viewModel.items.count, 3)
        
    }

}
