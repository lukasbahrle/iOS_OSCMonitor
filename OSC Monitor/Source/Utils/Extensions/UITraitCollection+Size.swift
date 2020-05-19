//
//  UITraitCollection+Size.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 19/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit

enum TraitCollectionSizeType{
    case regular
    case compact
}

struct TraitCollectionSize{
    let width: TraitCollectionSizeType
    let height: TraitCollectionSizeType
}


extension UITraitCollection{
    func traitCollectionSize() -> TraitCollectionSize{
        let width: TraitCollectionSizeType = self.horizontalSizeClass == .compact ? .compact : .regular
        let height: TraitCollectionSizeType = self.horizontalSizeClass == .compact ? .compact : .regular
        return TraitCollectionSize(width: width, height: height)
    }
}
