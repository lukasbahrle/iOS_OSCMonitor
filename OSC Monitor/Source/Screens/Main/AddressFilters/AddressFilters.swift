//
//  AddressFilters.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 17/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine

final class AddressFilters{
    let updatePublisher: AnyPublisher<Bool, Never>
    private let updateSubject: PassthroughSubject<Bool, Never>
    
    private(set) var items = Set<String>()
    
    init(){
        updateSubject = PassthroughSubject<Bool, Never>()
        updatePublisher = updateSubject.eraseToAnyPublisher()
    }
    
    func toggleActiveState(for address:String){
        let isActive = !items.contains(address)
        updateAddressFilter(address: address, active: isActive)
    }
    
    func clear(updateView: Bool = true){
        self.items = []
    }
    
    private func updateAddressFilter(address: String, active: Bool){
        if active {
            items.insert(address)
        }
        else{
            items.remove(address)
        }
        self.updateSubject.send(true)
    }
}
