//
//  TableViewSeparatorView.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 12/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func createCustomTopSeparatorView() -> UIView{
        let sep = UIView(frame: .zero)
        contentView.addSubview(sep)
        sep.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sep.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            sep.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            sep.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            sep.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        return sep
    }
}
