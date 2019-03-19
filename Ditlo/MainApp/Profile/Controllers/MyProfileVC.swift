//
//  MyProfileVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 2/22/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController {
    
    // views
    let myProfileNavBar = MyProfileNavBar()
    
    private let cellId: String = "cellId"
    lazy var contentSectionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.bounces = false
        cv.backgroundColor = .white
        cv.contentInsetAdjustmentBehavior = .never
        cv.register(SectionCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        edgesForExtendedLayout = []
        anchorSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMyProfileNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroyMyProfileNavBar()
    }
    
    func setupMyProfileNavBar() {
        if let myProfileNavigationController = self.navigationController {
            myProfileNavigationController.navigationBar.prefersLargeTitles = true
            myProfileNavigationController.navigationItem.hidesBackButton = true
            myProfileNavigationController.hidesBarsOnSwipe = true
            myProfileNavigationController.navigationBar.shadowImage = UIImage()
            myProfileNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            myProfileNavigationController.navigationBar.backgroundColor = .white
            myProfileNavigationController.navigationBar.addSubview(myProfileNavBar)
            myProfileNavBar.anchor(withTopAnchor: myProfileNavigationController.navigationBar.topAnchor, leadingAnchor: myProfileNavigationController.navigationBar.leadingAnchor, bottomAnchor: nil, trailingAnchor: myProfileNavigationController.navigationBar.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
            myProfileNavBar.delegate = self
            myProfileNavigationController.navigationBar.layoutIfNeeded()
        }
    }
    
    func destroyMyProfileNavBar() {
        myProfileNavBar.removeFromSuperview()
    }
    
    func anchorSubviews() {
        self.view.addSubview(contentSectionsCollectionView)
        contentSectionsCollectionView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: self.view.centerXAnchor, centreYAnchor: self.view.centerYAnchor)
    }
}

// collection view data source methods
extension MyProfileVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SectionCell else { return UICollectionViewCell() }
        sectionCell.testColour = ditloDarkBlue
        sectionCell.sectionTitle = "February 2019"
        sectionCell.delegate = self
        return sectionCell
    }
}

// collection view delegate and flow layout methods
extension MyProfileVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let dissapearingCell = cell as? SectionCell {
            dissapearingCell.resetCollectionViewPosition()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension MyProfileVC: MyProfileNavBarDelegate {
    func settingsButtonPressed() {
        let profileSettingsVC = SettingsHomeVC()
        self.navigationController?.pushViewController(profileSettingsVC, animated: true)
    }
}

extension MyProfileVC: SectionCellDelegate {
    func ditloItemCellTapped() {
    // do something here
    }
}
