//
//  EventsNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/19/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol EventsNavBarDelegate {
    func backButtonPressed()
    func createEventButtonPressed()
    func notificationsButtonPressed()
}

class EventsNavBar: BaseView {

    let topRowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let backButtonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "back-arrow-icon")
        return iv
    }()
    
    let roundedBorderView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = ditloLightGrey.cgColor
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "bale-profile")
        iv.layer.cornerRadius = 18.0
        iv.backgroundColor = ditloLightGrey
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let notificationsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(notificationsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let notificationsIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "notifications-icon")
        return iv
    }()
    
    let centreInfoContainerView = UIView()
    
    let profileNameLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.numberOfLines = 1
        label.text = "Harry Ferrier"
        label.font = smallTitleFont
        label.textColor = ditloOffBlack
        label.trailingBuffer = 8.0
        label.fadeLength = 6.0
        return label
    }()
    
    let profileJobButton: UIButton = {
        let button = UIButton()
        // do selector
        return button
    }()
    
    let profileJobLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.numberOfLines = 1
        label.text = "Professional Football Player"
        label.font = largeProfileInfoJobFont
        label.textColor = ditloOffBlack
        label.textAlignment = .left
        label.trailingBuffer = 8.0
        label.fadeLength = 6.0
        return label
    }()
    
    let createEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Event", for: .normal)
        button.setTitleColor(ditloOffBlack, for: .normal)
        button.layer.cornerRadius = 4.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = ditloGrey.cgColor
        button.titleLabel?.font = smallParagraphFont
        button.addTarget(self, action: #selector(createEventButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let eventsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Events"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    // delegate
    var delegate: EventsNavBarDelegate?
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        anchorSubviews()
    }
    
    func anchorSubviews() {
        addSubview(topRowView)
        topRowView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 40.0)
        
        topRowView.addSubview(backButton)
        backButton.anchor(withTopAnchor: topRowView.topAnchor, leadingAnchor: topRowView.leadingAnchor, bottomAnchor: topRowView.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 44.0, heightAnchor: nil)
        backButton.addSubview(backButtonImageView)
        backButtonImageView.anchor(withTopAnchor: nil, leadingAnchor: topRowView.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor, widthAnchor: 26.0, heightAnchor: 26.0, padding: .init(top: 0.0, left: 14.0, bottom: 0.0, right: 0.0))
        
        topRowView.addSubview(roundedBorderView)
        roundedBorderView.anchor(withTopAnchor: nil, leadingAnchor: backButton.trailingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor, widthAnchor: 40.0, heightAnchor: 40.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
        roundedBorderView.addSubview(profileImageView)
        profileImageView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: roundedBorderView.centerXAnchor, centreYAnchor: roundedBorderView.centerYAnchor, widthAnchor: 36.0, heightAnchor: 36.0)
        
        topRowView.addSubview(notificationsButton)
        notificationsButton.anchor(withTopAnchor: topRowView.topAnchor, leadingAnchor: nil, bottomAnchor: topRowView.bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 60.0, heightAnchor: nil)
        notificationsButton.addSubview(notificationsIcon)
        notificationsIcon.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: notificationsButton.centerXAnchor, centreYAnchor: notificationsButton.centerYAnchor, widthAnchor: 20.0, heightAnchor: 20.0)
        
        topRowView.addSubview(centreInfoContainerView)
        centreInfoContainerView.anchor(withTopAnchor: nil, leadingAnchor: roundedBorderView.trailingAnchor, bottomAnchor: nil, trailingAnchor: notificationsButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 12.0, bottom: 0.0, right: -horizontalPadding))
        
        centreInfoContainerView.addSubview(profileNameLabel)
        profileNameLabel.anchor(withTopAnchor: centreInfoContainerView.topAnchor, leadingAnchor: centreInfoContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: centreInfoContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 14.0)
        
        centreInfoContainerView.addSubview(profileJobButton)
        profileJobButton.anchor(withTopAnchor: profileNameLabel.bottomAnchor, leadingAnchor: centreInfoContainerView.leadingAnchor, bottomAnchor: centreInfoContainerView.bottomAnchor, trailingAnchor: centreInfoContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 11.0, padding: .init(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        profileJobButton.addSubview(profileJobLabel)
        profileJobLabel.anchor(withTopAnchor: profileJobButton.topAnchor, leadingAnchor: profileJobButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: profileJobButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 11.0)
        
        addSubview(createEventButton)
        createEventButton.anchor(withTopAnchor: topRowView.bottomAnchor, leadingAnchor: nil, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 88.0, heightAnchor: 26.0, padding: .init(top: 12.0, left: 0.0, bottom: 12.0, right: -horizontalPadding))
        
        addSubview(eventsTitleLabel)
        eventsTitleLabel.anchor(withTopAnchor: nil, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: createEventButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: createEventButton.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
    }
    
    @objc func backButtonPressed() {
        delegate?.backButtonPressed()
    }
    
    @objc func notificationsButtonPressed() {
        delegate?.notificationsButtonPressed()
    }
    
    @objc func createEventButtonPressed() {
        delegate?.createEventButtonPressed()
    }
}
