//
//  ContentSectionsCollectionView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 2/28/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class ContentSectionsView: BaseView {
    
    // injector variables
    
    // views
    private let cellId: String = "cellId"
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(UICollectionView.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
}

// collection view delegate and data source methods
extension ContentSectionsView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        if indexPath.item == 0 || indexPath.item == 2 {
            cell.backgroundColor = ditloOrange
        } else {
            cell.backgroundColor = ditloDarkBlue
        }
        return cell
    }
}
