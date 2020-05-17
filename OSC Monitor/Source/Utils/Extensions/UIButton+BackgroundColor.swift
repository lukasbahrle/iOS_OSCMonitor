//
//  UIButton+BackgroundColor.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 09/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor, with traitCollection: UITraitCollection, for state: UIControl.State) {
        self.setBackgroundImage(UIImage(color: color.resolvedColor(with: traitCollection)), for: state)
    }
}
