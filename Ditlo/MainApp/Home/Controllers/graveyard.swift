//
//  graveyard.swift
//  Ditlo
//
//  Created by Harry Ferrier on 2/28/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import Foundation

//extension HomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 29
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: testCollectionViewCellId, for: indexPath) as? TestCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: testCollectionViewHeaderId, for: indexPath) as? TestCollectionViewHeader else { return UICollectionReusableView() }
//        return header
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var width: CGFloat!
//        let height: CGFloat!
//        
//        if indexPath.item == 0 || indexPath.item % 7 == 0 {
//            width = screenWidth
//            height = width * 1.44
//        } else {
//            width = (screenWidth - 2.0) / 2
//            height = width * 1.44
//        }
//        
//        return CGSize(width: width, height: height)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: -60.0, left: 0.0, bottom: 2.0, right: 0.0)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if collectionView == testCollectionView {
//            return CGSize(width: screenWidth, height: 60.0)
//        }
//        
//        return CGSize.zero
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 2.0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 2.0
//    }
//}
