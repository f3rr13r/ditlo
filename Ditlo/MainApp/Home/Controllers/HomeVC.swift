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
    
    var homeNavBar = HomeDitloNavBar()
    let headerViewController = MDCFlexibleHeaderViewController()
    
    private let cellId: String = "cellId"
    lazy var contentSectionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.backgroundColor = .white
        cv.contentInsetAdjustmentBehavior = .never
        cv.register(SectionCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    var navigationSections: [String] = ["Most Viewed", "Friends", "Following", "My Events"]
    var isCalculatingScrollDirection: Bool = false
    var previousOffset: CGFloat = 0.0
    var currentlySelectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    var colours: [UIColor] = [ditloRed, ditloDarkBlue, ditloOrange, ditloLightGreen]
    
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
        edgesForExtendedLayout = []
        setupCustomNavigation()
        anchorChildViews()
        
    }
    
    func appHasCurrentUserData() {
        homeNavBar.navigationSections = navigationSections
    }
    
    func setupCustomNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(homeNavBar)
        homeNavBar.fillSuperview()
        homeNavBar.delegate = self
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    func anchorChildViews() {
        self.view.addSubview(contentSectionsCollectionView)
        contentSectionsCollectionView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: self.view.centerXAnchor, centreYAnchor: self.view.centerYAnchor)
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return navigationSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SectionCell else { return UICollectionViewCell() }
        sectionCell.testColour = colours[indexPath.item]
        sectionCell.sectionTitle = navigationSections[indexPath.item]
        return sectionCell
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

extension HomeVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isCalculatingScrollDirection = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isCalculatingScrollDirection {
            if previousOffset == 0 {
                previousOffset = scrollView.contentOffset.x
            } else {
                let diff: CGFloat = scrollView.contentOffset.x - previousOffset
                if diff != 0 {
                    previousOffset = 0
                    isCalculatingScrollDirection = false
                    
                    if diff > 0 {
                        if currentlySelectedIndexPath.item < (navigationSections.count - 1) {
                            currentlySelectedIndexPath.item += 1
                        }
                    } else {
                        if currentlySelectedIndexPath.item > 0 {
                            currentlySelectedIndexPath.item -= 1
                        }
                    }
                    
                    homeNavBar.currentlySelectedSectionIndex = currentlySelectedIndexPath
                }
            }
        }
    }}

extension HomeVC: HomeDitloNavBarDelegate {
    func openCalendarButtonPressed() {
        SharedModalsService.instance.showCalendar()
    }
    
    func navigationCellSelected(itemIndex: IndexPath) {
        contentSectionsCollectionView.scrollToItem(at: itemIndex, at: .centeredHorizontally, animated: true)
        currentlySelectedIndexPath = itemIndex
    }
}

class SectionCell: BaseCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // injector variables
    var testColour: UIColor = ditloGrey {
        didSet {
            contentViewController.reloadData()
        }
    }
    
    var sectionTitle: String = "" {
        didSet {
            contentViewController.invalidateIntrinsicContentSize()
        }
    }
    
    private let headerId: String = "headerId"
    private let largeDitloItemCellId: String = "largeDitloItemCellId"
    private let defaultDitloItemCellId: String = "defaultDitloItemCellId"
    lazy var contentViewController: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInsetAdjustmentBehavior = .never
        cv.register(SectionTitleHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        cv.register(LargeDitloItemCell.self, forCellWithReuseIdentifier: largeDitloItemCellId)
        cv.register(DefaultDitloItemCell.self, forCellWithReuseIdentifier: defaultDitloItemCellId)
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(contentViewController)
        contentViewController.fillSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as? SectionTitleHeader else { return UICollectionReusableView() }
        sectionHeader.sectionTitle = sectionTitle
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 180.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // large cell
        if indexPath.item == 0 || indexPath.item % 7 == 0 {
            guard let largeDitloItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: largeDitloItemCellId, for: indexPath) as? LargeDitloItemCell else {
                return UICollectionViewCell()
            }
            largeDitloItemCell.backgroundColor = testColour
            return largeDitloItemCell
        }
        
        // default cell
        guard let defaultDitloItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultDitloItemCellId, for: indexPath) as? DefaultDitloItemCell else {
            return UICollectionViewCell()
        }
        defaultDitloItemCell.backgroundColor = testColour
        return defaultDitloItemCell
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
}

class SectionTitleHeader: BaseCollectionReusableView {
    
    // injector variables
    var sectionTitle: String = "Loading" {
        didSet {
            sectionTitleLabel.text = sectionTitle
        }
    }
    
    // views
    let gradientView: GradientView = {
        let gv = GradientView()
        gv.colors = [ditloOffBlack.withAlphaComponent(0.4), UIColor.clear]
        return gv
    }()
    
    let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "MOST VIEWED"
        label.font = defaultTitleFont
        label.textColor = .white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(gradientView)
        gradientView.fillSuperview()
        
        addSubview(sectionTitleLabel)
        sectionTitleLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
    }
}

class SectionItemCell: BaseCell {}

