//
//  AddressCell.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 15/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var titleView: UILabel!
       
    private var viewModel: AddressCellViewModelType!
    
    private var labelColor: UIColor?
    private var labelColorUnselected: UIColor?
    
    private lazy var separatorView: UIView = createCustomTopSeparatorView()

    func initialize(viewModel: AddressCellViewModelType){
       self.viewModel = viewModel
       bind(to: viewModel)
    }

    override func awakeFromNib() {
       super.awakeFromNib()
        selectionStyle = .none
    }
    
    // MARK: View Model binding
    
    func bind(to viewModel: AddressCellViewModelType) {
       titleView.text = viewModel.title
       titleView.textColor = viewModel.isSelected ? labelColor : labelColorUnselected
        separatorView.isHidden = !viewModel.isTopSeparator
    }
}


// MARK: Theming

extension AddressCell: Themeable{
    func apply(theme: Theme) {
        backgroundColor = .clear
        labelColor = theme.tableLabelColor
        labelColorUnselected = theme.tableLabelColorUnselected
        separatorView.backgroundColor = theme.backgroundColor
    }
}
