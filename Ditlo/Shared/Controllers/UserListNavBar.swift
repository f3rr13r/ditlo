//
//  UserListNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/19/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol UserListNavBarDelegate {
    func backButtonPressed()
}

class UserListNavBar: BaseView {
    
    // injector variables
    var userListConfiguration: UserListConfiguration? {
        didSet {
            if let userListConfiguration = userListConfiguration {
                userListTitleLabel.text = userListConfiguration.userListType.rawValue
            }
        }
    }
    
    // views
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
        label.text = "Frontend Web Developer"
        label.font = largeProfileInfoJobFont
        label.textColor = ditloOffBlack
        label.textAlignment = .left
        label.trailingBuffer = 8.0
        label.fadeLength = 6.0
        return label
    }()
    
    let userListTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    // delegate
    var delegate: UserListNavBarDelegate?
    
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
        
        topRowView.addSubview(centreInfoContainerView)
        centreInfoContainerView.anchor(withTopAnchor: nil, leadingAnchor: roundedBorderView.trailingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 12.0, bottom: 0.0, right: -12.0))
        
        centreInfoContainerView.addSubview(profileNameLabel)
        profileNameLabel.anchor(withTopAnchor: centreInfoContainerView.topAnchor, leadingAnchor: centreInfoContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: centreInfoContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 14.0)
        
        centreInfoContainerView.addSubview(profileJobButton)
        profileJobButton.anchor(withTopAnchor: profileNameLabel.bottomAnchor, leadingAnchor: centreInfoContainerView.leadingAnchor, bottomAnchor: centreInfoContainerView.bottomAnchor, trailingAnchor: centreInfoContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 11.0, padding: .init(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        profileJobButton.addSubview(profileJobLabel)
        profileJobLabel.anchor(withTopAnchor: profileJobButton.topAnchor, leadingAnchor: profileJobButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: profileJobButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 11.0)
        
        addSubview(userListTitleLabel)
        userListTitleLabel.anchor(withTopAnchor: topRowView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: horizontalPadding, bottom: -12.0, right: -horizontalPadding))
    }
    
    @objc func backButtonPressed() {
        delegate?.backButtonPressed()
    }
}
