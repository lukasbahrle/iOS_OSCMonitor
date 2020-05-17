//
//  AppColors.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 10/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit


enum NamedColor: String{
    case bar
    case background
    case cell
    case tint
    case disconnect
}


struct AppColors{
    static let bar = UIColor(named: NamedColor.bar.rawValue)!
    static let background = UIColor(named: NamedColor.background.rawValue)!
    static let cell = UIColor(named: NamedColor.cell.rawValue)!
    static let tint = UIColor(named: NamedColor.tint.rawValue)!
    static let disconnect = UIColor(named: NamedColor.disconnect.rawValue)!
}
