//
//  MainState.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 15/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine



class MainStateMachine{
    
    var statePublisher: AnyPublisher<MainState, Never>
    private let stateSubject = CurrentValueSubject<MainState, Never>(.notconnected)
    var state: MainState {
        stateSubject.value
    }
    
    init(){
        statePublisher = stateSubject.removeDuplicates().eraseToAnyPublisher()
    }
    
    func tooglePause(){
        switch state {
        case .connectionListening(let port):
            stateSubject.send(.paused(port))
        case .paused(let port):
            stateSubject.send(.connectionListening(port))
        default:
            break
        }
    }
    
    func connect(port: UInt16){
        if state.isNotConnectedOrConnecting {
            stateSubject.send(.connect(port))
        }
        
        switch state {
        case .connect(let currentPort), .connectionListening(let currentPort), .paused(let currentPort):
            if currentPort != port { stateSubject.send(.connect(port))}
        default:
            break
        }
    }
    
    func disconnect(){
        if !state.isNotConnectedOrConnecting {
            stateSubject.send(.disconnect)
        }
    }
    
    
    func connectionSuccess(){
        guard state.isConnecting, let port = state.port else {return}
        stateSubject.send(.connectionListening(port))
    }
    
    func connectionFail(){
        stateSubject.send(.connectionFailure)
    }
    
}


enum MainState {
    case notconnected
    case connect(UInt16)
    case connectionListening(UInt16)
    case disconnect
    case connectionFailure
    case paused(UInt16)
    
    var isNotConnectedOrConnecting: Bool {
        switch self {
        case .notconnected, .disconnect, .connectionFailure:
            return true
        default:
            return false
        }
    }
    
    var isPaused: Bool {
        switch self {
        case .paused(_):
            return true
        default:
            return false
        }
    }
    
    var isConnecting: Bool {
        switch self {
        case .connect(_):
            return true
        default:
            return false
        }
    }
    
    var port: UInt16? {
        switch self {
        case .notconnected:
            return nil
        case .disconnect:
            return nil
        case .connect(let port):
            return port
        case .connectionListening(let port):
            return port
        case .connectionFailure:
            return nil
         case .paused(let port):
         return port
        }
    }
    
    
}

extension MainState: Equatable{
    static func == (lhs: MainState, rhs: MainState) -> Bool {
        switch (lhs, rhs) {
        case (.notconnected, .notconnected):
            return true
        case (.connect(let port1), .connect(let port2)):
        return port1 == port2
        case (.connectionListening(let port1), .connectionListening(let port2)):
        return port1 == port2
        case (.connectionFailure, .connectionFailure):
               return true
        case (.paused(let port1), .paused(let port2)):
        return port1 == port2

        default:
            return false
        }
    }
}



// MARK: Connection

extension MainState{
    func connectionState() -> ConnectionState{
        switch self {
        case .connect(let port), .connectionListening(let port), .paused(let port):
            return .connected(port)
        default:
            return .disconnected
        }
    }
}


// MARK: Message List

extension MainState{
    func massageListState() -> MessageListState{
        switch self {
        case .notconnected:
            return .notconnected
        case .connect(let port):
            return .connect(port)
        case .connectionListening(let port):
            return .connectionListening(port)
        case .connectionFailure:
            return .connectionFailure
        case .disconnect:
         return .notconnected
         case .paused(let port):
         return .paused(port)
        }
    }
}
