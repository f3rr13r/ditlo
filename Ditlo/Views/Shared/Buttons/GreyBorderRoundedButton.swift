//
//  GreyBorderRoundedButton.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/17/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

protocol GreyBorderRoundedButtonDelegate {
    func greyBorderRoundedButtonTapped()
}

class GreyBorderRoundedButton: BaseView {

    // injector variables
    var buttonText: String? = "LOADING..." {
        didSet {
            if let buttonText = buttonText {
                buttonTextLabel.text = buttonText
            }
        }
    }
    
    // views
    let buttonTextLabel: UILabel = {
        let label = UILabel()
        label.text = "LOADING..."
        label.textColor = ditloOffBlack
        label.font = redButtonFont
        label.textAlignment = .center
        return label
    }()

    // delegate
    var delegate: GreyBorderRoundedButtonDelegate?
    
    override func setupViews() {
        super.setupViews()
        layer.borderColor = ditloLightGrey.cgColor
        layer.borderWidth = 1.0
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
        if let buttonText = self.buttonText {
            delegate?.greyBorderRoundedButtonTapped()
        }
    }
}
