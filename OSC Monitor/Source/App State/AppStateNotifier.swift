//
//  AppStateNotifier.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 06/05/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit

protocol AppStateNotifierType {
    typealias Completion = () -> ()

    var onEnterBackground: Completion? { get set }
    var onEnterForeground: Completion? { get set }
}

class AppStateNotifier: AppStateNotifierType {
    var onEnterBackground: Completion?
    var onEnterForeground: Completion?

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func appDidEnterBackgroundNotification() {
        
        self.onEnterBackground?()
    }

    @objc func appWillEnterForegroundNotification() {
        self.onEnterForeground?()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
