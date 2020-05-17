//
//  AppFlowCoordinatorDependencyProvider.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 04/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import UIKit

/// The `AppFlowCoordinatorDependencyProvider` protocol defines methods to satisfy external dependencies of the AppFlowCoordinator
protocol AppFlowCoordinatorDependencyProvider: class {
    /// Creates UIViewController
    func rootViewController() -> UINavigationController
}

protocol MainFlowCoordinatorDependencyProvider: class {
    /// Creates the main UIViewController
    func mainController(navigator: MainNavigator) -> UIViewController
}
