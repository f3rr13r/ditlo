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
    var isCategoriesDataLoaded: Bool = false
    var categories: [Category] = []
    var selectedParentCategoryIndex: Int = 0
    var isSearchingCategories: Bool = false
    var searchedCategories: [ChildCategory] = []
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
        for i in 0..<categories.count {
            if categories[i].allCategoriesSelected {
                selectedCategoriesCount += categories[i].childCategories.count - 1
            } else {
                for a in 0..<categories[i].childCategories.count {
                    if categories[i].childCategories[a].isSelected && !categories[i].childCategories[a].name.contains(find: "Toggle All") {
                        selectedCategoriesCount += 1
                    }
                }
            }
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
        
        // child categories collection view
        self.view.addSubview(childCategoryCollectionView)
        childCategoryCollectionView.anchor(withTopAnchor: parentCategoryCollectionView.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 24.0, left: 0.0, bottom: 0.0, right: 0.0))
        
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
        dismissKeyboardView.fillSuperview()
    }
    
    func setupChildDelegates() {
        videoTagCategoriesNavBar.delegate = self
    }
}

// nav bar delegate methods
extension VideoTagCategoriesVC: VideoTagCategoriesNavBarDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchValueChanged(withValue searchValue: String) {
        /*-- something funky is happening in here which is causing the
             keyboard to dismiss and reappear. needs to look into
             what part is breaking, and how we can solve it, possibly
             using the Dispatch.main branch from Grand Centre Dispatch --*/
        
        searchedCategories = []
        for i in 0..<categories.count {
            for a in 0..<categories[i].childCategories.count {
                if categories[i].childCategories[a].name.lowercased().contains(find: searchValue.lowercased()) {
                    searchedCategories.append(categories[i].childCategories[a])
                }
            }
        }
        
        if searchedCategories.count > 0 {
            noCategoriesDataView.hide()
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2, animations: {
                self.parentCategoryCollectionViewTopAnchorConstraint.constant = -56.0
                self.view.layoutIfNeeded()
            }) { (animationComplete) in
                self.view.isUserInteractionEnabled = true
                self.isSearchingCategories = true
            }
        } else {
            noCategoriesDataView.show(withMessage: "No categories found matching '\(searchValue)'")
        }
        
        childCategoryCollectionView.reloadData()
    }
    
    func searchValueCleared() {
        self.view.isUserInteractionEnabled = false
        noCategoriesDataView.hide()
        UIView.animate(withDuration: 0.2, animations: {
            self.parentCategoryCollectionViewTopAnchorConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            self.isSearchingCategories = false
            self.childCategoryCollectionView.reloadData()
            self.view.isUserInteractionEnabled = true
        }
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
            /*-- searching state --*/
            if isSearchingCategories {
                searchedCategories[indexPath.item].isSelected = !searchedCategories[indexPath.item].isSelected
                
                for i in 0..<categories.count {
                    for a in 0..<categories[i].childCategories.count {
                        if categories[i].childCategories[a].name == searchedCategories[indexPath.item].name {
                            categories[i].childCategories[a].isSelected = searchedCategories[indexPath.item].isSelected
                        }
                    }
                }
                
                updateSelectedCategoriesCount()
                childCategoryCollectionView.reloadData()
                
            /*-- not searching state --*/
            } else {
                categories[selectedParentCategoryIndex].childCategories[indexPath.item].isSelected = !categories[selectedParentCategoryIndex].childCategories[indexPath.item].isSelected
                
                updateSelectedCategoriesCount()
                childCategoryCollectionView.reloadData()
            }
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
