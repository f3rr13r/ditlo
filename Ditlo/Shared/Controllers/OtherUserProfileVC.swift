//
//  OtherUserProfileVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class OtherUserProfileVC: UIViewController {

    // views
    let otherUserProfileNavBar = OtherUserProfileNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // do stuff we need here
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupOtherUserProfileNavigation()
        SharedModalsService.instance.hideCustomOverlayModal()
    }
    
    func setupOtherUserProfileNavigation() {
        if let otherUserProfileNavigationController = self.navigationController {
            otherUserProfileNavigationController.navigationBar.prefersLargeTitles = true
            otherUserProfileNavigationController.hidesBarsOnSwipe = true
            otherUserProfileNavigationController.navigationItem.backBarButtonItem?.tintColor = ditloOffBlack
            otherUserProfileNavigationController.navigationItem.title = ""
            otherUserProfileNavigationController.navigationBar.addSubview(otherUserProfileNavBar)
            otherUserProfileNavBar.fillSuperview()
            otherUserProfileNavBar.delegate = self
        }
    }
}

extension OtherUserProfileVC: OtherUserProfileNavBarDelegate {
    func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
