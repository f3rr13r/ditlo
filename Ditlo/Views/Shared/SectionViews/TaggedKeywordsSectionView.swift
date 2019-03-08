//
//  HashtagsSectionView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import DGCollectionViewLeftAlignFlowLayout

class TaggedKeywordsSectionView: BaseView {
    
    // views
    let taggedKeywordsLabel: UILabel = {
        let label = UILabel()
        label.text = "Tagged Keywords"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    private let keywordCellId: String = "hashtagCellId"
    lazy var taggedKeywordsCollectionView: UICollectionView = {
        let layout = DGCollectionViewLeftAlignFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: horizontalPadding, bottom: 0.0, right: horizontalPadding)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: keywordCellId)
        return cv
    }()
    
    // delegate
    var delegate: SectionViewActionDelegate?
    
    // variables
    var keywords: [ChildCategory] = [
        ChildCategory(id: 0, name: "Superbowl", backgroundColor: ditloLightGrey, isSelected: true),
        ChildCategory(id: 0, name: "Let's Play Ball", backgroundColor: ditloLightGrey, isSelected: true),
        ChildCategory(id: 0, name: "USA", backgroundColor: ditloLightGrey, isSelected: true),
        ChildCategory(id: 0, name: "Tailgate Party", backgroundColor: ditloLightGrey, isSelected: true),
    ]
    
    override func setupViews() {
        super.setupViews()
        addSubview(taggedKeywordsLabel)
        taggedKeywordsLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        addSubview(taggedKeywordsCollectionView)
        taggedKeywordsCollectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0)
        taggedKeywordsCollectionView.layoutIfNeeded();
        taggedKeywordsCollectionView.anchor(withTopAnchor: taggedKeywordsLabel.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: taggedKeywordsCollectionView.contentSize.height, padding: .init(top: 24.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
}

// collection view data source
extension TaggedKeywordsSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let taggedKeywordsCell = collectionView.dequeueReusableCell(withReuseIdentifier: keywordCellId, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        taggedKeywordsCell.needsSelectedUnderlineState = false
        taggedKeywordsCell.category = keywords[indexPath.item]
        return taggedKeywordsCell
    }
}

// collection view delegate and flow layout
extension TaggedKeywordsSectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let keywordCellWidth = keywords[indexPath.item].name.widthOfString(usingFont: defaultParagraphFont) + 38.0
        return CGSize(width: keywordCellWidth, height: 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.taggedKeywordCellSelected(withValue: "some keyword value")
    }
}
