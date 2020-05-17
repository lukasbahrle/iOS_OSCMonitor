//
//  AppComponentsFactory.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 04/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit

final class AppComponentsFactory {
    
   private let servicesProvider: ServicesProvider
    
   init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider()) {
       self.servicesProvider = servicesProvider
   }
}

extension AppComponentsFactory: AppFlowCoordinatorDependencyProvider {

    func rootViewController() -> UINavigationController {
        let rootViewController = UINavigationController()
        return rootViewController
    }
}

extension AppComponentsFactory: MainFlowCoordinatorDependencyProvider {
    func mainController(navigator: MainNavigator) -> UIViewController {
        let useCase = MainUseCase(messageService: servicesProvider.messages, defaultValuesService: servicesProvider.defaultValues)
        
        let viewModel = MainViewModel(useCase: useCase, navigator: navigator)
        let vc = MainViewController.instantiate(with: viewModel, appStateNotifier: AppStateNotifier())
        return vc
    }
}








