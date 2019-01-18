//
//  CustomInputView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/17/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

enum CustomInputType {
    case emailAddress
    case name
    case password
}

protocol CustomInputViewDelegate {
    func inputValueDidChange(inputType: CustomInputType, inputValue: String)
    func forgotPasswordButtonPressed()
}

extension CustomInputViewDelegate {
    func forgotPasswordButtonPressed() { }
}

class CustomInputView: BaseView {
    
    // injector variables
    var inputType: CustomInputType? {
        didSet {
            if let inputType = self.inputType {
                if inputType == .password {
                    input.isSecureTextEntry = true
                }
            }
        }
    }
    
    var titleConfig: TitleLabelConfiguration? {
        didSet {
            if let titleConfig = self.titleConfig {
                titleLabel.titleConfig = titleConfig
                
                // calculate title label width and height
                let titleLabelSize: CGSize = CGSize(width: titleConfig.titleText.widthOfString(usingFont: titleConfig.titleFont) + 1.0, height: titleConfig.titleText.heightOfString(usingFont: titleConfig.titleFont))
                titleLabelWidthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: titleLabelSize.width)
                titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: titleLabelSize.height)
                self.addConstraints([titleLabelWidthConstraint!, titleLabelHeightConstraint!])
                
                // do the input placeholder text here also
                input.attributedPlaceholder = NSAttributedString(
                    string: "Enter your \(titleConfig.titleText.lowercased()) here", attributes: [NSAttributedString.Key.foregroundColor: ditloGrey])
            }
        }
    }
    
    // for pre-populating the forgot password field
    var initialInputValue: String? = "" {
        didSet {
            if let initialInputValue = self.initialInputValue {
                input.text = initialInputValue
            }
        }
    }
    
    var hideBottomBorder: Bool? = false {
        didSet {
            if let hideBottomBorder = self.hideBottomBorder {
                bottomBorder.isHidden = hideBottomBorder
            }
        }
    }
    
    var hideForgotPasswordButton: Bool? = true {
        didSet {
            if let hideForgotPasswordButton = self.hideForgotPasswordButton {
                forgotPasswordButton.isHidden = hideForgotPasswordButton
            }
        }
    }

    let titleLabel = TitleLabel()
    var titleLabelWidthConstraint: NSLayoutConstraint?
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = ditloLightGrey.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 3.0
        button.isHidden = true
        button.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let forgotPasswordButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password"
        label.textColor = ditloOffBlack
        label.font = forgotPasswordButtonFont
        label.textAlignment = .center
        return label
    }()
    
    let input: UITextField = {
        let textField = UITextField()
        textField.font = customInputFont
        textField.textColor = ditloOffBlack
        textField.clearButtonMode = .whileEditing
        textField.adjustsFontSizeToFitWidth = true
        textField.returnKeyType = .done
        textField.keyboardAppearance = .dark
        textField.addTarget(self, action: #selector(inputValueChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    let bottomBorder = PaddedBorderView()
    
    
    // delegate
    var delegate: CustomInputViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: safeAreaScreenWidth, height: 65.0)
    }

    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        setupChildDelegates()
        anchorChildViews()
    }
    
    func setupChildDelegates() {
        input.delegate = self
    }
    
    func anchorChildViews() {
        self.addSubview(titleLabel)
        titleLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        self.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(withTopAnchor: topAnchor, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 107.0, heightAnchor: 20.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        forgotPasswordButton.addSubview(forgotPasswordButtonLabel)
        forgotPasswordButtonLabel.fillSuperview()
        
        self.addSubview(input)
        input.anchor(withTopAnchor: titleLabel.bottomAnchor, leadingAnchor: titleLabel.leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: forgotPasswordButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: -1.0, right: 0.0))
        
        self.addSubview(bottomBorder)
        bottomBorder.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: bottomAnchor, trailingAnchor: nil, centreXAnchor: centerXAnchor, centreYAnchor: nil)
        
    }
}


// input and selector delegates
extension CustomInputView: UITextFieldDelegate {
    
    @objc func forgotPasswordButtonPressed() {
        delegate?.forgotPasswordButtonPressed()
    }
    
    @objc func inputValueChanged(_ input: UITextField) {
        if let inputType = self.inputType,
           let inputValue = input.text {
            delegate?.inputValueDidChange(inputType: inputType, inputValue: inputValue)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        if input.isFirstResponder {
            input.resignFirstResponder()
        }
    }
}
