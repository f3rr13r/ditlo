//
//  OtherUserProfileNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

protocol OtherUserProfileNavBarDelegate {
    func backButtonPressed()
}

class OtherUserProfileNavBar: BaseView {
    
    let topRowView = UIView()
    
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
        button.setTitleColor(ditloGrey, for: .normal)
        button.titleLabel?.font = smallParagraphFont
        button.titleLabel?.textAlignment = .center
        return button
    }()
    var interactionButtonWidthConstraint: NSLayoutConstraint!
    
    let bottomPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = ditloLightGrey
        return view
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
        topRowView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 58.0)
        
        topRowView.addSubview(backButton)
        backButton.anchor(withTopAnchor: topRowView.topAnchor, leadingAnchor: topRowView.leadingAnchor, bottomAnchor: topRowView.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 58.0, heightAnchor: nil)
        backButton.addSubview(backButtonImageView)
        backButtonImageView.anchor(withTopAnchor: nil, leadingAnchor: topRowView.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor, widthAnchor: 26.0, heightAnchor: 26.0, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
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
        
        topRowView.addSubview(bottomPaddingView)
        bottomPaddingView.anchor(withTopAnchor: nil, leadingAnchor: topRowView.leadingAnchor, bottomAnchor: topRowView.bottomAnchor, trailingAnchor: topRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 1.0)
    }
}

// selector methods
extension OtherUserProfileNavBar {
    @objc func backButtonPressed() {
        delegate?.backButtonPressed()
    }
}
