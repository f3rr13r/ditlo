//
//  MainDitloNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/29/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

protocol MainDitloNavBarDelegate {
    func goHomeButtonPressed()
    func openCalendarButtonPressed()
    func profileIconButtonPressed()
}

class MainDitloNavBar: BaseView {

    // injector variables
    var profilePicture: UIImage? {
        didSet {
            if let profilePicture = self.profilePicture {
                self.profilePictureImageView.profilePicture = profilePicture
            }
        }
    }
    
    var areButtonsEnabled: Bool = false
    
    // views
    let topRowView = UIView()
    
    let homeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let ditloLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        let ditloLogo: UIImage = #imageLiteral(resourceName: "ditlo-logo")
        iv.image = ditloLogo
        return iv
    }()
    
    let ditloLogoLabel: UILabel = {
        let label = UILabel()
        label.text = "DITLO"
        label.font = navBarLogoFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    let calendarButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(calendarButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let calendarButtonLabel: UILabel = {
        let label = UILabel()
        label.font = navBarCalendarButtonFont
        label.textColor = ditloGrey
        label.text = "29 DECEMBER 18"
        return label
    }()
    
    let calendarArrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        let arrowIcon: UIImage = #imageLiteral(resourceName: "down-arrow-icon")
        iv.image = arrowIcon
        return iv
    }()
    
    let profilePictureImageView = RoundProfilePictureView()
    
    let bottomRowView = UIView()
    var bottomRowViewHeightConstraint: NSLayoutConstraint?
    
    let bottomBorderView = PaddedBorderView()
    
    // delegate
    var delegate: MainDitloNavBarDelegate?
    
    override func setupViews() {
        super.setupViews()
        handleChildDelegates()
        anchorChildSubviews()
    }
    
    func handleChildDelegates() {
        profilePictureImageView.delegate = self
    }
    
    func anchorChildSubviews() {
        // top row view
        self.addSubview(topRowView)
        topRowView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: screenWidth - (horizontalPadding * 2), heightAnchor: 48.0, padding: .init(top: 18.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        // home button
        topRowView.addSubview(homeButton)
        homeButton.anchor(withTopAnchor: topRowView.topAnchor, leadingAnchor: topRowView.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 20.0)
        
        // logo image view
        homeButton.addSubview(ditloLogoImageView)
        ditloLogoImageView.anchor(withTopAnchor: homeButton.topAnchor, leadingAnchor: homeButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 20.0, heightAnchor: 20.0)
        
        // logo label
        homeButton.addSubview(ditloLogoLabel)
        ditloLogoLabel.anchor(withTopAnchor: nil, leadingAnchor: ditloLogoImageView.trailingAnchor, bottomAnchor: nil, trailingAnchor: homeButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: ditloLogoLabel.centerYAnchor, widthAnchor: 82.0, heightAnchor: 20.0, padding: .init(top: 0.0, left: 6.0, bottom: 0.0, right: 0.0))
        
        // calendar button
        topRowView.addSubview(calendarButton)
        calendarButton.anchor(withTopAnchor: homeButton.bottomAnchor, leadingAnchor: topRowView.leadingAnchor, bottomAnchor: topRowView.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 20.0, padding: .init(top: 8.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // calendar button label
        calendarButton.addSubview(calendarButtonLabel)
        calendarButtonLabel.anchor(withTopAnchor: calendarButton.topAnchor, leadingAnchor: calendarButton.leadingAnchor, bottomAnchor: calendarButton.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil)
        
        // calendar arrow icon
        calendarButton.addSubview(calendarArrowImageView)
        calendarArrowImageView.anchor(withTopAnchor: nil, leadingAnchor: calendarButtonLabel.trailingAnchor, bottomAnchor: nil, trailingAnchor: calendarButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: calendarButtonLabel.centerYAnchor, widthAnchor: 20.0, heightAnchor: 20.0, padding: .init(top: 0.0, left: 6.0, bottom: 0.0, right: 0.0))
        
        // profile picture
        topRowView.addSubview(profilePictureImageView)
        profilePictureImageView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: topRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor)
        
        
        // bottom row -- categories and search pages
        self.addSubview(bottomRowView)
        bottomRowView.backgroundColor = ditloVeryLightGrey
        bottomRowView.anchor(withTopAnchor: topRowView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        bottomRowViewHeightConstraint = NSLayoutConstraint(item: bottomRowView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.0)
        self.addConstraint(bottomRowViewHeightConstraint!)
        
        // bottom border view
        self.addSubview(bottomBorderView)
        bottomBorderView.anchor(withTopAnchor: bottomRowView.bottomAnchor, leadingAnchor: nil, bottomAnchor: bottomAnchor, trailingAnchor: nil, centreXAnchor: centerXAnchor, centreYAnchor: nil)
    }
}

// button selector methods
extension MainDitloNavBar {
    @objc func homeButtonPressed() {
        if self.areButtonsEnabled {
            delegate?.goHomeButtonPressed()
        }
    }
    
    @objc func calendarButtonPressed() {
        if self.areButtonsEnabled {
            delegate?.openCalendarButtonPressed()
        }
    }
}

// delegate methods
extension MainDitloNavBar: RoundProfilePictureViewDelegate {
    func roundProfilePictureButtonPressed() {
        if self.areButtonsEnabled {
            delegate?.profileIconButtonPressed()
        }
    }
}
