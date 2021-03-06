//
//  OtherUserProfileNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol OtherUserProfileNavBarDelegate {
    func backButtonPressed()
    func threeDotButtonPressed()
    func friendsButtonPressed()
    func followingButtonPressed()
    func followersButtonPressed()
    func eventsButtonPressed()
}

class OtherUserProfileNavBar: BaseView {
    
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
    
    let threeDotButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(threeDotButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let threeDotIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "three-dot-icon")
        return iv
    }()
    
    let interactionButton: UIButton = {
       let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = ditloLightGrey.cgColor
        button.layer.cornerRadius = 4.0
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(ditloOffBlack, for: .normal)
        button.titleLabel?.font = smallParagraphFont
        button.titleLabel?.textAlignment = .center
        return button
    }()
    var interactionButtonWidthConstraint: NSLayoutConstraint!
    let centreInfoContainerView = UIView()
    
    let profileNameLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.numberOfLines = 1
        label.text = "Gareth Bale"
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
    
    let bottomRowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let friendsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(friendsButtonPressed), for: .touchUpInside)
        return button
    }()
    let friendsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "32"
        label.textColor = ditloOffBlack
        label.font = smallTitleFont
        label.textAlignment = .center
        return label
    }()
    
    let friendsNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Friends"
        label.textColor = ditloOffBlack
        label.font = largeProfileInfoJobFont
        label.textAlignment = .center
        return label
    }()
    
    let followingButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(followingButtonPressed), for: .touchUpInside)
        return button
    }()
    let followingCountLabel: UILabel = {
        let label = UILabel()
        label.text = "123"
        label.textColor = ditloOffBlack
        label.font = smallTitleFont
        label.textAlignment = .center
        return label
    }()
    
    let followingNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Following"
        label.textColor = ditloOffBlack
        label.font = largeProfileInfoJobFont
        label.textAlignment = .center
        return label
    }()
    
    let followersButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(followersButtonPressed), for: .touchUpInside)
        return button
    }()
    let followersCountLabel: UILabel = {
        let label = UILabel()
        label.text = "7.2K"
        label.textColor = ditloOffBlack
        label.font = smallTitleFont
        label.textAlignment = .center
        return label
    }()
    
    let followersNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Followers"
        label.textColor = ditloOffBlack
        label.font = largeProfileInfoJobFont
        label.textAlignment = .center
        return label
    }()
    
    let eventsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(eventsButtonPressed), for: .touchUpInside)
        return button
    }()
    let eventsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textColor = ditloOffBlack
        label.font = smallTitleFont
        label.textAlignment = .center
        return label
    }()
    
    let eventsNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Events"
        label.textColor = ditloOffBlack
        label.font = largeProfileInfoJobFont
        label.textAlignment = .center
        return label
    }()
    
    // delegate
    var delegate: OtherUserProfileNavBarDelegate?
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        anchorSubviews()
    }
    
    func anchorSubviews() {
        // top row
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
        
        topRowView.addSubview(threeDotButton)
        threeDotButton.anchor(withTopAnchor: topRowView.topAnchor, leadingAnchor: nil, bottomAnchor: topRowView.bottomAnchor, trailingAnchor: topRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 58.0, heightAnchor: nil)
        threeDotButton.addSubview(threeDotIcon)
        threeDotIcon.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: threeDotButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: threeDotButton.centerYAnchor, widthAnchor: 17.0, heightAnchor: 4.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        
        topRowView.addSubview(interactionButton)
        interactionButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: threeDotButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor, widthAnchor: nil, heightAnchor: 26.0)
        let interactionButtonWidth = (interactionButton.titleLabel?.text?.widthOfString(usingFont: smallParagraphFont))! + 24.0
        interactionButtonWidthConstraint = NSLayoutConstraint(item: interactionButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: interactionButtonWidth)
        addConstraint(interactionButtonWidthConstraint)
        
        topRowView.addSubview(centreInfoContainerView)
        centreInfoContainerView.anchor(withTopAnchor: nil, leadingAnchor: roundedBorderView.trailingAnchor, bottomAnchor: nil, trailingAnchor: interactionButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 12.0, bottom: 0.0, right: -12.0))
        
        centreInfoContainerView.addSubview(profileNameLabel)
        profileNameLabel.anchor(withTopAnchor: centreInfoContainerView.topAnchor, leadingAnchor: centreInfoContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: centreInfoContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 14.0)
        
        centreInfoContainerView.addSubview(profileJobButton)
        profileJobButton.anchor(withTopAnchor: profileNameLabel.bottomAnchor, leadingAnchor: centreInfoContainerView.leadingAnchor, bottomAnchor: centreInfoContainerView.bottomAnchor, trailingAnchor: centreInfoContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 11.0, padding: .init(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        profileJobButton.addSubview(profileJobLabel)
        profileJobLabel.anchor(withTopAnchor: profileJobButton.topAnchor, leadingAnchor: profileJobButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: profileJobButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 11.0)
        
        // bottom row
        addSubview(bottomRowView)
        bottomRowView.anchor(withTopAnchor: topRowView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil)
        
        // friends
        bottomRowView.addSubview(friendsButton)
        friendsButton.anchor(withTopAnchor: bottomRowView.topAnchor, leadingAnchor: bottomRowView.leadingAnchor, bottomAnchor: bottomRowView.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 46.0, bottom: 0.0, right: 0.0))
        friendsButton.addSubview(friendsCountLabel)
        friendsCountLabel.anchor(withTopAnchor: friendsButton.topAnchor, leadingAnchor: friendsButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: friendsButton.trailingAnchor, centreXAnchor: friendsButton.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0))
        friendsButton.addSubview(friendsNameLabel)
        friendsNameLabel.anchor(withTopAnchor: friendsCountLabel.bottomAnchor, leadingAnchor: friendsButton.leadingAnchor, bottomAnchor: friendsButton.bottomAnchor, trailingAnchor: friendsButton.trailingAnchor, centreXAnchor: friendsButton.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: -10.0, right: 0.0))
        
        // following
        bottomRowView.addSubview(followingButton)
        followingButton.anchor(withTopAnchor: bottomRowView.topAnchor, leadingAnchor: friendsButton.trailingAnchor, bottomAnchor: bottomRowView.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0))
        followingButton.addSubview(followingCountLabel)
        followingCountLabel.anchor(withTopAnchor: followingButton.topAnchor, leadingAnchor: followingButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: followingButton.trailingAnchor, centreXAnchor: followingButton.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0))
        followingButton.addSubview(followingNameLabel)
        followingNameLabel.anchor(withTopAnchor: followingCountLabel.bottomAnchor, leadingAnchor: followingButton.leadingAnchor, bottomAnchor: followingButton.bottomAnchor, trailingAnchor: followingButton.trailingAnchor, centreXAnchor: followingButton.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: -10.0, right: 0.0))
        
        // followers
        bottomRowView.addSubview(followersButton)
        followersButton.anchor(withTopAnchor: bottomRowView.topAnchor, leadingAnchor: followingButton.trailingAnchor, bottomAnchor: bottomRowView.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0))
        followersButton.addSubview(followersCountLabel)
        followersCountLabel.anchor(withTopAnchor: followersButton.topAnchor, leadingAnchor: followersButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: followersButton.trailingAnchor, centreXAnchor: followersButton.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0))
        followersButton.addSubview(followersNameLabel)
        followersNameLabel.anchor(withTopAnchor: followersCountLabel.bottomAnchor, leadingAnchor: followersButton.leadingAnchor, bottomAnchor: followersButton.bottomAnchor, trailingAnchor: followersButton.trailingAnchor, centreXAnchor: followersButton.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: -10.0, right: 0.0))
        
        // events
        bottomRowView.addSubview(eventsButton)
        eventsButton.anchor(withTopAnchor: bottomRowView.topAnchor, leadingAnchor: nil, bottomAnchor: bottomRowView.bottomAnchor, trailingAnchor: bottomRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        eventsButton.addSubview(eventsCountLabel)
        eventsCountLabel.anchor(withTopAnchor: eventsButton.topAnchor, leadingAnchor: eventsButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: eventsButton.trailingAnchor, centreXAnchor: eventsButton.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0))
        eventsButton.addSubview(eventsNameLabel)
        eventsNameLabel.anchor(withTopAnchor: eventsCountLabel.bottomAnchor, leadingAnchor: eventsButton.leadingAnchor, bottomAnchor: eventsButton.bottomAnchor, trailingAnchor: eventsButton.trailingAnchor, centreXAnchor: eventsButton.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: -10.0, right: 0.0))
    }
}

// selector methods
extension OtherUserProfileNavBar {
    @objc func backButtonPressed() {
        delegate?.backButtonPressed()
    }
    
    @objc func threeDotButtonPressed() {
        delegate?.threeDotButtonPressed()
    }
    
    @objc func friendsButtonPressed() {
        delegate?.friendsButtonPressed()
    }
    
    @objc func followingButtonPressed() {
        delegate?.followingButtonPressed()
    }
    
    @objc func followersButtonPressed() {
        delegate?.followersButtonPressed()
    }
    
    @objc func eventsButtonPressed() {
        delegate?.eventsButtonPressed()
    }
}
