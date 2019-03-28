//
//  VideoTagCategoriesVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/26/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import DGCollectionViewLeftAlignFlowLayout

class VideoTagCategoriesVC: UIViewController {
    
    let topPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let videoTagCategoriesNavBar = VideoTagCategoriesNavBar()
    
    let maxLimitLabel: UILabel = {
        let label = UILabel()
        label.font = smallParagraphFont
        label.textAlignment = .right
        return label
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
    var parentCategoryCollectionViewTopAnchorConstraint: NSLayoutConstraint!
    
    // child category collection view
    private let childCategoryCellId = "childCategoryCellId"
    lazy var childCategoryCollectionView: UICollectionView = {
        let flowLayout = DGCollectionViewLeftAlignFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: childCategoryCellId)
        return cv
    }()
    
    let categoriesListLoadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let loadingContentView: LoadingContentView = {
        let view = LoadingContentView()
        view.loadingContentMessage = "Loading Categories List"
        return view
    }()
    
    let noCategoriesDataView = NoDataView()
    
    let dismissKeyboardView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    // variables
    var remainingNumber: Int = 5 {
        didSet {
            let maxLimitText = "\(remainingNumber) remaining"
            maxLimitLabel.text = maxLimitText
            maxLimitLabel.textColor = remainingNumber > 0 ? ditloLightGreen : ditloRed
        }
    }
    
    var isCategoriesDataLoaded: Bool = false
    var categories: [Category] = []
    var selectedParentCategoryIndex: Int = 0
    var isSearchingCategories: Bool = false
    var searchedCategories: [ChildCategory] = []
    var selectedCategories: [ChildCategory] = []
    var selectedCategoriesCount: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        edgesForExtendedLayout = []
        getCategoriesData()
        anchorSubviews()
        setupChildDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func animateWithKeyboard(_ notification: NSNotification) {
        let moveUp = (notification.name == UIResponder.keyboardWillShowNotification)
        dismissKeyboardView.alpha = moveUp ? 1.0 : 0.0
    }
    
    @objc func dismissKeyboard() {
        videoTagCategoriesNavBar.dismissKeyboard()
    }
    
    func getCategoriesData() {
        CategoriesService.instance.getCategoriesList(withToggleAll: false) { (categoriesData) in
            if categoriesData.count > 0 {
                self.isCategoriesDataLoaded = true
                self.categories = categoriesData
                self.categories[0].isSelected = true
                self.selectedParentCategoryIndex = 0
                self.parentCategoryCollectionView.reloadData()
                self.childCategoryCollectionView.reloadData()
                self.categoriesListLoadingView.isHidden = true
            }
        }
    }
    
    func updateSelectedCategoriesCount() {
        selectedCategoriesCount = 0
        categories.forEach { (category) in
            category.childCategories.forEach({ (childCategory) in
                if childCategory.isSelected {
                    selectedCategoriesCount += 1
                }
            })
        }
        
        updateCustomNavBarButtonState()
    }
    
    func updateCustomNavBarButtonState() {
        if selectedCategoriesCount > 0 {
            videoTagCategoriesNavBar.skipButton.isHidden = true
            videoTagCategoriesNavBar.nextButton.isHidden = false
        } else {
            videoTagCategoriesNavBar.nextButton.isHidden = true
            videoTagCategoriesNavBar.skipButton.isHidden = false
        }
    }
    
    func anchorSubviews() {
        // top padding view
        self.view.addSubview(topPaddingView)
        topPaddingView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: safeAreaTopPadding)
        
