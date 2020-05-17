//
//  Appearance.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 21/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit

class Appearance{
    static let shared = Appearance(theme: Theme.defaultTheme())
    private(set) var theme: Theme
    
    private init(theme: Theme) {
        self.theme = theme
    }
    
    func update(theme: Theme){
        self.theme = theme
    }
    
    func applyGlobalTheming(window: UIWindow){
        window.tintColor = theme.tintColor
        UISwitch.appearance().onTintColor = theme.tintColor
        
        UITextField.appearance().backgroundColor = theme.tableBackgroundColor
        
        
        let navigationBarStyle = UINavigationBarAppearance()
        navigationBarStyle.configureWithOpaqueBackground()
        navigationBarStyle.backgroundColor = theme.navbarBackgroundColor
         
        UINavigationBar.appearance().standardAppearance = navigationBarStyle
    }
}
