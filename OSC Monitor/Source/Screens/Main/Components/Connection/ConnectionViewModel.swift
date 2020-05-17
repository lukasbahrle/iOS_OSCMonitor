//
//  ConnectionViewModel.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 17/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine


class ConnectionViewModel: ConnectionViewModelOutputType{
    
    private var connectionButtonStateMachine = ConnectionButtonStateMachine()
    
    /// subjects
    private var localIPAddressSubject = CurrentValueSubject<String, Never>("")
    private var portTextSubject = CurrentValueSubject<String, Never>("")
    private var portPlaceholderSubject = CurrentValueSubject<String, Never>("")
    
    /// output
    var localIPAddress: String { localIPAddressSubject.value }
    var portText: String { portTextSubject.value }
    var portPlaceholder: String { portPlaceholderSubject.value }
    var connectionButtonState: ConnectionButtonState { connectionButtonStateMachine.state }
    
    var publishers: ConnectionViewModelOutputPublishers {
        ConnectionViewModelOutputPublishers(localIPAddress: localIPAddressSubject.eraseToAnyPublisher(), portText: portTextSubject.eraseToAnyPublisher(), portPlaceholder: portPlaceholderSubject.eraseToAnyPublisher(), connectionButtonState: connectionButtonStateMachine.statePublisher)
    }
    

    var state: ConnectionState = .disconnected {
        didSet{
            switch state {
            case .disconnected:
                connectionButtonStateMachine.connect()
            case .connected(let port):
                connectionButtonStateMachine.disconnect()
                self.port = port
            }
        }
    }
    
    var port: UInt16 = 0 {
        didSet{
            portTextSubject.send("\(port)")
        }
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init(){
        localIPAddressSubject.send(ConnectionViewModel.getIPAddress() ?? "")
    }
    
    
    func update(portText: String){
       if let port = UInt16(portText) {
            switch state {
            case .connected(let currentPort):
                
                if currentPort == port {
                    connectionButtonStateMachine.disconnect()
                }
                else{
                    connectionButtonStateMachine.connect()
                }
                
            default:
                connectionButtonStateMachine.connect()
                break
            }
       }
       else{
        /// invalid port number
        connectionButtonStateMachine.connect(enabled: false)
       }
    }
    
    /// get ip address for the device
    private class func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6),
                    let cString = interface?.ifa_name,
                    String(cString: cString) == "en0",
                    let saLen = (interface?.ifa_addr.pointee.sa_len) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    let ifaAddr = interface?.ifa_addr
                    getnameinfo(ifaAddr,
                                socklen_t(saLen),
                                &hostname,
                                socklen_t(hostname.count),
                                nil,
                                socklen_t(0),
                                NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
}






