//
//  BundleModel.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 24/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation


protocol BundleModelType{
    var timeTag: Date {get}
    var messages: [MessageType] {get}
}

struct BundleModel: BundleModelType{
    let timeTag: Date
    let messages: [MessageType]
}

