//
//  HomeVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialFlexibleHeader

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ContentCellDelegate, HomeDitloNavBarDelegate {
    
    var contentCell: ContentCell?
    
    private let headerId: String = "headerId"
    private let cellId: String = "cellId"
    lazy var contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInsetAdjustmentBehavior = .never
        cv.register(NavigationHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        cv.register(ContentCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    // variables
    var navigationSections: [String] = ["Most Viewed", "Friends", "Following", "My Events"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(contentCollectionView)
        contentCollectionView.anchor(withTopAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, bottomAnchor: view.bottomAnchor, trailingAnchor: view.trailingAnchor, centreXAnchor: view.centerXAnchor, centreYAnchor: view.centerYAnchor)
    }
    
    func appHasCurrentUserData() {
        // do something eventually
    }
    
    // collection view stuff
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let navigationHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? NavigationHeader else {
            return UICollectionReusableView()
        }
        navigationHeader.sections = navigationSections
        navigationHeader.homeNavbar.delegate = self
        return navigationHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 140.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        contentCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ContentCell
        contentCell?.delegate = self
        contentCell?.sections = navigationSections
        return contentCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: safeAreaBottomPadding, right: 0.0)
    }
    
    func scrollPositionDidUpdate(withYValue yValue: CGFloat) {
        contentCollectionView.contentOffset.y = yValue
    }
    
    func didSectionScroll(toIndexPath indexPath: IndexPath) {
        if let navigationHeader = contentCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? NavigationHeader {
            navigationHeader.homeNavbar.updateSelectedNavigationCollectionViewCell(withIndexPath: indexPath)
        }
    }
    
    func openCalendarButtonPressed() {
        SharedModalsService.instance.showCalendar()
    }
    
    func navigationCellSelected(itemIndex: IndexPath) {
        if let contentCell = contentCell {
            contentCell.isSwipingEnabled = false
            contentCell.currentlySelectedItemIndex = itemIndex.item
            contentCell.contentViewController.scrollToItem(at: itemIndex, at: .centeredHorizontally, animated: true)
        }
    }
}

//** top level **
// header
class NavigationHeader: BaseCollectionReusableView {
    
    // injector variables
    var sections: [String] = [] {
        didSet {
            homeNavbar.navigationSections = sections
        }
    }
    
    // views
    let homeNavbar = HomeDitloNavBar()
    
    override func setupViews() {
        super.setupViews()
        addSubview(homeNavbar)
        homeNavbar.fillSuperview()
    }
}

// content
protocol ContentCellDelegate {
    func scrollPositionDidUpdate(withYValue yValue: CGFloat)
    func didSectionScroll(toIndexPath indexPath: IndexPath)
}

class ContentCell: BaseCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ContentSectionCellDelegate {
    
    // injector variables
    var sections: [String] = [] {
        didSet {
            contentViewController.reloadData()
        }
    }
    
    // views
    private let cellId: String = "cellId"
    lazy var contentViewController: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInsetAdjustmentBehavior = .never
        cv.isPagingEnabled = true
        cv.register(ContentSectionCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    var delegate: ContentCellDelegate?
    
    var isScrolling: Bool = false
    var isSwipingEnabled: Bool = true
    var currentlySelectedItemIndex: Int = 0
    
    var colours: [UIColor] = [ditloRed, ditloDarkBlue, ditloOrange, ditloLightGreen]
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = ditloDarkBlue
        anchorChildViews()
    }
    
    func anchorChildViews() {
        // collection view
        addSubview(contentViewController)
        contentViewController.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
    }
    
    override func prepareForReuse() {
        sections = []
    }
    
    // collection view stuff
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let contentSectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ContentSectionCell else {
            return UICollectionViewCell()
        }
        
        contentSectionCell.backgroundColor = ditloGrey
        contentSectionCell.delegate = self
        contentSectionCell.sectionTitle = sections[indexPath.item]
        contentSectionCell.colour = colours[indexPath.item]
        
        return contentSectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollPositionDidUpdate(withYValue yValue: CGFloat) {
        delegate?.scrollPositionDidUpdate(withYValue: yValue)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
            if !isScrolling {
                isScrolling = true
                if currentlySelectedItemIndex > 0 {
                    currentlySelectedItemIndex -= 1
                    if isSwipingEnabled {
                        delegate?.didSectionScroll(toIndexPath: IndexPath(item: currentlySelectedItemIndex, section: 0))
                    }
                }
            }
        } else {
            if !isScrolling {
                isScrolling = true
                if currentlySelectedItemIndex < (sections.count - 1) {
                    currentlySelectedItemIndex += 1
                    if isSwipingEnabled {
                        delegate?.didSectionScroll(toIndexPath: IndexPath(item: currentlySelectedItemIndex, section: 0))
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
        isSwipingEnabled = true
    }
}


//-- mid level
protocol ContentSectionCellDelegate {
    func scrollPositionDidUpdate(withYValue yValue: CGFloat)
}

class ContentSectionCell: BaseCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // injector variables
    var sectionTitle: String? = "" {
        didSet {
            if let _ = self.sectionTitle {
                contentViewController.invalidateIntrinsicContentSize()
            }
        }
    }
    
    var colour: UIColor = ditloGrey {
        didSet {
            contentViewController.reloadData()
        }
    }
    
    // collection view
    private let headerId: String = "headerId"
    private let cellId: String = "cellId"
    lazy var contentViewController: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInsetAdjustmentBehavior = .never
        cv.register(SectionTitleHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        cv.register(SectionItemCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    var delegate: ContentSectionCellDelegate?
    
    override func setupViews() {
        super.setupViews()
        // collection view
        addSubview(contentViewController)
        contentViewController.fillSuperview()
    }
    
    override func prepareForReuse() {
        sectionTitle = nil
        contentViewController.invalidateIntrinsicContentSize()
    }
    
    // collection view stuff
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 29
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionTitleHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? SectionTitleHeader else {
            return UICollectionReusableView()
        }
        sectionTitleHeader.sectionTitle = sectionTitle ?? ""
        return sectionTitleHeader
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 180.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SectionItemCell else {
            return UICollectionViewCell()
        }
        
        sectionItemCell.backgroundColor = colour
        return sectionItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat!
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
        return UIEdgeInsets(top: -180.0, left: 0.0, bottom: safeAreaBottomPadding, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > -16.0 && scrollView.contentOffset.y < 140.0 {
            delegate?.scrollPositionDidUpdate(withYValue: scrollView.contentOffset.y)
        }
    }
}

class SectionTitleHeader: BaseCollectionReusableView {
    
    // injector variables
    var sectionTitle: String? {
        didSet {
            if let sectionTitle = self.sectionTitle {
                sectionTitleLabel.text = sectionTitle.uppercased()
            }
        }
    }
    
    // views
    let sectionTitleGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.colors = [ditloOffBlack.withAlphaComponent(0.4), UIColor.clear]
        return gradientView
    }()
    
    let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = defaultTitleFont
        label.textColor = .white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        // gradient view and section title
        addSubview(sectionTitleGradientView)
        sectionTitleGradientView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 180.0)
        sectionTitleGradientView.addSubview(sectionTitleLabel)
        sectionTitleLabel.anchor(withTopAnchor: sectionTitleGradientView.safeAreaLayoutGuide.topAnchor, leadingAnchor: sectionTitleGradientView.leadingAnchor, bottomAnchor: nil, trailingAnchor: sectionTitleGradientView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
    }
    
    override func prepareForReuse() {
        sectionTitle = nil
        sectionTitleLabel.text = nil
    }
}

//-- bottom level
class SectionItemCell: BaseCell {
}