        // nav bar
        self.view.addSubview(videoTagCategoriesNavBar)
        videoTagCategoriesNavBar.anchor(withTopAnchor: topPaddingView.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        
        // parent categories collection view
        self.view.insertSubview(parentCategoryCollectionView, belowSubview: videoTagCategoriesNavBar)
        parentCategoryCollectionView.anchor(withTopAnchor: nil, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 56.0)
        parentCategoryCollectionViewTopAnchorConstraint = NSLayoutConstraint(item: parentCategoryCollectionView, attribute: .top, relatedBy: .equal, toItem: videoTagCategoriesNavBar, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(parentCategoryCollectionViewTopAnchorConstraint)
        
        // max limit label - 5 to start
        remainingNumber = 5
        self.view.addSubview(maxLimitLabel)
        maxLimitLabel.anchor(withTopAnchor: parentCategoryCollectionView.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        // child categories collection view
        self.view.addSubview(childCategoryCollectionView)
        childCategoryCollectionView.anchor(withTopAnchor: maxLimitLabel.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // loading view
        self.view.addSubview(categoriesListLoadingView)
        categoriesListLoadingView.anchor(withTopAnchor: videoTagCategoriesNavBar.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        categoriesListLoadingView.addSubview(loadingContentView)
        loadingContentView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: categoriesListLoadingView.centerXAnchor, centreYAnchor: categoriesListLoadingView.centerYAnchor)
        
        // no data state
        self.view.addSubview(noCategoriesDataView)
        noCategoriesDataView.anchor(withTopAnchor: self.videoTagCategoriesNavBar.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil)
        
        // dismiss keyboard view
        self.view.addSubview(dismissKeyboardView)
        dismissKeyboardView.anchor(withTopAnchor: videoTagCategoriesNavBar.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
    }
    
    func setupChildDelegates() {
        videoTagCategoriesNavBar.delegate = self
    }
    
    func handleChildCategorySelection(atItemIndex itemIndex: Int, withSearchingCategoriesState isSearchingCategories: Bool) {
        /*-- what do we need to do --*/
        if isSearchingCategories {
            if remainingNumber > 0 {
                searchedCategories[itemIndex].isSelected = !searchedCategories[itemIndex].isSelected
                if searchedCategories[itemIndex].isSelected {
                    selectedCategories.append(searchedCategories[itemIndex])
                    remainingNumber -= 1
                } else {
                    selectedCategories = selectedCategories.filter { $0.name != searchedCategories[itemIndex].name }
                    remainingNumber += 1
                }
            } else {
                if selectedCategories.contains(where: { $0.name == searchedCategories[itemIndex].name}) {
                    searchedCategories[itemIndex].isSelected = false
                    selectedCategories = selectedCategories.filter { $0.name != searchedCategories[itemIndex].name }
                    remainingNumber += 1
                }
            }
            updateGeneralCategoryItem(withChildCategory: searchedCategories[itemIndex])
        } else {
            if remainingNumber > 0 {
                categories[selectedParentCategoryIndex].childCategories[itemIndex].isSelected = !categories[selectedParentCategoryIndex].childCategories[itemIndex].isSelected
                if categories[selectedParentCategoryIndex].childCategories[itemIndex].isSelected {
                    selectedCategories.append(categories[selectedParentCategoryIndex].childCategories[itemIndex])
                    remainingNumber -= 1
                } else {
                    selectedCategories = selectedCategories.filter { $0.name != categories[selectedParentCategoryIndex].childCategories[itemIndex].name }
                    remainingNumber += 1
                }
            } else {
                if selectedCategories.contains(where: { $0.name == categories[selectedParentCategoryIndex].childCategories[itemIndex].name }) {
                    categories[selectedParentCategoryIndex].childCategories[itemIndex].isSelected = false
                    selectedCategories = selectedCategories.filter { $0.name != categories[selectedParentCategoryIndex].childCategories[itemIndex].name }
                    remainingNumber += 1
                }
            }
        }
        
        /*-- update the UI --*/
        updateSelectedCategoriesCount()
        childCategoryCollectionView.reloadData()
    }
    
    func updateGeneralCategoryItem(withChildCategory childCategory: ChildCategory) {
        for i in 0..<categories.count {
            for a in 0..<categories[i].childCategories.count {
                if categories[i].childCategories[a].name == childCategory.name {
                    categories[i].childCategories[a].isSelected = childCategory.isSelected
                }
            }
        }
    }
}

// nav bar delegate methods
extension VideoTagCategoriesVC: VideoTagCategoriesNavBarDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchValueChanged(withValue searchValue: String) {
        searchedCategories = []
        isSearchingCategories = true
        categories.forEach { (category) in
            category.childCategories.forEach({ (childCategory) in
                if childCategory.name.lowercased().contains(find: searchValue.lowercased()) {
                    searchedCategories.append(childCategory)
                    print("adding category")
                }
            })
        }
        
        if searchedCategories.count > 0 {
            self.noCategoriesDataView.hide()
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
                self.parentCategoryCollectionViewTopAnchorConstraint.constant = -56.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.noCategoriesDataView.show(withMessage: "No categories for containing '\(searchValue)'")
        }
        
        childCategoryCollectionView.reloadData()
    }
    
    func searchValueCleared() {
        noCategoriesDataView.hide()
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
            self.parentCategoryCollectionViewTopAnchorConstraint.constant = 0.0
            self.isSearchingCategories = false
            self.childCategoryCollectionView.reloadData()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func skipButtonPressed() {
        navigateToKeywordsVC()
    }
    
    func nextButtonPressed() {
        navigateToKeywordsVC()
    }
    
    func navigateToKeywordsVC() {
        let tagKeywordsVC = VideoTagKeywordsVC()
        self.navigationController?.pushViewController(tagKeywordsVC, animated: true)
    }
}

// collection view delegate and data source methods
extension VideoTagCategoriesVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCategoriesDataLoaded {
            if collectionView == parentCategoryCollectionView {
                return categories.count
            } else {
                return isSearchingCategories ? searchedCategories.count : categories[selectedParentCategoryIndex].childCategories.count
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier: String = collectionView == parentCategoryCollectionView ? parentCategoryCellId : childCategoryCellId
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        
        if collectionView == parentCategoryCollectionView {
            let category = ChildCategory(
                id: categories[indexPath.item].id,
                name: categories[indexPath.item].name,
                backgroundColor: categories[indexPath.item].backgroundColor,
                isSelected: categories[indexPath.item].isSelected)
            cell.category = category
            
        } else {
            if isSearchingCategories {
                cell.category = searchedCategories[indexPath.item]
            } else {
                cell.category = categories[selectedParentCategoryIndex].childCategories[indexPath.item]
            }
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
            handleChildCategorySelection(atItemIndex: indexPath.item, withSearchingCategoriesState: isSearchingCategories)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == parentCategoryCollectionView {
            let parentCategoryCellWidth = categories[indexPath.item].name.widthOfString(usingFont: defaultParagraphFont) + 38.0
            return CGSize(width: parentCategoryCellWidth, height: 40.0)
            
        } else if collectionView == childCategoryCollectionView {
            var childCategoryCellWidth: CGFloat = 0.0
            
            /*-- searching state --*/
            if isSearchingCategories {
                childCategoryCellWidth = searchedCategories[indexPath.item].name.widthOfString(usingFont: defaultParagraphFont) + 38.0
                
            /*-- not searching state --*/
            } else {
                childCategoryCellWidth = categories[selectedParentCategoryIndex].childCategories[indexPath.item].name.widthOfString(usingFont: defaultParagraphFont) + 38.0
            }
            
            return CGSize(width: childCategoryCellWidth, height: 40.0)
        }
        
        /*-- if we reach here then something went wrong. collapse the cell --*/
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let topInset: CGFloat = collectionView == parentCategoryCollectionView ? 16.0 : 0.0
        return UIEdgeInsets(top: topInset, left: horizontalPadding, bottom: 0.0, right: horizontalPadding)
    }
}
