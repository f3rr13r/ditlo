//
//  SearchResultsVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/19/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import SPStorkController

class SearchResultsVC: UIViewController {

    // injector variables
    var searchResult: String = "" {
        didSet {
            searchResultNavBar.searchResult = searchResult
            searchResultNavBar.sections = searchResultSections
        }
    }
    
    // views
    let searchResultNavBar = SearchResultsNavBar()
    
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
    var searchResultSections: [NavigationCellContent] = [
        NavigationCellContent(name: "By Name", colour: ditloGrey),
        NavigationCellContent(name: "By Profession", colour: ditloGrey),
        NavigationCellContent(name: "By Category", colour: ditloGrey),
        NavigationCellContent(name: "By Keyword", colour: ditloGrey),
        NavigationCellContent(name: "By Location", colour: ditloGrey)
    ]
    var isCalculatingScrollDirection: Bool = false
    var previousOffset: CGFloat = 0.0
    var currentlySelectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        edgesForExtendedLayout = []
        anchorSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCustomNavigationBarContent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroyCustomnavigationBarContent()
    }
    
    func setupCustomNavigationBarContent() {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationItem.hidesBackButton = true
            navigationController.hidesBarsOnSwipe = true
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.backgroundColor = .white
            navigationController.navigationBar.addSubview(searchResultNavBar)
            searchResultNavBar.anchor(withTopAnchor: navigationController.navigationBar.topAnchor, leadingAnchor: navigationController.navigationBar.leadingAnchor, bottomAnchor: nil, trailingAnchor: navigationController.navigationBar.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
            searchResultNavBar.delegate = self
            navigationController.navigationBar.layoutIfNeeded()
        }
    }
    
    func destroyCustomnavigationBarContent() {
        searchResultNavBar.removeFromSuperview()
    }
    
    func anchorSubviews() {
        self.view.addSubview(contentSectionsCollectionView)
        contentSectionsCollectionView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: self.view.centerXAnchor, centreYAnchor: self.view.centerYAnchor)
    }
}

// collection view delegate and data source methods
extension SearchResultsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SectionCell else { return UICollectionViewCell() }
        sectionCell.testColour = searchResultSections[indexPath.item].colour
        sectionCell.sectionTitle = searchResultSections[indexPath.item].name
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
extension SearchResultsVC: UIScrollViewDelegate {
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
                        if currentlySelectedIndexPath.item < (searchResultSections.count - 1) {
                            currentlySelectedIndexPath.item += 1
                        }
                    } else {
                        if currentlySelectedIndexPath.item > 0 {
                            currentlySelectedIndexPath.item -= 1
                        }
                    }
                    
                    searchResultNavBar.currentlySelectedSectionIndex = currentlySelectedIndexPath
                }
            }
        }
    }
}

// search bar delegate methods
extension SearchResultsVC: SearchResultsNavBarDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigationCellSelected(itemIndex: IndexPath) {
        contentSectionsCollectionView.scrollToItem(at: itemIndex, at: .centeredHorizontally, animated: true)
        currentlySelectedIndexPath = itemIndex
    }
}

// section cell delegate methods
extension SearchResultsVC: SectionCellDelegate {
    func ditloItemCellTapped() {
        let controller = DitloPlayerPopupVC()
        controller.delegate = self
        let transitionDelegate = SPStorkTransitioningDelegate()
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        self.present(controller, animated: true, completion: nil)
    }
}

// ditlo player delegate methods
extension SearchResultsVC: DitloPlayerPopupActionDelegate {
    func prepareToNavigate(toViewController viewController: UIViewController) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}


