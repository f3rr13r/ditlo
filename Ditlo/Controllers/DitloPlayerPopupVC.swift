//
//  DitloPlayerPopupVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/4/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import SPStorkController

class DitloPlayerPopupVC: UIViewController {

    // views
    lazy var contentScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        return sv
    }()
    
    let testImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        let testImage = #imageLiteral(resourceName: "example-screenshot-1")
        iv.image = testImage
        iv.clipsToBounds = true
        return iv
    }()
    
    let infoContentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = ditloOffWhite
        return view
    }()
    
    let taggedFriendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Tagged Friends"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    private let userCellId: String = "userCellId"
    lazy var taggedFriendsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 107.0, height: 141.0)
        layout.minimumLineSpacing = 8.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: horizontalPadding, bottom: 0.0, right: horizontalPadding)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(UserCell.self, forCellWithReuseIdentifier: userCellId)
        return cv
    }()
    
    let taggedEventsLabel: UILabel = {
        let label = UILabel()
        label.text = "Tagged Events"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ditloOffWhite
        anchorSubviews()
    }
    
    func anchorSubviews() {
        // scroll view
        self.view.addSubview(contentScrollView)
        contentScrollView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: screenWidth, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // top
        contentScrollView.addSubview(testImageView)
        testImageView.anchor(withTopAnchor: self.contentScrollView.topAnchor, leadingAnchor: contentScrollView.leadingAnchor, bottomAnchor: nil, trailingAnchor: contentScrollView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: screenWidth, heightAnchor: (self.view.frame.height - safeAreaTopPadding))
        
        // bottom
        contentScrollView.addSubview(infoContentContainerView)
        infoContentContainerView.anchor(withTopAnchor: testImageView.bottomAnchor, leadingAnchor: contentScrollView.leadingAnchor, bottomAnchor: contentScrollView.bottomAnchor, trailingAnchor: contentScrollView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: screenWidth, heightAnchor: self.view.frame.height - (safeAreaBottomPadding + safeAreaTopPadding))
        
        // tagged friends
        infoContentContainerView.addSubview(taggedFriendsLabel)
        taggedFriendsLabel.anchor(withTopAnchor: infoContentContainerView.topAnchor, leadingAnchor: infoContentContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: infoContentContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 60.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        infoContentContainerView.addSubview(taggedFriendsCollectionView)
        taggedFriendsCollectionView.anchor(withTopAnchor: taggedFriendsLabel.bottomAnchor, leadingAnchor: contentScrollView.leadingAnchor, bottomAnchor: nil, trailingAnchor: contentScrollView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 141.0, padding: .init(top: 24.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // tagged events
        infoContentContainerView.addSubview(taggedEventsLabel)
        taggedEventsLabel.anchor(withTopAnchor: taggedFriendsCollectionView.bottomAnchor, leadingAnchor: infoContentContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: infoContentContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 60.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        self.updateLayout(with: self.view.frame.size)
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.updateLayout(with: size)
        }, completion: nil)
    }
    
    @available(iOS 11.0, *)
    override public func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        self.updateLayout(with: self.view.frame.size)
    }
    
    func updateLayout(with size: CGSize) {
        self.contentScrollView.frame = CGRect.init(origin: CGPoint.zero, size: size)
    }
}

// collection view delegate and datasource methods
extension DitloPlayerPopupVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: userCellId, for: indexPath) as? UserCell else {
            return UICollectionViewCell()
        }
        return userCell
    }
}


// scroll view delegate methods
extension DitloPlayerPopupVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SPStorkController.scrollViewDidScroll(scrollView)
        if scrollView.contentOffset.y < -(self.view.frame.height * 0.18) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
