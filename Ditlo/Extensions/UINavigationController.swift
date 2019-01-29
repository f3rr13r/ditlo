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
        animate into main app
     --*/
    func navigateIntoMainApp(withAnimation needsAnimation: Bool = false) {
        let mainAppNavigationVC = MainAppNavigationVC()
        
        if needsAnimation {
            let transition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromTop
            self.view.layer.add(transition, forKey: kCATransition)
        }
        
        self.pushViewController(mainAppNavigationVC, animated: false)
    }
}
