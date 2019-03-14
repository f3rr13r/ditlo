//
//  CategoriesVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController {
    
    // views
    let categoriesNavBar = CategoriesNavBar()
    
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
    var categories: [Category] = []
    var categoryNavSections: [NavigationCellContent] = []
    var isCalculatingScrollDirection: Bool = false
    var previousOffset: CGFloat = 0.0
    var currentlySelectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        edgesForExtendedLayout = []
        getMainCategories()
        anchorSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCategoriesNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroyCategoriesNavBar()
    }
    
    func setupCategoriesNavBar() {
        if let categoriesNavigationController = self.navigationController {
            categoriesNavigationController.navigationBar.prefersLargeTitles = true
            categoriesNavigationController.navigationItem.hidesBackButton = true
            categoriesNavigationController.hidesBarsOnSwipe = true
            categoriesNavigationController.navigationBar.shadowImage = UIImage()
            categoriesNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            categoriesNavigationController.navigationBar.backgroundColor = .white
            categoriesNavigationController.navigationBar.addSubview(categoriesNavBar)
            categoriesNavBar.anchor(withTopAnchor: categoriesNavigationController.navigationBar.topAnchor, leadingAnchor: categoriesNavigationController.navigationBar.leadingAnchor, bottomAnchor: nil, trailingAnchor: categoriesNavigationController.navigationBar.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
            categoriesNavBar.delegate = self
        }
    }
    
    func destroyCategoriesNavBar() {
        categoriesNavBar.removeFromSuperview()
    }
    
    func getMainCategories() {
        CategoriesService.instance.getCategoriesList { (categories) in
            self.categories = categories
            for category in self.categories {
                let navigationCategory = NavigationCellContent(name: category.name, colour: category.backgroundColor)
                self.categoryNavSections.append(navigationCategory)
            }
            self.categoriesNavBar.sections = self.categoryNavSections
            self.contentSectionsCollectionView.reloadData()
        }
    }
    
    func anchorSubviews() {
        self.view.addSubview(contentSectionsCollectionView)
        contentSectionsCollectionView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: self.view.centerXAnchor, centreYAnchor: self.view.centerYAnchor)
    }
    
    
    @objc func showAllButtonPressed() {
        let selectedCategory = categories[currentlySelectedIndexPath.item]
        let subCategoryVC = SubCategoryVC()
        subCategoryVC.category = selectedCategory
        self.navigationController?.pushViewController(subCategoryVC, animated: true)
    }
}

// collection view delegate and datasource methods
extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SectionCell else { return UICollectionViewCell() }
        sectionCell.testColour = categories[indexPath.item].backgroundColor
        sectionCell.sectionTitle = categories[indexPath.item].name
        sectionCell.needsShowAllButton = true
        sectionCell.delegate = self
        if sectionCell.needsShowAllButton {
            sectionCell.showAllButton.addTarget(self, action: #selector(showAllButtonPressed), for: .touchUpInside)
        }
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
extension CategoriesVC: UIScrollViewDelegate {
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
                        if currentlySelectedIndexPath.item < (categories.count - 1) {
                            currentlySelectedIndexPath.item += 1
                        }
                    } else {
                        if currentlySelectedIndexPath.item > 0 {
                            currentlySelectedIndexPath.item -= 1
                        }
                    }
                    
                    categoriesNavBar.currentlySelectedSectionIndex = currentlySelectedIndexPath
                }
            }
        }
    }
}

extension CategoriesVC: CategoriesNavBarDelegate {
    func navigationCellSelected(itemIndex: IndexPath) {
        contentSectionsCollectionView.scrollToItem(at: itemIndex, at: .centeredHorizontally, animated: true)
        currentlySelectedIndexPath = itemIndex
    }
    
    func calendarButtonPressed() {
        // open the calendar
    }
}

extension CategoriesVC: SectionCellDelegate {
    func ditloItemCellTapped() {
        print("ditlo item cell tapped")
    }
}
