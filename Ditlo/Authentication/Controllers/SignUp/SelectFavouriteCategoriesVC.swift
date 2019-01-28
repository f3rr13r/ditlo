//
//  SelectFavouriteCategoriesVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/27/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import DGCollectionViewLeftAlignFlowLayout

class SelectFavouriteCategoriesVC: UIViewController {
    
    // views
    let selectJobPositionNavBar: AuthenticationNavBar = {
        let navbar = AuthenticationNavBar()
        navbar.needsBackButton = true
        navbar.needsRedRoundedButton = false
        navbar.isRedRoundedButtonEnabled = true
        navbar.needsGreyBorderButton = true
        navbar.greyBorderRoundedButtonText = "SKIP"
        return navbar
    }()
    
    let titleLabel = TitleLabel()
    var titleLabelWidthConstraint: NSLayoutConstraint?
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    let infoButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(presentInfoWindowModal), for: .touchUpInside)
        return button
    }()
    
    let infoButtonIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        let infoIcon = #imageLiteral(resourceName: "info-icon")
        iv.image = infoIcon
        return iv
    }()
    
    let searchCategoriesInput: CustomInputView = {
        let customInputView = CustomInputView()
        customInputView.inputType = .unspecified
        customInputView.titleConfig = TitleLabelConfiguration(titleText: "CATEGORY KEYWORDS", titleFont: smallTitleFont)
        customInputView.hideBottomBorder = false
        customInputView.layer.zPosition = 1
        return customInputView
    }()
    
    // parent category collection view
    private let parentCategoryCellId = "parentCategoryCellId"
    lazy var parentCategoryCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: parentCategoryCellId)
        return cv
    }()
    
    // child category collection view
    private let childCategoryCellId = "childCategoryCellId"
    lazy var childCategoryCollectionView: UICollectionView = {
        let dgLeftFlowLayout = DGCollectionViewLeftAlignFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: dgLeftFlowLayout)
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: childCategoryCellId)
        return cv
    }()
    
    
    // variables
    let selectFavouriteCategoriesInfoWindowConfig = CustomInfoMessageConfig(title: "PICK CATEGORIES THAT INTEREST YOU", body: "Select a few general or specific categories from our list that interest you. Doing this will help us to cater ditlo content that we think you will be interested in. Click skip to do this later")
    var isCategoriesDataLoaded: Bool = false
    var categories: [Category] = []
    var selectedParentCategoryIndex: Int = 0
    var isSearchingCategories: Bool = false
    var searchedCategories: [Category] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupChildDelegates()
        getCategoriesData()
        anchorChildViews()
    }
    
    @objc func presentInfoWindowModal() {
        self.navigationController?.showInfoWindowModal(withInfoWindowConfig: selectFavouriteCategoriesInfoWindowConfig, andAnimation: true)
    }
    
    func setupChildDelegates() {
        
    }
    
    func getCategoriesData() {        
        CategoriesService.instance.getCategoriesList { (categoriesData) in
            if categoriesData.count > 0 {
                self.isCategoriesDataLoaded = true
                self.categories = categoriesData
                self.categories[0].isSelected = true
                self.selectedParentCategoryIndex = 0
                self.parentCategoryCollectionView.reloadData()
                self.childCategoryCollectionView.reloadData()
            }
        }
    }
    
    func anchorChildViews() {
        // custom navbar
        self.view.addSubview(selectJobPositionNavBar)
        selectJobPositionNavBar.anchor(withTopAnchor: self.view.safeAreaLayoutGuide.topAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: self.view.safeAreaLayoutGuide.centerXAnchor, centreYAnchor: nil)
        
        // title label
        let titleConfig = TitleLabelConfiguration(titleText: "PREFERRED CATEGORIES", titleFont: defaultTitleFont)
        titleLabel.titleConfig = titleConfig
        
        self.view.addSubview(titleLabel)
        titleLabel.anchor(withTopAnchor: selectJobPositionNavBar.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        // calculate title label width and height
        let titleLabelSize: CGSize = CGSize(width: titleConfig.titleText.widthOfString(usingFont: titleConfig.titleFont) + 1.0, height: titleConfig.titleText.heightOfString(usingFont: titleConfig.titleFont))
        titleLabelWidthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: titleLabelSize.width)
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: titleLabelSize.height)
        self.view.addConstraints([titleLabelWidthConstraint!, titleLabelHeightConstraint!])
        
        // info button
        self.view.addSubview(infoButton)
        infoButton.anchor(withTopAnchor: titleLabel.topAnchor, leadingAnchor: titleLabel.trailingAnchor, bottomAnchor: titleLabel.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 10.0, bottom: 0.0, right: -horizontalPadding))
        infoButton.addSubview(infoButtonIconImageView)
        infoButtonIconImageView.anchor(withTopAnchor: nil, leadingAnchor: infoButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: infoButton.centerYAnchor, widthAnchor: 14.0, heightAnchor: 14.0)
        
        // search bar
        self.view.addSubview(searchCategoriesInput)
        searchCategoriesInput.anchor(withTopAnchor: titleLabel.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 30.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // parent categories collection view
        self.view.addSubview(parentCategoryCollectionView)
        parentCategoryCollectionView.anchor(withTopAnchor: searchCategoriesInput.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 40.0, padding: .init(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // child categories collection view
        self.view.addSubview(childCategoryCollectionView)
        childCategoryCollectionView.anchor(withTopAnchor: parentCategoryCollectionView.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 24.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
}


// collection view
extension SelectFavouriteCategoriesVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCategoriesDataLoaded {
            
            // parent categories
            if collectionView == parentCategoryCollectionView {
                return categories.count
                
            // child categories
            } else {
                return categories[selectedParentCategoryIndex].childCategories.count
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier: String = collectionView == parentCategoryCollectionView ? parentCategoryCellId : childCategoryCellId
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        
        if collectionView == parentCategoryCollectionView {
            let category = ChildCategory(
                id: categories[indexPath.item].id,
                name: categories[indexPath.item].name,
                backgroundColor: categories[indexPath.item].backgroundColor,
                isSelected: categories[indexPath.item].isSelected)
            cell.category = category
        } else {
            cell.category = categories[selectedParentCategoryIndex].childCategories[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { return }
        
        if collectionView == parentCategoryCollectionView {
            if let selectedParentCellCategory = cell.category {
                for i in 0..<categories.count {
                    if categories[i].name == selectedParentCellCategory.name {
                        // select it and navigate to those child cells
                        categories[i].isSelected = true
                        selectedParentCategoryIndex = indexPath.item
                        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    } else {
                        categories[i].isSelected = false
                    }
                }
                
                parentCategoryCollectionView.reloadData()
                childCategoryCollectionView.reloadData()
            }
            
        } else if collectionView == childCategoryCollectionView {
            if categories[selectedParentCategoryIndex].childCategories[indexPath.item].name == "TOGGLE ALL" {
                categories[selectedParentCategoryIndex].isSelected = !categories[selectedParentCategoryIndex].isSelected
                for i in 0..<categories[selectedParentCategoryIndex].childCategories.count {
                    categories[selectedParentCategoryIndex].childCategories[i].isSelected = categories[selectedParentCategoryIndex].isSelected ? true : false
                }
                
                print(categories[selectedParentCategoryIndex].childCategories)
            } else {
                categories[selectedParentCategoryIndex].childCategories[indexPath.item].isSelected = !categories[selectedParentCategoryIndex].childCategories[indexPath.item].isSelected
                
                if categories[selectedParentCategoryIndex].isSelected == true {
                    categories[selectedParentCategoryIndex].isSelected = false
                }
            }
            
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == parentCategoryCollectionView {
            let parentCategoryCellWidth = categories[indexPath.item].name.widthOfString(usingFont: defaultParagraphFont) + 38.0
            return CGSize(width: parentCategoryCellWidth, height: 40.0)
        } else if collectionView == childCategoryCollectionView {
            let childCategoryCellWidth = categories[selectedParentCategoryIndex].childCategories[indexPath.item].name.widthOfString(usingFont: defaultParagraphFont) + 38.0
            return CGSize(width: childCategoryCellWidth, height: 40.0)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: horizontalPadding, bottom: 0.0, right: horizontalPadding)
    }
}
