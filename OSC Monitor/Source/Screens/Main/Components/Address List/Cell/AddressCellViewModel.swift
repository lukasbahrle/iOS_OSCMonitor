//
//  AddressViewModelCell.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 15/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation

protocol AddressCellViewModelType {
    var id:String {get}
    var isSelected: Bool {get set}
    var title:String {get}
    var isTopSeparator:Bool {get}
}


struct AddressCellViewModel: AddressCellViewModelType{
    var id:String
    var isSelected: Bool
    let title: String
    var isTopSeparator:Bool
}




extension AddressCellViewModel : Equatable, Hashable{
    static func == (lhs: AddressCellViewModel, rhs: AddressCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
