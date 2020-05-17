//
//  DefaultValuesService.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 05/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine



protocol DefaultValuesServiceType {
    func set(value: DefaultValue)
    func get<T>(key: DefaultValueKey) -> AnyPublisher<T?, Never>
}


class DefaultValuesService: DefaultValuesServiceType{
    func set(value: DefaultValue) {
        UserDefaults.standard.set(defaultValue: value)
    }
    
    func get<T>(key: DefaultValueKey) -> AnyPublisher<T?, Never>{
        return Future<T?, Never> { promise in
            guard let value = UserDefaults.standard.value(forKey: key.rawValue) as? T else{
                return promise(.success(nil))
            }
            return promise(.success(value))
        }.eraseToAnyPublisher()
    }
}

extension UserDefaults{
    func set(defaultValue: DefaultValue){
        UserDefaults.standard.set(defaultValue.value, forKey: defaultValue.key)
    }
}

