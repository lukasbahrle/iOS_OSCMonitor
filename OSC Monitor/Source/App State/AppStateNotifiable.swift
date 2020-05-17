//
//  AppStateNotifiable.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 06/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit


protocol AppStateNotifiable {
    var appStateNotifier: AppStateNotifierType! { get set }
}


