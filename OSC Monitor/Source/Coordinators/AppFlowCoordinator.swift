//
//  AppCoordinator.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 11/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit

class AppFlowCoordinator: FlowCoordinator{
    
    typealias DependencyProvider = AppFlowCoordinatorDependencyProvider & MainFlowCoordinatorDependencyProvider
    
    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()
    
    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let rootController = dependencyProvider.rootViewController()
        self.window.rootViewController = rootController
        let mainFlowCoordinator = MainFlowCoordinator(rootController: rootController, dependencyProvider: self.dependencyProvider)
        mainFlowCoordinator.start()

        self.childCoordinators = [mainFlowCoordinator]
        
        Appearance.shared.applyGlobalTheming(window: window)
    }
}


extension AppFlowCoordinator: MainNavigator{
    
}
