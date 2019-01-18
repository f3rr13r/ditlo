//
//  UINavigationController.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/17/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /*--
         change status bar appearance per navigation controller
         child view controller
    --*/
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    
    /*--
        custom modal overlay methods
    --*/
    func showCustomOverlayModal(withMessage message: String) {
        for subview in self.view.subviews {
            if let customModalOverlay = subview as? CustomModalOverlay {
                customModalOverlay.showCustomOverlayModal(withMessage: message)
            }
        }
    }
    
    func hideCustomOverlayModal() {
        for subview in self.view.subviews {
            if let customModalOverlay = subview as? CustomModalOverlay {
                customModalOverlay.hideCustomOverlayModal()
            }
        }
    }
}
