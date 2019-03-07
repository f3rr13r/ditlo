//
//  UserCell.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/7/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class UserCell: BaseCell {
    
    // views
    var imageBorderView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = ditloLightGrey.cgColor
        view.layer.cornerRadius = 30.0
        return view
    }()
    
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "bale-profile")
        iv.layer.cornerRadius = 26.0
        return iv
    }()
    
    var profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Gareth Bale"
        label.textAlignment = .center
        label.textColor = ditloOffBlack
        label.font = largeProfileInfoNameFont
        label.numberOfLines = 2
        return label
    }()
    
    var profileJobLabel: UILabel = {
        let label = UILabel()
        label.text = "Professional Footballer"
        label.textAlignment = .center
        label.textColor = ditloGrey
        label.font = smallProfileInfoJobFont
        label.numberOfLines = 2
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        layer.borderWidth = 1.0
        layer.borderColor = ditloLightGrey.cgColor
        layer.cornerRadius = 4.0
        
        anchorSubviews()
    }
    
    func anchorSubviews() {
        addSubview(imageBorderView)
        imageBorderView.anchor(withTopAnchor: topAnchor, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: centerXAnchor, centreYAnchor: nil, widthAnchor: 60.0, heightAnchor: 60.0, padding: .init(top: 18.0, left: 0.0, bottom: 0.0, right: 0.0))
        imageBorderView.addSubview(profileImageView)
        profileImageView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: imageBorderView.centerXAnchor, centreYAnchor: imageBorderView.centerYAnchor, widthAnchor: 52.0, heightAnchor: 52.0)
        addSubview(profileNameLabel)
        profileNameLabel.anchor(withTopAnchor: imageBorderView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 6.0, left: 10.0, bottom: 0.0, right: -10.0))
        addSubview(profileJobLabel)
        profileJobLabel.anchor(withTopAnchor: profileNameLabel.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 2.0, left: 10.0, bottom: 0.0, right: -10.0))
        let profileJobLabelBottomAnchor = profileJobLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -17.0)
        addConstraint(profileJobLabelBottomAnchor)
    }
}
