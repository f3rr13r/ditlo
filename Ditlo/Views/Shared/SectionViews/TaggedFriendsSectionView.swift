//
//  TaggedFriendsSectionView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class TaggedFriendsSectionView: BaseView {
    
    // views
    let taggedFriendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Tagged Friends"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    private let userCellId: String = "userCellId"
    lazy var taggedFriendsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 107.0, height: 141.0)
        layout.minimumLineSpacing = 8.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: horizontalPadding, bottom: 0.0, right: horizontalPadding)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.decelerationRate = .fast
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(UserCell.self, forCellWithReuseIdentifier: userCellId)
        return cv
    }()
    
    // delegate
    var delegate: SectionViewActionDelegate?
    
    override func setupViews() {
        super.setupViews()
        addSubview(taggedFriendsLabel)
        taggedFriendsLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 00.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        addSubview(taggedFriendsCollectionView)
        taggedFriendsCollectionView.anchor(withTopAnchor: taggedFriendsLabel.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 141.0, padding: .init(top: 24.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
}

// collection view data source
extension TaggedFriendsSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: userCellId, for: indexPath) as? UserCell else {
            return UICollectionViewCell()
        }
        return userCell
    }
}

extension TaggedFriendsSectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.taggedFriendCellSelected(withId: "some friend id")
    }
}
