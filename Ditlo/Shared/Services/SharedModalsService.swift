//
//  AppDelegateModals.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/29/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class SharedModalsService {
    
    static let instance = SharedModalsService()
    
    private var _appDelegate: AppDelegate?
    private var _navigationController: UINavigationController?
    
    func initializeSharedModalsMethodsClass(withAppDelegate appDelegate: AppDelegate, andNavigationController navigationController: UINavigationController) {
        _appDelegate = appDelegate
        _navigationController = navigationController
        
        addCustomModalViewsTo(navigationController: _navigationController!)
    }
    
    /*--
        add modals to parent navigation controller
     --*/
    func addCustomModalViewsTo(navigationController: UINavigationController) {
        // universal custom overlay modal
        let customModalOverlay = CustomModalOverlay()
        navigationController.view.addSubview(customModalOverlay)
        customModalOverlay.fillSuperview()
        
        // error message modal
        let errorMessageModal = CustomErrorMessageModal()
        navigationController.view.addSubview(errorMessageModal)
        errorMessageModal.fillSuperview()
        
        // info window modal
        let infoWindowModal = CustomInfoWindowModal()
        navigationController.view.addSubview(infoWindowModal)
        infoWindowModal.fillSuperview()
        
        // calendar modal
        let calendarModal = CustomCalendarModal()
        navigationController.view.addSubview(calendarModal)
        calendarModal.fillSuperview()
    }
    
    /*--
     custom overlay modal
     --*/
    func showCustomOverlayModal(withMessage message: String) {
        if let navigationController = _navigationController {
            for subview in navigationController.view.subviews {
                if let customModalOverlay = subview as? CustomModalOverlay {
                    customModalOverlay.showCustomOverlayModal(withMessage: message)
                }
            }
        }
    }
    
    func hideCustomOverlayModal() {
        if let navigationController = _navigationController {
            for subview in navigationController.view.subviews {
                if let customModalOverlay = subview as? CustomModalOverlay {
                    customModalOverlay.hideCustomOverlayModal()
                }
            }
        }
    }
    
    
    /*--
     error message modal methods -- we will close it from within
     --*/
    func showErrorMessageModal(withErrorMessageConfig errorMessageConfig: CustomErrorMessageConfig) {
        if let navigationController = _navigationController {
            for subview in navigationController.view.subviews {
                if let errorMessageModal = subview as? CustomErrorMessageModal {
                    errorMessageModal.showErrorMessageContainer(withErrorMessageConfig: errorMessageConfig)
                }
            }
        }
    }
    
    
    /*--
     info window modal methods -- we will close it from within
     --*/
    func showInfoWindowModal(withInfoWindowConfig infoWindowConfig: CustomInfoMessageConfig, andAnimation needsAnimation: Bool = false) {
        if let navigationController = _navigationController {
            for subview in navigationController.view.subviews {
                if let infoWindowModal = subview as? CustomInfoWindowModal {
                    infoWindowModal.showInfoWindowModal(withInfoWindowConfig: infoWindowConfig, andAnimation: needsAnimation)
                }
            }
        }
    }
    
    
    /*--
     calendar with date selection functionality -- we will close it from within
     --*/
    func showCalendar() {
        if let navigationController = _navigationController {
            for subview in navigationController.view.subviews {
                if let calendarModal = subview as? CustomCalendarModal {
                    calendarModal.showCalendar()
                }
            }
        }
    }
}
