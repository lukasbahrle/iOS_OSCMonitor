//
//  MainCoordinator.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 12/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit

/// The `MainFlowCoordinator` takes control over the flows on the main screen
class MainFlowCoordinator: FlowCoordinator {
    fileprivate let rootController: UINavigationController
    fileprivate let dependencyProvider: MainFlowCoordinatorDependencyProvider
    
    init(rootController: UINavigationController, dependencyProvider: MainFlowCoordinatorDependencyProvider) {
        self.rootController = rootController
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let vc = self.dependencyProvider.mainController(navigator: self)
        self.rootController.setViewControllers([vc], animated: false)
    }
}

extension MainFlowCoordinator: MainNavigator {}
