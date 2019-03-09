//
//  HomeVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import SPStorkController

class HomeVC: UIViewController {
    
    // views
    let homeNavBar = HomeDitloNavBar()
    
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
    
    // variables
    var navigationSections: [String] = ["Most Viewed", "Friends", "Following", "My Events"]
    var isCalculatingScrollDirection: Bool = false
    var previousOffset: CGFloat = 0.0
    var currentlySelectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    var colours: [UIColor] = [ditloRed, ditloDarkBlue, ditloOrange, ditloLightGreen]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeNavBar.navigationSections = navigationSections
        edgesForExtendedLayout = []
        anchorChildViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCustomHomeNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroyCustomHomeNavigation()
    }
    
    func appHasCurrentUserData() {

    }
    
    func setupCustomHomeNavigation() {
        if let homeNavigationController = self.navigationController {
            homeNavigationController.navigationBar.prefersLargeTitles = true
            homeNavigationController.hidesBarsOnSwipe = true
            homeNavigationController.navigationBar.addSubview(homeNavBar)
            homeNavBar.fillSuperview()
            homeNavBar.delegate = self
            
        }
    }
    
    func destroyCustomHomeNavigation() {
        homeNavBar.removeFromSuperview()
    }
    
    func anchorChildViews() {
        self.view.addSubview(contentSectionsCollectionView)
        contentSectionsCollectionView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: self.view.centerXAnchor, centreYAnchor: self.view.centerYAnchor)
    }
}


// collection view delegate and datasource methods
extension HomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return navigationSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SectionCell else { return UICollectionViewCell() }
        sectionCell.testColour = colours[indexPath.item]
        sectionCell.sectionTitle = navigationSections[indexPath.item]
        sectionCell.delegate = self
        return sectionCell
    }
    
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


// scroll view delegate methods
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

// home navigation bar delegates methods
extension HomeVC: HomeDitloNavBarDelegate {
    func openCalendarButtonPressed() {
        SharedModalsService.instance.showCalendar()
    }
    
    func navigationCellSelected(itemIndex: IndexPath) {
        contentSectionsCollectionView.scrollToItem(at: itemIndex, at: .centeredHorizontally, animated: true)
        currentlySelectedIndexPath = itemIndex
    }
}

// section cell delegate methods
extension HomeVC: SectionCellDelegate {
    func userSwipedContentUp() {
        contentSectionsCollectionView.isScrollEnabled = false
    }
    
    func userSwipedContentDown() {
        contentSectionsCollectionView.isScrollEnabled = true
    }
    
    func ditloItemCellTapped() {
        let controller = DitloPlayerPopupVC()
        controller.delegate = self
        let transitionDelegate = SPStorkTransitioningDelegate()
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        self.present(controller, animated: true, completion: nil)
    }
}

// ditloPopup delegate
extension HomeVC: DitloPlayerPopupActionDelegate {
    func prepareToNavigate(toViewController viewController: UIViewController) {
        print(viewController)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

