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
    let selectFavouriteCategoriesNavBar: AuthenticationNavBar = {
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
    var parentCategoryCollectionViewTopAnchorConstraint: NSLayoutConstraint?
    var parentCategoryCollectionViewHeightConstraint: NSLayoutConstraint?
    
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
        view.loadingContentMessage = "LOADING CATEGORIES LIST"
        return view
    }()
    
    let noSearchResultsView = UIView()
    
    let noSearchResultsLabel: UILabel = {
        let label = UILabel()
        label.font = smallTitleFont
        label.text = "NO MATCHING CATEGORIES FOUND"
        label.textColor = ditloVeryLightGrey
        label.textAlignment = .center
        return label
    }()
    
    let dismissKeyboardView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    
    // variables
    let selectFavouriteCategoriesInfoWindowConfig = CustomInfoMessageConfig(title: "PICK CATEGORIES THAT INTEREST YOU", body: "Select a few general or specific categories from our list that interest you. Doing this will help us to cater ditlo content that we think you will be interested in. Click skip to do this later")
    var isCategoriesDataLoaded: Bool = false
    var categories: [Category] = []
    var selectedParentCategoryIndex: Int = 0
    var isSearchingCategories: Bool = false
    var searchedCategories: [ChildCategory] = []
    var selectedCategoriesCount: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupChildDelegates()
        getCategoriesData()
        anchorChildViews()
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
    
    @objc func presentInfoWindowModal() {
        SharedModalsService.instance.showInfoWindowModal(withInfoWindowConfig: selectFavouriteCategoriesInfoWindowConfig, andAnimation: true)
    }
    
    @objc func dismissKeyboard() {
        searchCategoriesInput.dismissKeyboard()
    }
    
    func setupChildDelegates() {
        self.selectFavouriteCategoriesNavBar.delegate = self
        self.searchCategoriesInput.delegate = self
    }
    
    func getCategoriesData() {
        CategoriesService.instance.getCategoriesList(withToggleAll: true) { (categoriesData) in
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
            let categoryPostFix = selectedCategoriesCount > 1 ? "CATEGORIES" : "CATEGORY"
            selectFavouriteCategoriesNavBar.needsGreyBorderButton = false
            selectFavouriteCategoriesNavBar.redRoundedButtonText = "SELECT \(selectedCategoriesCount) \(categoryPostFix)"
            selectFavouriteCategoriesNavBar.needsRedRoundedButton = true
        } else {
            selectFavouriteCategoriesNavBar.needsRedRoundedButton = false
            selectFavouriteCategoriesNavBar.redRoundedButtonText = ""
            selectFavouriteCategoriesNavBar.needsGreyBorderButton = true
        }
    }
    
    func anchorChildViews() {
        // custom navbar
        self.view.addSubview(selectFavouriteCategoriesNavBar)
        selectFavouriteCategoriesNavBar.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: self.view.safeAreaLayoutGuide.centerXAnchor, centreYAnchor: nil)
        
        // title label
        let titleConfig = TitleLabelConfiguration(titleText: "PREFERRED CATEGORIES", titleFont: defaultTitleFont)
        titleLabel.titleConfig = titleConfig
        
        self.view.addSubview(titleLabel)
        titleLabel.anchor(withTopAnchor: selectFavouriteCategoriesNavBar.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
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
        parentCategoryCollectionView.anchor(withTopAnchor: nil, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        
        /*-- top anchor constraint -- */
        parentCategoryCollectionViewTopAnchorConstraint = NSLayoutConstraint(item: parentCategoryCollectionView, attribute: .top, relatedBy: .equal, toItem: searchCategoriesInput, attribute: .bottom, multiplier: 1.0, constant: 20.0)
        
        /*-- height constraint --*/
        parentCategoryCollectionViewHeightConstraint = NSLayoutConstraint(item: parentCategoryCollectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40.0)
        self.view.addConstraints([parentCategoryCollectionViewTopAnchorConstraint!, parentCategoryCollectionViewHeightConstraint!])
        
        // child categories collection view
        self.view.addSubview(childCategoryCollectionView)
        childCategoryCollectionView.anchor(withTopAnchor: parentCategoryCollectionView.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 24.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // loading stuff
        self.view.addSubview(categoriesListLoadingView)
        categoriesListLoadingView.anchor(withTopAnchor: searchCategoriesInput.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        categoriesListLoadingView.addSubview(loadingContentView)
        loadingContentView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: categoriesListLoadingView.centerXAnchor, centreYAnchor: categoriesListLoadingView.centerYAnchor)
        
        // searching -- no data state -- hidden by default
        noSearchResultsView.isHidden = true
        self.view.addSubview(noSearchResultsView)
        noSearchResultsView.anchor(withTopAnchor: searchCategoriesInput.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        noSearchResultsView.addSubview(noSearchResultsLabel)
        noSearchResultsLabel.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: noSearchResultsView.centerXAnchor, centreYAnchor: noSearchResultsView.centerYAnchor)
        
        // dismiss keyboard view
        self.view.addSubview(dismissKeyboardView)
        dismissKeyboardView.fillSuperview()
    }
}


// custom nav bar delegate methods
extension SelectFavouriteCategoriesVC: AuthentationNavBarDelegate {
    func greyBorderRoundedButtonPressed(buttonType: GreyBorderRoundedButtonType?) {
        self.navigationController?.navigateIntoMainApp(withAnimation: true)
    }
    
    func redRoundedButtonPressed() {
        self.view.isUserInteractionEnabled = false
        SharedModalsService.instance.showCustomOverlayModal(withMessage: "SAVING FAVOURITE CATEGORIES")
        var selectedCategoryIds: [Int] = []
        for i in 0..<categories.count {
            for a in 0..<categories[i].childCategories.count {
                if !categories[i].childCategories[a].name.contains(find: "Toggle All") && categories[i].childCategories[a].isSelected {
                    selectedCategoryIds.append(categories[i].childCategories[a].id)
                }
            }
        }
        
        UserService.instance.updateUserData(withName: "favouriteCategoryIds", andValue: selectedCategoryIds) { (favouriteCategoriesStoredSuccessfully) in
            SharedModalsService.instance.hideCustomOverlayModal()
            self.view.isUserInteractionEnabled = true
            if favouriteCategoriesStoredSuccessfully {
                self.navigationController?.navigateIntoMainApp(withAnimation: true)
            } else {
                let favouriteCategoriesErrorConfig = CustomErrorMessageConfig(title: "FAVOURITE CATEGORIES ERROR", body: "Something went wrong when trying to save your chosen favourite categories. Please try again, or click the 'skip' button to return to it later")
                SharedModalsService.instance.showErrorMessageModal(withErrorMessageConfig: favouriteCategoriesErrorConfig)
            }
        }
    }
}


// input delegate methods
extension SelectFavouriteCategoriesVC: CustomInputViewDelegate {
    
    func inputValueDidChange(inputType: CustomInputType, inputValue: String) {
        searchedCategories = []
        if !inputValue.isEmpty && !inputValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            for i in 0..<categories.count {
                for a in 0..<categories[i].childCategories.count {
                    if !categories[i].childCategories[a].name.contains(find: "Toggle All") && categories[i].childCategories[a].name.lowercased().contains(find: inputValue.lowercased()) {
                        searchedCategories.append(categories[i].childCategories[a])
                    }
                }
            }
            
            if searchedCategories.count > 0 {
                isSearchingCategories = true
                parentCategoryCollectionViewTopAnchorConstraint?.constant = 0.0
                parentCategoryCollectionViewHeightConstraint?.constant = 0.0
                noSearchResultsView.isHidden = true
            } else {
                // show a no data state
                noSearchResultsView.isHidden = false
            }
        } else {
            isSearchingCategories = false
            parentCategoryCollectionViewTopAnchorConstraint?.constant = 20.0
            parentCategoryCollectionViewHeightConstraint?.constant = 40.0
        }
        
        childCategoryCollectionView.reloadData()
    }
    
    func inputClearButtonPressed(inputType: CustomInputType) {
        isSearchingCategories = false
        noSearchResultsView.isHidden = true
        parentCategoryCollectionViewTopAnchorConstraint?.constant = 20.0
        parentCategoryCollectionViewHeightConstraint?.constant = 40.0
        childCategoryCollectionView.reloadData()
    }
}


