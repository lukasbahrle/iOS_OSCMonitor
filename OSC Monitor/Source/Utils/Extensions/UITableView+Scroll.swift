//
//  UITableView+Scroll.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 24/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func scrollToBottom(animated: Bool = true){
        guard self.numberOfSections > 0 else {return}
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            
            if indexPath.row > 0 {self.scrollToRow(at: indexPath, at: .bottom, animated: animated)}
        }
    }

    func scrollToTop(animated: Bool = true) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}
