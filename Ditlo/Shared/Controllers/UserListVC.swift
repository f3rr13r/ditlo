//
//  UserListVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/19/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class UserListVC: UIViewController {

    // injector variables
    var userListConfiguration: UserListConfiguration? {
        didSet {
            if let userListConfiguration = self.userListConfiguration {
                userListNavbar.userListConfiguration = userListConfiguration
            }
        }
    }
    
    let userListNavbar = UserListNavBar()
    
    private let cellId: String = "cellId"
    lazy var userListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInsetAdjustmentBehavior = .never
        cv.register(UserCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        edgesForExtendedLayout = []
        setupChildDelegates()
        anchorChildViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCustomNavigationBarContent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroyCustomNavigationBarContent()
    }
    
    func setupCustomNavigationBarContent() {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationItem.hidesBackButton = true
            navigationController.hidesBarsOnSwipe = true
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.backgroundColor = .white
            navigationController.navigationBar.addSubview(userListNavbar)
            userListNavbar.anchor(withTopAnchor: navigationController.navigationBar.topAnchor, leadingAnchor: navigationController.navigationBar.leadingAnchor, bottomAnchor: nil, trailingAnchor: navigationController.navigationBar.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
            navigationController.navigationBar.layoutIfNeeded()
        }
    }
    
    func destroyCustomNavigationBarContent() {
        userListNavbar.removeFromSuperview()
    }
    
    func setupChildDelegates() {
        userListNavbar.delegate = self
    }
    
    func anchorChildViews() {
        self.view.addSubview(userListCollectionView)
        userListCollectionView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
    }
}

// navigation bar delegate methods
extension UserListVC: UserListNavBarDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

// collection view delegate and datasource methods
extension UserListVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 93
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? UserCell else {
            return UICollectionViewCell()
        }
        return userCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (screenWidth - 56) / 3
        let height: CGFloat = width * 1.24
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12.0, left: 20.0, bottom: 24.0, right: 20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}
