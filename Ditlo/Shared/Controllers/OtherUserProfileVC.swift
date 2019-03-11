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
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.setupOtherUserProfileNavigation()
            SharedModalsService.instance.hideCustomOverlayModal()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroyOtherUserProfileNavBar()
    }
    
    func setupOtherUserProfileNavigation() {
        if let otherUserProfileNavigationController = self.navigationController {
            otherUserProfileNavigationController.navigationBar.sizeToFit()
            otherUserProfileNavigationController.navigationBar.prefersLargeTitles = true
            otherUserProfileNavigationController.navigationItem.hidesBackButton = true
            otherUserProfileNavigationController.hidesBarsOnSwipe = true
            otherUserProfileNavigationController.navigationBar.shadowImage = UIImage()
            otherUserProfileNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            otherUserProfileNavigationController.navigationBar.backgroundColor = .clear
            otherUserProfileNavigationController.navigationBar.addSubview(otherUserProfileNavBar)
            otherUserProfileNavBar.fillSuperview()
            otherUserProfileNavBar.delegate = self
        }
    }
    
    func destroyOtherUserProfileNavBar() {
        otherUserProfileNavBar.removeFromSuperview()
    }
}

extension OtherUserProfileVC: OtherUserProfileNavBarDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
