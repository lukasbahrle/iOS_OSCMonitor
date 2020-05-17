//
//  ViewModelBased.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 19/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit

protocol ViewModelBased: class {
    associatedtype ViewModel
    var viewModel: ViewModel! { get set }
}

extension ViewModelBased where Self: StoryboardBased & UIViewController {
    /// Instatiates the ViewController from the storyboard and sets the view model
    static func instantiate (with viewModel: ViewModel) -> Self {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ViewModelBased where Self: AppStateNotifiable & StoryboardBased & UIViewController {
    /// Instatiates the ViewController from the storyboard and sets the view model and a app state notifier
    static func instantiate (with viewModel: ViewModel, appStateNotifier: AppStateNotifierType) -> Self {
        var viewController = Self.instantiate()
        viewController.viewModel = viewModel
        viewController.appStateNotifier = appStateNotifier
        return viewController
    }
}

