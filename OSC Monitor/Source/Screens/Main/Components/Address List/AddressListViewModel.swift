//
//  AddressListViewModel.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 15/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine


class AddressListViewModel: AddressListViewModelOutputType{
    
    // subjects
    private var itemsSubject = CurrentValueSubject<[AddressCellViewModel], Never>([])
    
    // output
    var items: [AddressCellViewModel] {itemsSubject.value}
    var publishers: AddressListViewModelOutputPublishers {
        AddressListViewModelOutputPublishers(items: itemsSubject.eraseToAnyPublisher())
    }

    private var cancellables: [AnyCancellable] = []
    private var isEmptyFilters: Bool = true
    
    init(){}
    
    func update(addresses: [String], filters: Set<String>){
        isEmptyFilters = filters.count == 0
        self.itemsSubject.send(addresses.enumerated().map{(index, item) in AddressCellViewModel(id:item, isSelected: isEmptyFilters || filters.contains(item), title: item, isTopSeparator: index != 0)})
    }
}
