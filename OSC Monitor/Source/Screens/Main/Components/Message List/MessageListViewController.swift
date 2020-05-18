//
//  InputDataViewController.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 03/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import UIKit
import Combine

class MessageListViewController: UIViewController {
    
    typealias Section = String
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupByAddressSwitch: UISwitch!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stateIndicatorView: StateIndicatorView!
    
    private var viewModel: MessageListViewModel!
    
    private let groupByAddress = PassthroughSubject<Bool, Never>()
    private let clear = PassthroughSubject<Void, Never>()
    private let togglePaused = PassthroughSubject<Void, Never>()
    private var cancellables: [AnyCancellable] = []
    
    private var datasource:UITableViewDiffableDataSource<Section, MessageCellViewModel>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, MessageCellViewModel>!
    
    
    func initialize(viewModel: MessageListViewModel){
        self.viewModel = viewModel
        bind(to: viewModel)
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
       configureUI()
    }
    
    func configureUI(){
        configureAccessibilityIdentifiers()
        configureDataSource()
        
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    func viewModelInput() -> MessageListViewModelInput {
        return MessageListViewModelInput(groupByAddress: groupByAddress.eraseToAnyPublisher(), clear: clear.eraseToAnyPublisher(), togglePaused: togglePaused.eraseToAnyPublisher())
    }
    
    // MARK: View Model binding
    
    func bind(to viewModel: MessageListViewModel){
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
  
        let viewModelPublishers = viewModel.publishers
        
        viewModelPublishers.items
        .receive(on: RunLoop.main)
        .sink(receiveValue: {[weak self] items in
            self?.applyDataSourceSnapshot(for: items)
            self?.tableView.scrollToBottom(animated: false)
        })
        .store(in: &cancellables)
        
        viewModelPublishers.isGroupedByAddress
        .receive(on: RunLoop.main)
        .sink(receiveValue: {[unowned self] isGrouped in
            self.groupByAddressSwitch.isOn = isGrouped
        })
        .store(in: &cancellables)
        
        viewModelPublishers.state
        .receive(on: RunLoop.main)
        .sink(receiveValue: {
            [weak self] state in
            
            self?.stateLabel.text = state.info
            self?.pauseButton.setTitle(state.pauseButtonText, for: .normal)
            
            self?.stateIndicatorView.update(state: state.indicatorState)
        })
        .store(in: &cancellables)
    }
    
    
    // MARK: Actions
    
    @IBAction func onGroupByAddressTap(_ sender: UISwitch) {
        groupByAddress.send(sender.isOn)
    }
    
    @IBAction func onClearTap(_ sender: Any) {
        clear.send()
    }
    
    @IBAction func onTogglePauseTap(_ sender: Any) {
        togglePaused.send()
    }
}


extension MessageListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: Table view

private extension MessageListViewController {
    private func configureDataSource(){
        datasource = UITableViewDiffableDataSource(tableView: self.tableView, cellProvider: { (tableView, indexPath, messageViewModel) -> UITableViewCell? in
            let cell: MessageCell = tableView.dequeue(indexPath: indexPath)
            cell.initialize(viewModel: messageViewModel)
            return cell
        })
    }
    
    private func applyDataSourceSnapshot(for items: [MessageCellViewModel]){
        self.snapshot = NSDiffableDataSourceSnapshot()
        self.snapshot.appendSections(["Messages"])
        self.snapshot.appendItems(items)
        self.datasource.apply(self.snapshot, animatingDifferences: false, completion: nil);
    }
}


// MARK: Theming

extension MessageListViewController: Themeable{
    func apply(theme: Theme) {
        
        self.view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.tableBackgroundColor
        tableView.layer.cornerRadius = 6
        tableView.layer.masksToBounds = true
        //groupByAddressSwitch.onTintColor = theme.tintColor
        
        //pauseButton.setBackgroundColor(theme.tableBackgroundColor, for: .normal)
         pauseButton.backgroundColor = theme.tableBackgroundColor
        pauseButton.layer.cornerRadius = 6
        pauseButton.layer.masksToBounds = true
        pauseButton.setTitleColor(.white, for: .normal)
        pauseButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        clearButton.backgroundColor = theme.tableBackgroundColor
        clearButton.layer.cornerRadius = 6
        clearButton.layer.masksToBounds = true
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        stateIndicatorView.apply(theme: theme)
    }
}



// MARK: Accessibility Identifiers

extension MessageListViewController{
    private func configureAccessibilityIdentifiers(){
        pauseButton.accessibilityIdentifier = AccessibilityIdentifier.button_pause.rawValue
        clearButton.accessibilityIdentifier = AccessibilityIdentifier.button_clear.rawValue
        stateIndicatorView.accessibilityIdentifier = AccessibilityIdentifier.view_state_indicator.rawValue;
    }
}
