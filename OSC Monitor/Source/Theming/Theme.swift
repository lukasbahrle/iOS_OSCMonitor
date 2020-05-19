//
//  Theme.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 21/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit


public struct ThemeStateIndicator {
    let disconnected: UIColor
    let listening: UIColor
    let paused: UIColor
    let failed: UIColor
}

public struct ThemeSizes {
    let cellHeight: CGFloat
    let tableCornerRadius: CGFloat
    let buttonCornerRadius: CGFloat
}


public struct Theme {
    public var font: UIFont
    public var tintColor: UIColor
    public var disconnectColor: UIColor
    public var navbarBackgroundColor: UIColor
    public var backgroundColor: UIColor
    public var tableBackgroundColor: UIColor
    public var tableLabelColor: UIColor
    public var tableLabelColorUnselected: UIColor
    public var stateIndicator: ThemeStateIndicator
    public var sizes: ThemeSizes
}
