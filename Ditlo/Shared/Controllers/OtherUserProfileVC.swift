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
            otherUserProfileNavigationController.navigationBar.prefersLargeTitles = true
            otherUserProfileNavigationController.navigationItem.hidesBackButton = true
            otherUserProfileNavigationController.hidesBarsOnSwipe = true
            otherUserProfileNavigationController.navigationBar.shadowImage = UIImage()
            otherUserProfileNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            otherUserProfileNavigationController.navigationBar.backgroundColor = .white
            otherUserProfileNavigationController.navigationBar.addSubview(otherUserProfileNavBar)
            otherUserProfileNavBar.anchor(withTopAnchor: otherUserProfileNavigationController.navigationBar.topAnchor, leadingAnchor: otherUserProfileNavigationController.navigationBar.leadingAnchor, bottomAnchor: nil, trailingAnchor: otherUserProfileNavigationController.navigationBar.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
            otherUserProfileNavBar.delegate = self
            otherUserProfileNavigationController.navigationBar.layoutIfNeeded()
        }
    }
    
    func destroyOtherUserProfileNavBar() {
        otherUserProfileNavBar.removeFromSuperview()
    }
    
    func anchorSubviews() {
        self.view.addSubview(contentSectionsCollectionView)
        contentSectionsCollectionView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: self.view.centerXAnchor, centreYAnchor: self.view.centerYAnchor)
    }
}


// collection view data source methods
extension OtherUserProfileVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SectionCell else { return UICollectionViewCell() }
        sectionCell.testColour = ditloLightGreen
        sectionCell.sectionTitle = "February 2019"
        sectionCell.delegate = self
        return sectionCell
    }
}

// collection view delegate and flow layout methods
extension OtherUserProfileVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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

extension OtherUserProfileVC: OtherUserProfileNavBarDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OtherUserProfileVC: SectionCellDelegate {
    func ditloItemCellTapped() {
        // do something here
    }
}
