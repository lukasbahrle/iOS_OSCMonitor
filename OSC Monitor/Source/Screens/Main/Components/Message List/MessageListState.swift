//
//  MessageListState.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 13/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation

enum MessageListState{
    case notconnected
    case connect(UInt16)
    case connectionListening(UInt16)
    case connectionFailure
    case paused(UInt16)
    
    var info: String {
        switch self {
        case .notconnected:
            return "Connect to start"
        case .connect(let port):
            return "Listening: \(port)"
        case .connectionListening(let port):
            return "Listening: \(port)"
        case .connectionFailure:
            return "Connection failure"
        case .paused(let port):
            return "Paused: \(port)"
        }
    }
    
    var pauseButtonText: String{
        switch self {
        case .paused(_):
            return "Resume"
        default:
            return "Pause"
        }
    }
    
    var indicatorState: StateIndicatorState{
        switch self {
        case .notconnected:
            return .disconnected
        case .connect(_):
            return .connected
        case .connectionListening(_):
            return .connected
        case .connectionFailure:
            return .failure
        case .paused(_):
            return .paused
        }
    }
}
