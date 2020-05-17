//
//  ConnectionViewModelTests.swift
//  OSC MonitorTests
//
//  Created by Lukas Bahrle Santana on 04/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import XCTest
@testable import OSC_Monitor

class ConnectionViewModelTests: XCTestCase {

    var viewModel: ConnectionViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ConnectionViewModel()
    }

    override func tearDown() {
        super.tearDown()
        self.viewModel = nil
    }


}
