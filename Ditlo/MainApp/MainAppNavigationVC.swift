//
//  MainAppNavigationVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class MainAppNavigationVC: UITabBarController {

    // child view controllers
    let homeVC = HomeVC()
    let searchVC = SearchVC()
    let categoriesVC = CategoriesVC()
    let cameraVC = CameraVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTabBar()
    }
    
    func configureTabBar() {
        
        self.tabBar.tintColor = ditloRed
        self.tabBar.unselectedItemTintColor = ditloGrey
        
        let homeNavigationVC = UINavigationController(rootViewController: homeVC)
        homeNavigationVC.isNavigationBarHidden = true
        homeNavigationVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home-icon")?.withRenderingMode(.alwaysTemplate), tag: 0)
        homeNavigationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10.0, right: 0.0)
        
        let searchNavigationVC = UINavigationController(rootViewController: searchVC)
        searchNavigationVC.isNavigationBarHidden = true
        searchNavigationVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "search-icon")?.withRenderingMode(.alwaysTemplate), tag: 1)
        searchNavigationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10.0, right: 0.0)
        
        let categoriesNavigationVC = UINavigationController(rootViewController: categoriesVC)
        categoriesNavigationVC.isNavigationBarHidden = true
        categoriesNavigationVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "categories-icon")?.withRenderingMode(.alwaysTemplate), tag: 2)
        categoriesNavigationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10.0, right: 0.0)
        
        let cameraNavigationVC = UINavigationController(rootViewController: cameraVC)
        cameraNavigationVC.isNavigationBarHidden = true
        cameraNavigationVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "camera-icon")?.withRenderingMode(.alwaysTemplate), tag: 3)
        cameraNavigationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10.0, right: 0.0)

        let viewControllersList: [UIViewController] = [homeNavigationVC, searchNavigationVC, categoriesNavigationVC, cameraNavigationVC]
        self.viewControllers = viewControllersList
    }
}
