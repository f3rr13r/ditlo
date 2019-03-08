//
//  EventCell.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class EventCell: BaseCell {
    
    // views
    var imageBorderView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = ditloLightGrey.cgColor
        view.layer.cornerRadius = 23.0
        return view
    }()
    
    var eventImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "event-profile-icon")
        iv.layer.cornerRadius = 20.0
        return iv
    }()
    
    var eventNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Super Bowl LII - Minneapolis"
        label.textColor = ditloOffBlack
        label.font = largeProfileInfoNameFont
        label.numberOfLines = 2
        return label
    }()
    
    var eventInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Public | 17.5k Members"
        label.textColor = ditloGrey
        label.font = smallProfileInfoJobFont
        label.numberOfLines = 1
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
        imageBorderView.anchor(withTopAnchor: nil, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: centerYAnchor, widthAnchor: 46.0, heightAnchor: 46.0, padding: .init(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0))
        imageBorderView.addSubview(eventImageView)
        eventImageView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: imageBorderView.centerXAnchor, centreYAnchor: imageBorderView.centerYAnchor, widthAnchor: 40.0, heightAnchor: 40.0)
        addSubview(eventNameLabel)
        eventNameLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: imageBorderView.trailingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 14.0, left: 10.0, bottom: 0.0, right: -20.0))
        addSubview(eventInfoLabel)
        eventInfoLabel.anchor(withTopAnchor: eventNameLabel.bottomAnchor, leadingAnchor: eventNameLabel.leadingAnchor, bottomAnchor: nil, trailingAnchor: eventNameLabel.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
}
