//
//  UITableView+Cell.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 14/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit


extension UITableView{
    /// Dequeues a generic Themeable cell
    func dequeue<T: UITableViewCell & Themeable>(indexPath: IndexPath) -> T{
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
        cell.apply(theme: Appearance.shared.theme)
        return cell
    }
}
