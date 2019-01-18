//
//  RedRoundedButton.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/17/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

enum RedRoundedButtonType {
    case unspecified
    case takePhoto
    case goToGallery
    case saveProfilePicture
}

protocol RedRoundedButtonDelegate {
    func redRoundedButtonTapped(withButtonType buttonType: RedRoundedButtonType?)
}

class RedRoundedButton: BaseView {

    // injector variables
    var buttonType: RedRoundedButtonType?
    
    var buttonText: String? = "LOADING..." {
        didSet {
            if let buttonText = buttonText {
                buttonTextLabel.text = buttonText
            }
        }
    }
    
    var isEnabled: Bool? = false {
        didSet {
            if let isEnabled = self.isEnabled {
                self.isUserInteractionEnabled = isEnabled
                self.alpha = isUserInteractionEnabled ? 1.0 : 0.5
            }
        }
    }
    
    // views
    let buttonTextLabel: UILabel = {
        let label = UILabel()
        label.text = "LOADING..."
        label.textColor = .white
        label.font = redButtonFont
        label.textAlignment = .center
        return label
    }()
    
    // delegate
    var delegate: RedRoundedButtonDelegate?
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = ditloRed
        layer.cornerRadius = 3.0
        
        anchorChildViews()
        setupTapGestureRecognizer()
    }
    
    func anchorChildViews() {
        self.addSubview(buttonTextLabel)
        buttonTextLabel.fillSuperview()
    }
    
    func setupTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        delegate?.redRoundedButtonTapped(withButtonType: self.buttonType)
    }
}
