//
//  AddressListViewModelInputOutput.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 13/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine

protocol AddressListViewModelInputType{
    var selectAddressFilterItem: AnyPublisher<Int, Never> {get}
}

struct AddressListViewModelInput: AddressListViewModelInputType{
    let selectAddressFilterItem: AnyPublisher<Int, Never>
}


protocol AddressListViewModelOutputType{
    var items: [AddressCellViewModel] {get}
    var publishers: AddressListViewModelOutputPublishers {get}
}

struct AddressListViewModelOutputPublishers{
    let items: AnyPublisher<[AddressCellViewModel], Never>
}
