//
//  NoDataView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/21/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class NoDataView: BaseView {
    
    // views
    let noDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = ditloGrey
        label.font = defaultParagraphFont
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        isHidden = true
        addSubview(noDataLabel)
        noDataLabel.anchor(withTopAnchor: nil, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
    }
    
    func show(withMessage message: String) {
        noDataLabel.text = message
        self.isHidden = false
    }
    
    func isVisible() -> Bool {
        return !isHidden
    }
    
    func hide() {
        noDataLabel.isHidden = true
        noDataLabel.text = nil
    }
}
