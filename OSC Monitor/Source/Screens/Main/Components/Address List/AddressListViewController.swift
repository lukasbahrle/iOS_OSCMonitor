//
//  InputAddressesViewController.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 03/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import UIKit
import Combine

class AddressListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: AddressListViewModel!
       
    private let selection = PassthroughSubject<Int, Never>()
    private var cancellables: [AnyCancellable] = []
    
    private var datasource:UITableViewDiffableDataSource<String, AddressCellViewModel>!
    private var snapshot: NSDiffableDataSourceSnapshot<String, AddressCellViewModel>!
       
    private var cellHeight: CGFloat = 44
    
    func initialize(viewModel: AddressListViewModel){
        self.viewModel = viewModel
        bind(to: viewModel)
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
       configureUI()
    }
    
    func viewModelInput() -> AddressListViewModelInput{
        return AddressListViewModelInput(selectAddressFilterItem: selection.eraseToAnyPublisher())
    }
    
    func configureUI(){
        configureAccessibilityIdentifiers()
        configureDataSource()
        tableView.delegate = self
    }
    
     // MARK: View Model binding
    
    func bind(to viewModel: AddressListViewModel){
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let viewModelPublishers = viewModel.publishers
        
        viewModelPublishers.items
        .receive(on: RunLoop.main)
        .sink(receiveValue: {[weak self] items in
            self?.applyDataSourceSnapshot(for: items)
        })
        .store(in: &cancellables)
    }
}



// MARK: Table view

extension AddressListViewController: UITableViewDelegate{
    private func configureDataSource(){
        datasource = UITableViewDiffableDataSource(tableView: self.tableView, cellProvider: { (tableView, indexPath, addressViewModel) -> UITableViewCell? in
            let cell: AddressCell = tableView.dequeue(indexPath: indexPath)
            cell.initialize(viewModel: addressViewModel)
            return cell
        })
    }
    
    private func applyDataSourceSnapshot(for items: [AddressCellViewModel]){
        self.snapshot = NSDiffableDataSourceSnapshot()
        self.snapshot.appendSections(["Addresses"])
        self.snapshot.appendItems(items)
        self.datasource.apply(self.snapshot, animatingDifferences: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           selection.send(indexPath.row)
           tableView.deselectRow(at: indexPath, animated: true)
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}



// MARK: Theming

extension AddressListViewController: Themeable{
    func apply(theme: Theme) {
        cellHeight = theme.sizes.cellHeight
        self.view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.tableBackgroundColor
        tableView.layer.cornerRadius = theme.sizes.tableCornerRadius
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .none
    }
}


// MARK: Accessibility Identifiers

extension AddressListViewController{
    private func configureAccessibilityIdentifiers(){}
}
