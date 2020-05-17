//
//  OSCServiceMessageModelType.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 24/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation

/// Items sent by the message service publisher. Can be single messages or bundles
protocol MessagesServiceItemType {}


extension Message: MessagesServiceItemType{}
extension BundleModel: MessagesServiceItemType{}
