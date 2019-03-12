//
//  CategoriesVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController {
    
    // views
    let categoriesNavBar = CategoriesNavBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        edgesForExtendedLayout = []
        //anchorSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCategoriesNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroyCategoriesNavBar()
    }
    
    func setupCategoriesNavBar() {
        if let categoriesNavigationController = self.navigationController {
            categoriesNavigationController.navigationBar.prefersLargeTitles = true
            categoriesNavigationController.navigationItem.hidesBackButton = true
            categoriesNavigationController.hidesBarsOnSwipe = true
            categoriesNavigationController.navigationBar.shadowImage = UIImage()
            categoriesNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            categoriesNavigationController.navigationBar.backgroundColor = .white
            categoriesNavigationController.navigationBar.addSubview(categoriesNavBar)
            categoriesNavBar.anchor(withTopAnchor: categoriesNavigationController.navigationBar.topAnchor, leadingAnchor: categoriesNavigationController.navigationBar.leadingAnchor, bottomAnchor: nil, trailingAnchor: categoriesNavigationController.navigationBar.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
            categoriesNavBar.delegate = self
        }
    }
    
    func destroyCategoriesNavBar() {
        categoriesNavBar.removeFromSuperview()
    }
}

extension CategoriesVC: CategoriesNavBarDelegate {
    func calendarButtonPressed() {
        // open the calendar
    }
}
