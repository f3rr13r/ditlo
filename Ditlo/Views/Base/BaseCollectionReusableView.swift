//
//  BaseCollectionReusableView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 2/28/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class BaseCollectionReusableView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {}
}
