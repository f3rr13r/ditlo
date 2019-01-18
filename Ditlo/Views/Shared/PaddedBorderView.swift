//
//  PaddedBorderView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/17/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class PaddedBorderView: BaseView {

    override var intrinsicContentSize: CGSize {
        let paddedBorderViewWidth: CGFloat = safeAreaScreenWidth - (horizontalPadding * 2)
        return CGSize(width: paddedBorderViewWidth, height: 1.0)
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = ditloLightGrey
        self.layer.cornerRadius = 0.5
    }

}
