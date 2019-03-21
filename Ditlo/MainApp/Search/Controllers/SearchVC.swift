//
//  SearchVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    // views
    let searchNavBar = SearchNavBar()
    let noDataView = NoDataView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        edgesForExtendedLayout = []
        setupChildDelegates()
        setupKeyboardDismissTapGesture()
        anchorSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSearchNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroySearchNavBar()
    }
    
    func setupSearchNavBar() {
        if let navigationController = self.navigationController {
            navigationController.hidesBarsOnSwipe = false
            navigationController.navigationItem.hidesBackButton = true
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.backgroundColor = .white
            navigationController.navigationBar.addSubview(searchNavBar)
            searchNavBar.anchor(withTopAnchor: navigationController.navigationBar.topAnchor, leadingAnchor: navigationController.navigationBar.leadingAnchor, bottomAnchor: nil, trailingAnchor: navigationController.navigationBar.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
            navigationController.navigationBar.layoutIfNeeded()
        }
    }
    
    func destroySearchNavBar() {
        searchNavBar.removeFromSuperview()
    }
    
    func setupChildDelegates() {
        searchNavBar.delegate = self
    }
    
    func setupKeyboardDismissTapGesture() {
        let keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        keyboardDismissTapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(keyboardDismissTapGesture)
    }
    
    @objc func dismissKeyboard() {
        searchNavBar.dismissKeyboard()
    }
    
    func anchorSubviews() {
        self.view.addSubview(noDataView)
        noDataView.fillSuperview()
    }
}

// search nav bar delegates
extension SearchVC: SearchNavBarDelegate {
    func searchInputWasTapped() {
        if noDataView.isVisible() {
            noDataView.hide()
        }
    }
    
    func searchButtonPressed(withValue searchValue: String) {
        search(withValue: searchValue)
    }
    
    func search(withValue searchValue: String) {
        SharedModalsService.instance.showCustomOverlayModal(withMessage: "Searching for '\(searchValue)'")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if searchValue != "show empty state" {
                let searchResultsVC = SearchResultsVC()
                searchResultsVC.searchResult = searchValue
                self.navigationController?.pushViewController(searchResultsVC, animated: true)
            } else {
                SharedModalsService.instance.hideCustomOverlayModal()
                let noDataMessage = "No results found for '\(searchValue)'"
                self.noDataView.show(withMessage: noDataMessage)
            }
        }
    }
}
