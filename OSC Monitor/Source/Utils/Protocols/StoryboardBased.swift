//
//  StoryboardBased.swift
//  OSC Monitor
//
//  Created by Lukas Bahrle Santana on 19/04/2020.
//  Copyright © 2020 Lukas Bahrle Santana. All rights reserved.
//

import Foundation
import UIKit


protocol StoryboardBased {
    static var storyboardName: String { get }
    static var storyboardBundle: Bundle? { get }
    
    /// Instatiates a ViewController with the same storyboardIdentifier as the class name from the storyboard
    static func instantiate() -> Self
}


extension StoryboardBased where Self : UIViewController {
    static var storyboardName: String {
        return "Main"
    }
    
    static var storyboardBundle: Bundle? {
        return nil
    }
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
         let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
               return storyboard.instantiateViewController(
                   withIdentifier: storyboardIdentifier) as! Self
    }
}
