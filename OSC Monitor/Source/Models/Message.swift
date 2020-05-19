//
//  MessageViewModel.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 12/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation

protocol MessageType {
    var id: UUID {get}
    var addressPattern: String {get}
    var arguments: [Any] {get}
    var firstItemInBundle: Bool {get set}
    var bundleIndex: Int {get set}
}


struct Message: MessageType{
    let id = UUID()
    let addressPattern: String
    let arguments: [Any]
    var firstItemInBundle = false
    var bundleIndex: Int = -1
}
