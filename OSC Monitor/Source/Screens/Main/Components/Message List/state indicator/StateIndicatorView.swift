//
//  StateIndicatorView.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 11/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import UIKit


enum StateIndicatorState{
    case disconnected
    case connected
    case paused
    case failure
}



class StateIndicatorView: UIView {
    
    private var disconnectedColor: UIColor = .white
    private var connectedColor: UIColor = .white
    private var pausedColor: UIColor = .white
    private var failureColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI(){
        self.layer.cornerRadius = self.frame.size.width * 0.5
        self.layer.masksToBounds = true
    }
    
    func update(state: StateIndicatorState){
        switch state {
        case .disconnected:
            self.backgroundColor = disconnectedColor
        case .connected:
            self.backgroundColor = connectedColor
        case .paused:
            self.backgroundColor = pausedColor
        case .failure:
            self.backgroundColor = failureColor
        }
    }

}


extension StateIndicatorView: Themeable{
    func apply(theme: Theme) {
        disconnectedColor = theme.stateIndicator.disconnected
        connectedColor = theme.stateIndicator.listening
        pausedColor = theme.stateIndicator.paused
        failureColor = theme.stateIndicator.failed
    }
    
    
}
