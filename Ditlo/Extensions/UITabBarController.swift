//
//  UITabBarController.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/12/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

extension UITabBarController {
    func setTabBarVisible(visible:Bool, duration: TimeInterval, animated:Bool) {
        if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animation
        if #available(iOS 10.0, *) {
            UIViewPropertyAnimator(duration: duration, curve: .linear) {
                self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
                self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
                self.view.setNeedsDisplay()
                self.view.layoutIfNeeded()
                }.startAnimation()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}