// collection view delegate and datasource methods
extension SelectFavouriteCategoriesVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCategoriesDataLoaded {
            
            // parent categories
            if collectionView == parentCategoryCollectionView {
                return categories.count
                
            // child categories
            } else {
                return isSearchingCategories ? searchedCategories.count : categories[selectedParentCategoryIndex].childCategories.count
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier: String = collectionView == parentCategoryCollectionView ? parentCategoryCellId : childCategoryCellId
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        
        /*-- parent --*/
        if collectionView == parentCategoryCollectionView {
            let category = ChildCategory(
                id: categories[indexPath.item].id,
                name: categories[indexPath.item].name,
                backgroundColor: categories[indexPath.item].backgroundColor,
                isSelected: categories[indexPath.item].isSelected)
            cell.category = category
            
        /*-- child category --*/
        } else {
            
            /*-- searching --*/
            if isSearchingCategories {
                cell.category = searchedCategories[indexPath.item]
                
            /*-- not searching --*/
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
            
            /*-- searching --*/
            if isSearchingCategories {
                searchedCategories[indexPath.item].isSelected = !searchedCategories[indexPath.item].isSelected
                
                for i in 0..<categories.count {
                    for a in 0..<categories[i].childCategories.count {
                        if categories[i].childCategories[a].name == searchedCategories[indexPath.item].name {
                            categories[i].childCategories[a].isSelected = searchedCategories[indexPath.item].isSelected
                            if !categories[i].childCategories[a].isSelected {
                                categories[i].allCategoriesSelected = false
                            }
                        }
                    }
                }
                
                updateSelectedCategoriesCount()
                childCategoryCollectionView.reloadData()
                
            /*-- not searching --*/
            } else {
                
                /*-- toggle all --*/
                if categories[selectedParentCategoryIndex].childCategories[indexPath.item].name.contains(find: "Toggle All") {
                    if categories[selectedParentCategoryIndex].allCategoriesSelected {
                        for i in 0..<categories[selectedParentCategoryIndex].childCategories.count {
                            categories[selectedParentCategoryIndex].childCategories[i].isSelected = false
                        }
                    } else {
                        for i in 0..<categories[selectedParentCategoryIndex].childCategories.count {
                            categories[selectedParentCategoryIndex].childCategories[i].isSelected = true
                        }
                    }
                    
                    /*-- change the selected value of the parent --*/
                    categories[selectedParentCategoryIndex].allCategoriesSelected = !categories[selectedParentCategoryIndex].allCategoriesSelected
                    updateSelectedCategoriesCount()
                    childCategoryCollectionView.reloadData()
                    
                    /*-- individual category --*/
                } else {
                    categories[selectedParentCategoryIndex].childCategories[indexPath.item].isSelected = !categories[selectedParentCategoryIndex].childCategories[indexPath.item].isSelected
                    
                    if categories[selectedParentCategoryIndex].childCategories[indexPath.item].isSelected == false {
                        categories[selectedParentCategoryIndex].allCategoriesSelected = false
                    }
                    
                    updateSelectedCategoriesCount()
                    childCategoryCollectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /*-- parent category --*/
        if collectionView == parentCategoryCollectionView {
            let parentCategoryCellWidth = categories[indexPath.item].name.widthOfString(usingFont: defaultParagraphFont) + 38.0
            return CGSize(width: parentCategoryCellWidth, height: 40.0)
            
        /*-- child category --*/
        } else if collectionView == childCategoryCollectionView {
            var childCategoryCellWidth: CGFloat = 0.0
            
            /*-- searching --*/
            if isSearchingCategories {
                childCategoryCellWidth = searchedCategories[indexPath.item].name.widthOfString(usingFont: defaultParagraphFont) + 38.0
                
            /*-- not searching --*/
            } else {
                childCategoryCellWidth = categories[selectedParentCategoryIndex].childCategories[indexPath.item].name.widthOfString(usingFont: defaultParagraphFont) + 38.0
            }
            return CGSize(width: childCategoryCellWidth, height: 40.0)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: horizontalPadding, bottom: 0.0, right: horizontalPadding)
    }
}
