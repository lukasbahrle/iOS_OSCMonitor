//
//  OSC_MonitorUITests.swift
//  OSC MonitorUITests
//
//  Created by Lukas Bahrle Santana on 03/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import XCTest

class OSC_MonitorUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialValues() {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertNotEqual(app.textFields[AccessibilityIdentifier.textInput_port.rawValue].value as! String, "")
        XCTAssertNotEqual(app.staticTexts[AccessibilityIdentifier.label_ip.rawValue].label, "")
    }

    func testPauseState() {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertEqual(app.buttons[AccessibilityIdentifier.button_pause.rawValue].label, "Pause")
        
        app.buttons[AccessibilityIdentifier.button_pause.rawValue].tap()
        
        XCTAssertEqual(app.buttons[AccessibilityIdentifier.button_pause.rawValue].label, "Resume")
        
        app.buttons[AccessibilityIdentifier.button_connect.rawValue].tap()
        
        XCTAssertEqual(app.buttons[AccessibilityIdentifier.button_pause.rawValue].label, "Pause")
        
        app.buttons[AccessibilityIdentifier.button_pause.rawValue].tap()
        
        XCTAssertEqual(app.buttons[AccessibilityIdentifier.button_pause.rawValue].label, "Pause")
    }
}
