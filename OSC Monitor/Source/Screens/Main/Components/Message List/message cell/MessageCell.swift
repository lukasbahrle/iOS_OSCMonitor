//
//  InputMessageCell.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 14/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var argumentsLabel: UILabel!
    
    private lazy var separatorView: UIView = createCustomTopSeparatorView()
    
    private var viewModel: InputMessageCellViewModelType!
    
    func initialize(viewModel: InputMessageCellViewModelType){
        self.viewModel = viewModel
        bind(to: viewModel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configureUI()
    }
    
    // MARK: View Model binding
    
    func bind(to viewModel: InputMessageCellViewModelType) {
        addressLabel.text = viewModel.address
        argumentsLabel.text = viewModel.argumentsToText
        separatorView.isHidden = !viewModel.isTopSeparator
    }
    
    private func configureUI(){}

}

// MARK: Theming

extension MessageCell: Themeable{
    func apply(theme: Theme) {
        backgroundColor = theme.tableBackgroundColor
        addressLabel.textColor = theme.tableLabelColor
        separatorView.backgroundColor = theme.backgroundColor
        
        argumentsLabel.textColor = .systemGray
    }
}
