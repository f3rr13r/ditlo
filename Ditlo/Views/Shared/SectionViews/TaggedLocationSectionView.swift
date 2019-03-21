//
//  TaggedLocationSectionView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MapKit

class TaggedLocationSectionView: BaseView {
    
    // views
    let taggedLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Tagged Location"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    let locationButton: UIButton = {
        let button = UIButton()
        button.setTitle("U.S Bank Stadium, Minneapolis, USA", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ditloLightGrey
        button.layer.cornerRadius = 4.0
        button.titleLabel?.font = defaultParagraphFont
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // delegate
    var delegate: SectionViewActionDelegate?
    
    override func setupViews() {
        super.setupViews()
        addSubview(taggedLocationLabel)
        taggedLocationLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        addSubview(locationButton)
        locationButton.anchor(withTopAnchor: taggedLocationLabel.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 24.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
    }
    
    @objc func locationButtonPressed() {
        delegate?.taggedLocationSelected(withLocationValue: "some location value")
    }
}
