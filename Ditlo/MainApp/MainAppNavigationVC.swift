//
//  MainAppNavigationVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class MainAppNavigationVC: UITabBarController {

    let homeVC = HomeVC()
    let searchVC = SearchVC()
    let cameraVC = CameraVC()
    let categoriesVC = CategoriesVC()
    let profileVC = MyProfileVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        getCurrentUserData()
        configureTabBar()
    }
    
    func getCurrentUserData() {
        UserService.instance.getCurrentUserDataFromCloudFirestore { (gotCurrentUserProfileDataSuccessfully) in
            if gotCurrentUserProfileDataSuccessfully {
                self.homeVC.appHasCurrentUserData()
            }
        }
    }
    
    func configureTabBar() {
        self.tabBar.tintColor = ditloRed
        self.tabBar.unselectedItemTintColor = ditloGrey
        self.tabBar.isTranslucent = true
        
        let homeNavigationVC = UINavigationController(rootViewController: homeVC)
        homeNavigationVC.navigationBar.backgroundColor = .white
        homeNavigationVC.view.backgroundColor = .white
        homeNavigationVC.interactivePopGestureRecognizer?.isEnabled = false
        homeNavigationVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home-icon")?.withRenderingMode(.alwaysTemplate), tag: 0)
        homeNavigationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10.0, right: 0.0)
        
        let searchNavigationVC = UINavigationController(rootViewController: searchVC)
        searchNavigationVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "search-icon")?.withRenderingMode(.alwaysTemplate), tag: 1)
        searchNavigationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10.0, right: 0.0)
        
        let cameraNavigationVC = UINavigationController(rootViewController: cameraVC)
        cameraNavigationVC.isNavigationBarHidden = true
        cameraNavigationVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "camera-icon")?.withRenderingMode(.alwaysTemplate), tag: 2)
        cameraNavigationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10.0, right: 0.0)
        
        let categoriesNavigationVC = UINavigationController(rootViewController: categoriesVC)
        categoriesNavigationVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "categories-icon")?.withRenderingMode(.alwaysTemplate), tag: 3)
        categoriesNavigationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10.0, right: 0.0)
        
        let profileNavigationVC = UINavigationController(rootViewController: profileVC)
        profileNavigationVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile-icon")?.withRenderingMode(.alwaysTemplate), tag: 4)
        profileNavigationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10.0, right: 0.0)

        let viewControllersList: [UIViewController] = [homeNavigationVC, searchNavigationVC, cameraNavigationVC, categoriesNavigationVC, profileNavigationVC]
        self.viewControllers = viewControllersList
    }
}
