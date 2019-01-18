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
    func addCustomModalViewsToNavigationController() {
        // universal custom overlay modal
        let customModalOverlay = CustomModalOverlay()
        self.view.addSubview(customModalOverlay)
        customModalOverlay.fillSuperview()
        
        // error message modal
        let errorMessageModal = CustomErrorMessageModal()
        self.view.addSubview(errorMessageModal)
        errorMessageModal.fillSuperview()
        
        // info window modal
        let infoWindowModal = CustomInfoWindowModal()
        self.view.addSubview(infoWindowModal)
        infoWindowModal.fillSuperview()
    }
    
    
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
    
    
    /*--
        error message modal methods -- we will close it from within
    --*/
    func showErrorMessageModal(withErrorMessageConfig errorMessageConfig: CustomErrorMessageConfig) {
        for subview in self.view.subviews {
            if let errorMessageModal = subview as? CustomErrorMessageModal {
                errorMessageModal.showErrorMessageContainer(withErrorMessageConfig: errorMessageConfig)
            }
        }
    }
    
    
    /*--
        info window modal methods -- we will close it from within
    --*/
    func showInfoWindowModal(withInfoWindowConfig infoWindowConfig: CustomInfoMessageConfig, andAnimation needsAnimation: Bool = false) {
        for subview in self.view.subviews {
            if let infoWindowModal = subview as? CustomInfoWindowModal {
                infoWindowModal.showInfoWindowModal(withInfoWindowConfig: infoWindowConfig, andAnimation: needsAnimation)
            }
        }
    }
}
