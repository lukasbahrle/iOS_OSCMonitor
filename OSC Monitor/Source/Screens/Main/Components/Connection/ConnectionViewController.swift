//
//  InputConnectionViewController.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 03/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import UIKit
import Combine

class ConnectionViewController: UIViewController {
    
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    
    var viewModel: ConnectionViewModel!
    
    private var cancellables: [AnyCancellable] = []
    private let appear = PassthroughSubject<Void, Never>()
    private let portInput = PassthroughSubject<String, Never>()
    private let connect = PassthroughSubject<String, Never>()
    private let disconnect = PassthroughSubject<Void, Never>()
    
    private var connectionButtonConnectColor: UIColor = .blue
    private var connectionButtonDisconnectColor: UIColor = .red
    
    func initialize(viewModel: ConnectionViewModel){
        self.viewModel = viewModel
        bind(to: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }
    
    func viewModelInput() -> ConnectionViewModelInput{
        return ConnectionViewModelInput(portInput: portInput.eraseToAnyPublisher(), connect: connect.eraseToAnyPublisher(), disconnect :disconnect.eraseToAnyPublisher())
    }
    
    private func configureUI(){
        configureAccessibilityIdentifiers()
    }

    // MARK: View Model binding
    
    func bind(to viewModel: ConnectionViewModel){
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let viewModelPublishers = viewModel.publishers

        viewModelPublishers.localIPAddress
        .receive(on: RunLoop.main)
        .sink(receiveValue: {[unowned self] address in
            self.ipLabel.text = address
        })
        .store(in: &cancellables)

        viewModelPublishers.portText
            .sink(receiveValue: {[unowned self] port in
                self.inputTextField.text = port
            })
            .store(in: &cancellables)
        
        viewModelPublishers.portPlaceholder
        .sink(receiveValue: {[unowned self] port in
            self.inputTextField.placeholder = port
        })
        .store(in: &cancellables)

        viewModelPublishers.connectionButtonState
        .sink(receiveValue: {[weak self] state in
            self?.updateConnectionButton(for: state)
        })
        .store(in: &cancellables)
    }
    
    private func updateConnectionButton(for state: ConnectionButtonState){
        
        switch state {
        case .connect(let text, let enabled):
            connectButton.setTitle(text, for: .normal)
            connectButton.setBackgroundColor(connectionButtonConnectColor, with: self.traitCollection, for: .normal)
            connectButton.isEnabled = enabled
        case .disconnect(let text, let enabled):
            connectButton.setTitle(text, for: .normal)
            connectButton.setBackgroundColor(connectionButtonDisconnectColor, with: self.traitCollection, for: .normal)
            connectButton.isEnabled = enabled
        }
    }
    
    // MARK: Actions
    
    @IBAction func onConnectTap(_ sender: Any) {
        inputTextField.resignFirstResponder()
        
        switch viewModel.connectionButtonState {
        case .connect(_):
            connect.send(inputTextField.text ?? "")
        case .disconnect(_):
            disconnect.send()
        }
    }
    
    
    @IBAction func onInputTextDidChange(_ sender: Any) {
        portInput.send(inputTextField.text ?? "")
    }
}


// MARK: Theming

extension ConnectionViewController: Themeable{
    func apply(theme: Theme) {
        self.view.backgroundColor = theme.backgroundColor
        
        connectionButtonConnectColor = theme.tintColor
        connectionButtonDisconnectColor = theme.disconnectColor
        
        connectButton.layer.cornerRadius = theme.sizes.buttonCornerRadius
        connectButton.layer.masksToBounds = true
        connectButton.setTitleColor(.white, for: .normal)
        updateConnectionButton(for: viewModel.connectionButtonState)
    }
}


// MARK: Accessibility Identifiers

extension ConnectionViewController{
    private func configureAccessibilityIdentifiers(){
        ipLabel.accessibilityIdentifier = AccessibilityIdentifier.label_ip.rawValue
        inputTextField.accessibilityIdentifier = AccessibilityIdentifier.textInput_port.rawValue
        connectButton.accessibilityIdentifier = AccessibilityIdentifier.button_connect.rawValue
    }
}
