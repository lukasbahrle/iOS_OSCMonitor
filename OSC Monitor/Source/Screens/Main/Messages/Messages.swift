//
//  MessagesController.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 17/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import Combine

class Messages{
    
   let updatePublisher: AnyPublisher<Bool, Never>
   private let updateSubject: PassthroughSubject<Bool, Never>
    
   private(set) var items = [MessageType]()
   private(set) var addresses = [String]()
   private(set) var addressesLastMessage = [String: Int]()
  // private(set) var addressFilters = Set<String>()
   private(set) var bundleTimeStamps = [Date]()
    
   private(set) var isPause = false
   private var messagesSubscriber: AnyCancellable?

    init(){
        updateSubject = PassthroughSubject<Bool, Never>()
        updatePublisher = updateSubject.eraseToAnyPublisher()
    }
    
    func address(at index:Int) -> String?{
        guard index < addresses.count else {return nil}
        return addresses[index]
    }
    
    func start(messagesPublisher: AnyPublisher<MessagesServiceItemType, Never>){
        stop()
        
        messagesSubscriber = messagesPublisher
        .filter{[weak self] _ in
             if let isPause = self?.isPause {
                 return !isPause
             }
             return false
        }
        .sink(receiveValue: { [weak self] message in

            if let message = message as? MessageType {
                self?.add(message: message)
                self?.updateSubject.send(true)
            }
            else if let bundle = message as? BundleModelType, var timeStamps = self?.bundleTimeStamps {
                timeStamps.append(bundle.timeTag)
                let bundleIndex = timeStamps.count - 1
                var firstItem = true
                for var item in bundle.messages {
                    if firstItem {
                        item.firstItemInBundle = true
                        firstItem = false
                    }
                    item.bundleIndex = bundleIndex
                    self?.add(message: item)
                }
                 self?.updateSubject.send(true)
            }
        })
    }
    
    func stop(){
           messagesSubscriber?.cancel()
       }
    
    func pause(_ isPause: Bool){
        self.isPause = isPause
    }
    
    func add(message: MessageType){
        
        self.items.append(message)
        
//        if items.count > 200 {
//            let address = items[0].addressPattern
//            if self.addressesLastMessage[message.addressPattern] == 0 {
//                self.addressesLastMessage.removeValue(forKey: address)
//                self.addresses = self.addresses.filter{$0 != address}
//
//                for (key, value) in addressesLastMessage {
//                    addressesLastMessage[key] = value - 1
//                }
//            }
//            items.remove(at: 0)
//        }
        
        if self.addressesLastMessage[message.addressPattern] == nil {
            self.addresses.append(message.addressPattern)
        }
        self.addressesLastMessage[message.addressPattern] = self.items.count - 1
    }

    
   
    
    func clear(updateView: Bool = true){
        self.items = []
        self.addresses = []
        self.addressesLastMessage = [:]
        if(updateView){self.updateSubject.send(true)}
    }
      
}
