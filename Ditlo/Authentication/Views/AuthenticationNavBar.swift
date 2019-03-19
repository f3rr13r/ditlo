//
//  AuthenticationNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/17/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

protocol AuthentationNavBarDelegate {
    func redRoundedButtonPressed()
    func backButtonPressed()
    func greyBorderRoundedButtonPressed(buttonType: GreyBorderRoundedButtonType?)
}

extension AuthentationNavBarDelegate {
    func redRoundedButtonPressed() { }
    func backButtonPressed() { }
    func greyBorderRoundedButtonPressed(buttonType: GreyBorderRoundedButtonType?) { }
}

class AuthenticationNavBar: BaseView {
    
    // injector variables
    var needsBackButton: Bool? = false {
        didSet {
            if let needsBackButton = self.needsBackButton {
                backArrowButtonWidthConstraint?.constant = needsBackButton ? 26.0 : 0.0
                ditloLogoImageViewLeadingConstraint?.constant = needsBackButton ? 38.0 : 20.0
                self.layoutIfNeeded()
            }
        }
    }
    
    var needsGreyBorderButton: Bool? = false {
        didSet {
            if let needsGreyBorderButton = self.needsGreyBorderButton {
                greyBorderRoundedButton.isHidden = !needsGreyBorderButton
            }
        }
    }
    
    var greyBorderRoundedButtonText: String? = "" {
        didSet {
            if let greyBorderRoundedButtonText = self.greyBorderRoundedButtonText {
                let updatedGreyBorderRoundedButtonWidth: CGFloat = greyBorderRoundedButtonText.widthOfString(usingFont: redButtonFont) + 32.0
                greyBorderRoundedButtonWidthConstraint?.constant = updatedGreyBorderRoundedButtonWidth
                greyBorderRoundedButton.buttonText = greyBorderRoundedButtonText
                self.layoutIfNeeded()
            }
        }
    }
    
    var needsRedRoundedButton: Bool? = true {
        didSet {
            if let needsRedRoundedButton = self.needsRedRoundedButton {
                redRoundedButton.isHidden = !needsRedRoundedButton
            }
        }
    }
    
    var redRoundedButtonText: String? = "" {
        didSet {
            if let redRoundedButtonText = self.redRoundedButtonText {
                let updatedRedRoundedButtonWidth: CGFloat = redRoundedButtonText.widthOfString(usingFont: redButtonFont) + 32.0
                redRoundedButtonWidthConstraint?.constant = updatedRedRoundedButtonWidth
                redRoundedButton.buttonText = redRoundedButtonText
                self.layoutIfNeeded()
            }
        }
    }
    
    var isRedRoundedButtonEnabled: Bool? = false {
        didSet {
            if let isRedRoundedButtonEnabled = self.isRedRoundedButtonEnabled {
                redRoundedButton.isEnabled = isRedRoundedButtonEnabled
            }
        }
    }
    
    // views
    let backArrowButton: UIButton = {
        let button = UIButton()
        let backArrowIcon = #imageLiteral(resourceName: "back-arrow-icon")
        button.setImage(backArrowIcon, for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    var backArrowButtonWidthConstraint: NSLayoutConstraint?
    
    let ditloLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        let ditloLogo: UIImage = #imageLiteral(resourceName: "ditlo-logo")
        iv.image = ditloLogo
        return iv
    }()
    var ditloLogoImageViewLeadingConstraint: NSLayoutConstraint?
    
    let ditloLogoLabel: UILabel = {
        let label = UILabel()
        label.text = "DITLO"
        label.font = navBarLogoFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    let redRoundedButton = RedRoundedButton()
    var redRoundedButtonWidthConstraint: NSLayoutConstraint?
    
    let greyBorderRoundedButton = GreyBorderRoundedButton()
    var greyBorderRoundedButtonWidthConstraint: NSLayoutConstraint?
    
    let bottomBorderView = PaddedBorderView()
    
    // delegate
    var delegate: AuthentationNavBarDelegate?

    override var intrinsicContentSize: CGSize {
        let navbarHeight: CGFloat = safeAreaTopPadding + 54.0
        return CGSize(width: screenWidth, height: navbarHeight)
    }
    
    override func setupViews() {
        super.setupViews()
        setupChildDelegates()
        anchorSubviews()
    }
    
    func setupChildDelegates() {
        redRoundedButton.delegate = self
        greyBorderRoundedButton.delegate = self
    }

    func anchorSubviews() {
        // back arrow button
        self.addSubview(backArrowButton)
        backArrowButton.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 26.0, padding: .init(top: 16.0, left: 6.0, bottom: 0.0, right: 0.0))
        backArrowButtonWidthConstraint = NSLayoutConstraint(item: backArrowButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 0.0)
        self.addConstraint(backArrowButtonWidthConstraint!)
        
        // logo image view
        self.addSubview(ditloLogoImageView)
        ditloLogoImageView.anchor(withTopAnchor: safeAreaLayoutGuide.topAnchor, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 20.0, heightAnchor: 20.0, padding: .init(top: 18.0, left: 0.0, bottom: 0.0, right: 0.0))
        ditloLogoImageViewLeadingConstraint = NSLayoutConstraint(item: ditloLogoImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 20.0)
        self.addConstraint(ditloLogoImageViewLeadingConstraint!)
        
        // red rounded button
        self.addSubview(redRoundedButton)
        redRoundedButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: ditloLogoImageView.centerYAnchor, widthAnchor: nil, heightAnchor: 26.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        redRoundedButtonWidthConstraint = NSLayoutConstraint(item: redRoundedButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 0.1)
        self.addConstraint(redRoundedButtonWidthConstraint!)
        
        // grey border rounded button
        greyBorderRoundedButton.isHidden = true
        self.addSubview(greyBorderRoundedButton)
        greyBorderRoundedButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: ditloLogoImageView.centerYAnchor, widthAnchor: nil, heightAnchor: 28.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        greyBorderRoundedButtonWidthConstraint = NSLayoutConstraint(item: greyBorderRoundedButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 0.1)
        self.addConstraint(greyBorderRoundedButtonWidthConstraint!)
        
        // logo label
        self.addSubview(ditloLogoLabel)
        ditloLogoLabel.anchor(withTopAnchor: nil, leadingAnchor: ditloLogoImageView.trailingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: ditloLogoImageView.centerYAnchor, widthAnchor: 82.0, heightAnchor: 20.0, padding: .init(top: 0.0, left: 6.0, bottom: 0.0, right: 0.0))
        
        // bottom border view
        self.addSubview(bottomBorderView)
        bottomBorderView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: bottomAnchor, trailingAnchor: nil, centreXAnchor: centerXAnchor, centreYAnchor: nil)
    }
}

// delegate and selector methods
extension AuthenticationNavBar: RedRoundedButtonDelegate, GreyBorderRoundedButtonDelegate {
    func redRoundedButtonTapped(withButtonType buttonType: RedRoundedButtonType?) {
        delegate?.redRoundedButtonPressed()
    }
    
    @objc func backButtonPressed() {
        delegate?.backButtonPressed()
    }
    
    func greyBorderRoundedButtonTapped(buttonType: GreyBorderRoundedButtonType?) {
        delegate?.greyBorderRoundedButtonPressed(buttonType: buttonType)
    }
}
