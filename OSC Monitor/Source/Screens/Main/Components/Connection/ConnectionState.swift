//
//  ConnectionState.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 13/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine

enum ConnectionState{
    case disconnected
    case connected(UInt16)
}




final class ConnectionButtonStateMachine{
    var statePublisher: AnyPublisher<ConnectionButtonState, Never>
    private let stateSubject = CurrentValueSubject<ConnectionButtonState, Never>(.connectState())
    var state: ConnectionButtonState {
        stateSubject.value
    }
    
    init(){
        statePublisher = stateSubject.removeDuplicates().eraseToAnyPublisher()
    }
    
    func connect(enabled: Bool = true){
        stateSubject.send(ConnectionButtonState.connectState(enabled: enabled))
    }
    
    func disconnect(enabled: Bool = true){
        stateSubject.send(ConnectionButtonState.disconnectState(enabled: enabled))
    }
    
}



enum ConnectionButtonState{
    case connect(String, Bool)
    case disconnect(String, Bool)
    
    static func connectState(enabled: Bool = true) -> ConnectionButtonState {
        return .connect("Connect", enabled)
    }
    
    static func disconnectState(enabled: Bool = true) -> ConnectionButtonState {
        return .disconnect("Disconnect", enabled)
    }
    
    var disabled: ConnectionButtonState{
        switch self {
        case .connect(let text, _):
            return .connect(text, false)
        case .disconnect(let text, _):
            return .disconnect(text, false)
        }
    }
}



extension ConnectionButtonState: Equatable{
    static func == (lhs: ConnectionButtonState, rhs: ConnectionButtonState) -> Bool {
        switch (lhs, rhs) {
        case (.connect(_, let enabled1), .connect(_, let enabled2)):
            return enabled1 == enabled2
        case (.disconnect(_, let enabled1), .disconnect(_, let enabled2)):
            return enabled1 == enabled2
        default:
            return false
        }
    }
}
