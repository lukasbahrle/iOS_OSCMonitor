//
//  Theme+Defaults.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 21/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit

public extension Theme{
    static func defaultTheme() -> Theme{
        return Theme(
            font: UIFont.preferredFont(forTextStyle: .body),
            tintColor: AppColors.tint,
            disconnectColor: AppColors.cell,
            navbarBackgroundColor: AppColors.bar,
            backgroundColor: AppColors.background,
            tableBackgroundColor: AppColors.cell,
            tableLabelColor: .label,
            tableLabelColorUnselected: .tertiaryLabel
        )
    }
}
