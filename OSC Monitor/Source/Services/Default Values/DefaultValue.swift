//
//  DefaultValue.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 15/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation


enum DefaultValueKey: String{
    case port
    case groupedByAddress
}

enum DefaultValue{
    case port(UInt16)
    case groupedByAddress(Bool)
    
    var key:String {
        switch self {
        case .port(_): return DefaultValueKey.port.rawValue
        case .groupedByAddress(_): return DefaultValueKey.groupedByAddress.rawValue
        }
    }
    
    var value: Any {
        switch self {
        case .port(let value): return value
        case .groupedByAddress(let value): return value
        }
    }
}
