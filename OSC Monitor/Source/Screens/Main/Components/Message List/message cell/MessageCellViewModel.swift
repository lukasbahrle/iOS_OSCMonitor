//
//  InputMessageCellViewModel.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 14/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation

protocol InputMessageCellViewModelType {
    var id:UUID {get}
    var address:String {get}
    var arguments: [Any] {get}
    var argumentsToText: String {get}
    var isTopSeparator:Bool {get}
}


class MessageCellViewModel: InputMessageCellViewModelType{
    let id:UUID
    let address: String
    let argumentsToText: String
    var isTopSeparator:Bool
    let arguments: [Any]
    
    
    init(id: UUID, address: String, arguments:[Any], isTopSeparator:Bool) {
        self.id = id
        self.address = address
        self.arguments = arguments
        self.isTopSeparator = isTopSeparator
        argumentsToText = arguments.map{"\($0)"}.joined(separator: "  ")
    }
}

extension MessageCellViewModel : Equatable, Hashable{
    static func == (lhs: MessageCellViewModel, rhs: MessageCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
