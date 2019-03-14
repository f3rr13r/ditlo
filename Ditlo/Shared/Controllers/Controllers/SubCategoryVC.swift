//
//  SubCategoryVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/14/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class SubCategoryVC: UIViewController {

    // injector variables
    var category: Category? {
        didSet {
            if let category = self.category {
                var subCategorySections: [NavigationCellContent] = []
                for i in 1..<category.childCategories.count {
                    subCategories.append(category.childCategories[i])
                    
                    let subCategorySection = NavigationCellContent(name: category.childCategories[i].name, colour: category.childCategories[i].backgroundColor)
                    subCategorySections.append(subCategorySection)
                }
                subCategoryNavBar.categoryName = category.name
                subCategoryNavBar.sections = subCategorySections
            }
        }
    }
    
    // views
    let subCategoryNavBar = SubCategoryNavBar()
    
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
    var subCategories: [ChildCategory] = []
    var categoryNavSections: [NavigationCellContent] = []
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
        setupSubCategoriesNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroySubCategoriesNavBar()
    }
    
    func setupSubCategoriesNavBar() {
        if let subCategoriesNavigationController = self.navigationController {
            subCategoriesNavigationController.navigationBar.prefersLargeTitles = true
            subCategoriesNavigationController.navigationItem.hidesBackButton = true
            subCategoriesNavigationController.hidesBarsOnSwipe = true
            subCategoriesNavigationController.navigationBar.shadowImage = UIImage()
            subCategoriesNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            subCategoriesNavigationController.navigationBar.backgroundColor = .white
            subCategoriesNavigationController.navigationBar.addSubview(subCategoryNavBar)
            subCategoryNavBar.anchor(withTopAnchor: subCategoriesNavigationController.navigationBar.topAnchor, leadingAnchor: subCategoriesNavigationController.navigationBar.leadingAnchor, bottomAnchor: nil, trailingAnchor: subCategoriesNavigationController.navigationBar.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
            subCategoryNavBar.delegate = self
            subCategoriesNavigationController.navigationBar.layoutIfNeeded()
        }
    }
    
    func destroySubCategoriesNavBar() {
        subCategoryNavBar.removeFromSuperview()
    }
    
    func anchorSubviews() {
        self.view.addSubview(contentSectionsCollectionView)
        contentSectionsCollectionView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: self.view.centerXAnchor, centreYAnchor: self.view.centerYAnchor)
    }
}

// collection view delegate and datasource methods
extension SubCategoryVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SectionCell else { return UICollectionViewCell() }
        sectionCell.testColour = subCategories[indexPath.item].backgroundColor
        sectionCell.sectionTitle = subCategories[indexPath.item].name
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
extension SubCategoryVC: UIScrollViewDelegate {
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
                        if currentlySelectedIndexPath.item < (subCategories.count - 1) {
                            currentlySelectedIndexPath.item += 1
                        }
                    } else {
                        if currentlySelectedIndexPath.item > 0 {
                            currentlySelectedIndexPath.item -= 1
                        }
                    }
                    
                    subCategoryNavBar.currentlySelectedSectionIndex = currentlySelectedIndexPath
                }
            }
        }
    }
}

extension SubCategoryVC: SubCategoryNavBarDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func calendarButtonPressed() {
        SharedModalsService.instance.showCalendar()
    }
    
    func navigationCellSelected(itemIndex: IndexPath) {
        contentSectionsCollectionView.scrollToItem(at: itemIndex, at: .centeredHorizontally, animated: true)
        currentlySelectedIndexPath = itemIndex
    }
}

extension SubCategoryVC: SectionCellDelegate {
    func ditloItemCellTapped() {
        print("ditlo item cell tapped")
    }
}
