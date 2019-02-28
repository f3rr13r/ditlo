//
//  NavigationCollectionView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 2/28/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

protocol NavigationCollectionViewDelegate {
    func navigationCellSelected(itemIndex: Int)
}

class NavigationCollectionView: BaseView {

    // injector variables
    var navigationSections: [String] = [] {
        didSet {
            navigationCollectionView.reloadData()
            navigationCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    
    // views
    private let navigationCellId: String = "navigationCellId"
    lazy var navigationCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.register(NavigationCell.self, forCellWithReuseIdentifier: navigationCellId)
        return cv
    }()
    
    // delegate
    var delegate: NavigationCollectionViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: screenWidth, height: 30.0)
    }
    
    override func setupViews() {
        addSubview(navigationCollectionView)
        navigationCollectionView.fillSuperview()
    }
}

// collection view delegate and data source methods
extension NavigationCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return navigationSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let navigationCell = collectionView.dequeueReusableCell(withReuseIdentifier: navigationCellId, for: indexPath) as? NavigationCell else {
            return UICollectionViewCell()
        }
        navigationCell.title = navigationSections[indexPath.item]
        return navigationCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let navigationCellWidth: CGFloat = navigationSections[indexPath.item].widthOfString(usingFont: navigationCellFont) + 20.0
        return CGSize(width: navigationCellWidth, height: 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: horizontalPadding, bottom: 0.0, right: horizontalPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
