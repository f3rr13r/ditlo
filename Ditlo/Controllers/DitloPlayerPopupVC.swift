//
//  DitloPlayerPopupVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/4/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import SPStorkController
import DGCollectionViewLeftAlignFlowLayout

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
        cv.decelerationRate = .fast
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
    
    private let eventCellId: String = "eventCellId"
    let taggedEventCollectionViewFlowlayout = UICollectionViewFlowLayout()
    lazy var taggedEventsCollectionView: UICollectionView = {
        taggedEventCollectionViewFlowlayout.scrollDirection = .horizontal
        taggedEventCollectionViewFlowlayout.itemSize.width = min((screenWidth - 20.0) - 20, 400)
        taggedEventCollectionViewFlowlayout.itemSize.height = 60.0
        taggedEventCollectionViewFlowlayout.minimumInteritemSpacing = 0.0
        taggedEventCollectionViewFlowlayout.sectionInset = UIEdgeInsets(top: 0.0, left: horizontalPadding, bottom: 0.0, right: horizontalPadding)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: taggedEventCollectionViewFlowlayout)
        cv.backgroundColor = .clear
        cv.decelerationRate = .fast
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(EventCell.self, forCellWithReuseIdentifier: eventCellId)
        return cv
    }()
    
    // Velocity is measured in points per millisecond.
    private var snapToMostVisibleColumnVelocityThreshold: CGFloat { return 0.3 }
    
    let taggedEvents: Int = 20
    
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
        infoContentContainerView.addSubview(taggedEventsCollectionView)
        taggedEventsCollectionView.anchor(withTopAnchor: taggedEventsLabel.bottomAnchor, leadingAnchor: infoContentContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: infoContentContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 196.0, padding: .init(top: 24.0, left: 0.0, bottom: 0.0, right: 0.0))
        
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
        if collectionView == taggedFriendsCollectionView {
            return 7
        }
        
        if collectionView == taggedEventsCollectionView {
            return 20
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // user cell
        if collectionView == taggedFriendsCollectionView {
            guard let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: userCellId, for: indexPath) as? UserCell else {
                return UICollectionViewCell()
            }
            return userCell
        }
        
        // event cell
        if collectionView == taggedEventsCollectionView {
            guard let eventCell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellId, for: indexPath) as? EventCell else {
                return UICollectionViewCell()
            }
            return eventCell
        }
        
        // if something went wrong, then just pass back a collection view cell
        return UICollectionViewCell()
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == taggedEventsCollectionView {
            let layout = taggedEventCollectionViewFlowlayout
            let bounds = scrollView.bounds
            let xTarget = targetContentOffset.pointee.x
            
            // This is the max contentOffset.x to allow. With this as contentOffset.x, the right edge of the last column of cells is at the right edge of the collection view's frame.
            let xMax = (scrollView.contentSize.width) - (scrollView.bounds.width)
            
            if abs(velocity.x) <= snapToMostVisibleColumnVelocityThreshold {
                let xCenter = scrollView.bounds.midX
                let poses = layout.layoutAttributesForElements(in: bounds) ?? []
                // Find the column whose center is closest to the collection view's visible rect's center, then minus one section contentInset
                let x = (poses.min(by: { abs($0.center.x - 20.0 - xCenter) < abs($1.center.x - xCenter) })?.frame.origin.x ?? 0) - 20.0
                targetContentOffset.pointee.x = x
            } else if velocity.x > 0 {
                let poses = layout.layoutAttributesForElements(in: CGRect(x: xTarget, y: 0, width: bounds.size.width, height: bounds.size.height)) ?? []
                // Find the leftmost column beyond the current position, minus one section contentInset.
                let xCurrent = scrollView.contentOffset.x
                let x = (poses.filter({ $0.frame.origin.x > xCurrent}).min(by: { $0.center.x < $1.center.x })?.frame.origin.x ?? xMax) - 20.0
                targetContentOffset.pointee.x = min(x, xMax)
            } else {
                let poses = layout.layoutAttributesForElements(in: CGRect(x: xTarget - bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)) ?? []
                // Find the rightmost column minus one section contentInset.
                let x = ((poses.max(by: { $0.center.x < $1.center.x })?.frame.origin.x) ?? 0) - 20.0
                targetContentOffset.pointee.x = max(x, 0)
            }
        }
    }
}
