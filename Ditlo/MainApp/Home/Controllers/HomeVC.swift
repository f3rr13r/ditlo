//
//  HomeVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialFlexibleHeader

class HomeVC: UIViewController {
    
    // home nav bar
    let homeNavBar = MainDitloNavBar()
    
    // flexible header
    let headerViewController = MDCFlexibleHeaderViewController()
    
    private let testCollectionViewCellId: String = "testCollectionViewCellId"
    private let testCollectionViewHeaderId: String = "testCollectionViewHeaderId"
    lazy var testCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: testCollectionViewCellId)
        cv.register(TestCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: testCollectionViewHeaderId)
        return cv
    }()
    
    let popdownSectionHeader: UIView = {
        let view = UIView()
        view.backgroundColor = ditloPink
        return view
    }()
    var popdownSectionHeaderTopConstraint: NSLayoutConstraint!
    
    let popdownSectionHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Example Section"
        label.font = infoWindowModalLogoFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addChild(headerViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addChild(headerViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupFlexibleHeaderVC()
        setupChildDelegates()
        anchorChildViews()
    }
    
    func appHasCurrentUserData() {
        // once we have the data, we'll grab the ditlo content
    }
    
    func setupFlexibleHeaderVC() {
        headerViewController.view.frame = view.bounds
        headerViewController.view.backgroundColor = .white
        headerViewController.headerView.shiftBehavior = .enabledWithStatusBar
        headerViewController.headerView.trackingScrollView = testCollectionView
        headerViewController.headerView.addSubview(homeNavBar)
        homeNavBar.fillSuperview()
        view.addSubview(headerViewController.view)
        headerViewController.didMove(toParent: self)
    }
    
    func setupChildDelegates() {
        homeNavBar.delegate = self
    }
    
    func anchorChildViews() {
        self.view.insertSubview(testCollectionView, belowSubview: headerViewController.headerView)
        testCollectionView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        
        self.view.addSubview(popdownSectionHeader)
        popdownSectionHeader.anchor(withTopAnchor: nil, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: (safeAreaTopPadding + 36.0))
        popdownSectionHeaderTopConstraint = NSLayoutConstraint(item: popdownSectionHeader, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: -(safeAreaTopPadding + 36.0))
        self.view.addConstraint(popdownSectionHeaderTopConstraint)
        
        popdownSectionHeader.addSubview(popdownSectionHeaderLabel)
        popdownSectionHeaderLabel.anchor(withTopAnchor: nil, leadingAnchor: popdownSectionHeader.leadingAnchor, bottomAnchor: popdownSectionHeader.bottomAnchor, trailingAnchor: popdownSectionHeader.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: -14.0, right: -horizontalPadding))
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 29
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: testCollectionViewCellId, for: indexPath) as? TestCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: testCollectionViewHeaderId, for: indexPath) as? TestCollectionViewHeader else { return UICollectionReusableView() }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat!
        let height: CGFloat!
        
        if indexPath.item == 0 || indexPath.item % 7 == 0 {
            width = screenWidth
            height = width * 1.44
        } else {
            width = (screenWidth - 2.0) / 2
            height = width * 1.44
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: -60.0, left: 0.0, bottom: 2.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}

class TestCollectionViewCell: BaseCell {
    override func setupViews() {
        self.backgroundColor = ditloDarkBlue
    }
}

class TestCollectionViewHeader: UICollectionReusableView {
    
    // views
    let headerTextLabel: UILabel = {
        let label = UILabel()
        label.text = "EXAMPLE HEADER"
        label.font = navBarLogoFont
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(headerTextLabel)
        headerTextLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: -20.0, right: -horizontalPadding))
    }
}

// scroll view delegate methods
extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == headerViewController.headerView.trackingScrollView {
            headerViewController.headerView.trackingScrollDidScroll()
        }
        
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0)
        {
            if scrollView.contentOffset.y < 40.0 {
                if popdownSectionHeaderTopConstraint.constant > -(safeAreaTopPadding + 36.0) {
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                        self.popdownSectionHeaderTopConstraint.constant = -(safeAreaTopPadding + 36.0)
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
            }
        }
        else
        {
            if scrollView.contentOffset.y > 20.0 {
                if popdownSectionHeaderTopConstraint.constant < 0 {
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                        self.popdownSectionHeaderTopConstraint.constant = 0.0
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == headerViewController.headerView.trackingScrollView {
            headerViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let headerView = headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let headerView = headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
}

extension HomeVC: MainDitloNavBarDelegate {
    func openCalendarButtonPressed() {
        SharedModalsService.instance.showCalendar()
    }
}

