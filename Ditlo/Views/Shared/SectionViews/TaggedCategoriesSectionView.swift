//
//  TaggedCategoriesSectionView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import DGCollectionViewLeftAlignFlowLayout

class TaggedCategoriesSectionView: BaseView {

    // views
    let taggedCategoriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Tagged Categories"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    private let categoryCellId: String = "categoryCellId"
    lazy var taggedCategoriesCollectionView: UICollectionView = {
        let layout = DGCollectionViewLeftAlignFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: horizontalPadding, bottom: 0.0, right: horizontalPadding)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCellId)
        return cv
    }()
    
    // variables
    var categories: [ChildCategory] = [
        ChildCategory(id: 301, name: "American Football", backgroundColor: ditloRed, isSelected: true),
        ChildCategory(id: 317, name: "Football", backgroundColor: ditloRed, isSelected: true),
        ChildCategory(id: 502, name: "Drinking", backgroundColor: ditloYellow, isSelected: true),
        ChildCategory(id: 501, name: "Eating", backgroundColor: ditloYellow, isSelected: true),
        ChildCategory(id: 213, name: "Television", backgroundColor: ditloDarkGreen, isSelected: true)
    ]
    
    // delegate
    var delegate: SectionViewActionDelegate?
    
    override func setupViews() {
        super.setupViews()
        addSubview(taggedCategoriesLabel)
        taggedCategoriesLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        addSubview(taggedCategoriesCollectionView)
        taggedCategoriesCollectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0)
        taggedCategoriesCollectionView.layoutIfNeeded();
        taggedCategoriesCollectionView.anchor(withTopAnchor: taggedCategoriesLabel.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: taggedCategoriesCollectionView.contentSize.height, padding: .init(top: 24.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
}

// collection view data source
extension TaggedCategoriesSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let taggedCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        taggedCategoryCell.needsSelectedUnderlineState = false
        taggedCategoryCell.category = categories[indexPath.item]
        return taggedCategoryCell
    }
}

// collection view delegate and flow layout
extension TaggedCategoriesSectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let categoryCellWidth = categories[indexPath.item].name.widthOfString(usingFont: defaultParagraphFont) + 38.0
        return CGSize(width: categoryCellWidth, height: 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.taggedCategoryCellSelected(withId: "some category id")
    }
}
