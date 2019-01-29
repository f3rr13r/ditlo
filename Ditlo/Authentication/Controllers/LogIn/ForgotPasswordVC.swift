//
//  ForgotPasswordVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/17/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    // injector variables
    var logInEmailAddress: String? = "" {
        didSet {
            if let logInEmailAddress = self.logInEmailAddress {
                self.emailAddress = logInEmailAddress
                emailInputView.input.text = self.emailAddress
                updateSendPasswordEmailButtonDisabledState(with: self.emailAddress)
            }
        }
    }

    // views
    let forgotPasswordNavBar: AuthenticationNavBar = {
        let navbar = AuthenticationNavBar()
        navbar.needsBackButton = true
        navbar.redRoundedButtonText = "SEND PASSWORD EMAIL"
        navbar.isRedRoundedButtonEnabled = false
        return navbar
    }()
    
    let titleLabel = TitleLabel()
    var titleLabelWidthConstraint: NSLayoutConstraint?
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    let emailInputView: CustomInputView = {
        let customInputView = CustomInputView()
        customInputView.inputType = .emailAddress
        customInputView.titleConfig = TitleLabelConfiguration(titleText: "EMAIL ADDRESS", titleFont: smallTitleFont)
        customInputView.hideBottomBorder = false
        return customInputView
    }()
    
    // variables
    var emailAddress: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        anchorChildViews()
        addDismissKeyboardGesture()
        setupChildDelegates()
    }
    
    func setupChildDelegates() {
        forgotPasswordNavBar.delegate = self
        emailInputView.delegate = self
    }
    
    func addDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(userDidTap(_:)))
        dismissKeyboardTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc func userDidTap(_ tap: UITapGestureRecognizer) {
        let tapLocation = tap.location(in: self.view)
        let forgotPasswordViewFrame: CGRect = forgotPasswordNavBar.frame
        let emailInputViewFrame: CGRect = emailInputView.frame
        
        if (!forgotPasswordViewFrame.contains(tapLocation) && !emailInputViewFrame.contains(tapLocation)) {
            emailInputView.dismissKeyboard()
        }
    }
    
    func anchorChildViews() {
        
        // custom navbar
        self.view.addSubview(forgotPasswordNavBar)
        forgotPasswordNavBar.anchor(withTopAnchor: self.view.safeAreaLayoutGuide.topAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: self.view.safeAreaLayoutGuide.centerXAnchor, centreYAnchor: nil)
        
        // title label
        let titleConfig = TitleLabelConfiguration(titleText: "FORGOT PASSWORD", titleFont: defaultTitleFont)
        titleLabel.titleConfig = titleConfig
        
        self.view.addSubview(titleLabel)
        titleLabel.anchor(withTopAnchor: forgotPasswordNavBar.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        // calculate title label width and height
        let titleLabelSize: CGSize = CGSize(width: titleConfig.titleText.widthOfString(usingFont: titleConfig.titleFont) + 1.0, height: titleConfig.titleText.heightOfString(usingFont: titleConfig.titleFont))
        titleLabelWidthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: titleLabelSize.width)
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: titleLabelSize.height)
        self.view.addConstraints([titleLabelWidthConstraint!, titleLabelHeightConstraint!])
        
        // email input view
        self.view.addSubview(emailInputView)
        emailInputView.anchor(withTopAnchor: titleLabel.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 50.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
}

// auth nav bar delegate methods
extension ForgotPasswordVC: AuthentationNavBarDelegate {
    
    func redRoundedButtonPressed() {
        self.view.isUserInteractionEnabled = false
        SharedModalsService.instance.showCustomOverlayModal(withMessage: "ATTEMPTING TO SEND EMAIL")
        AuthService.instance.sendForgotPasswordEmail(withEmailAddress: self.emailAddress) { (forgotPasswordResponse) in
            SharedModalsService.instance.hideCustomOverlayModal()
            self.view.isUserInteractionEnabled = true
            if forgotPasswordResponse.success {
                self.dismissForgotPasswordVC()
            } else {
                let errorMessageConfig = CustomErrorMessageConfig(title: "FORGOT PASSWORD ERROR", body: forgotPasswordResponse.errorMessage!)
                SharedModalsService.instance.showErrorMessageModal(withErrorMessageConfig: errorMessageConfig)
            }
        }
    }
    
    func backButtonPressed() {
        dismissForgotPasswordVC()
    }
    
    func dismissForgotPasswordVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

// custom input view delegate methods
extension ForgotPasswordVC: CustomInputViewDelegate {
    func inputClearButtonPressed(inputType: CustomInputType) {
        self.emailAddress = ""
        updateSendPasswordEmailButtonDisabledState(with: self.emailAddress)
    }
    
    func inputValueDidChange(inputType: CustomInputType, inputValue: String) {
        self.emailAddress = inputValue
        updateSendPasswordEmailButtonDisabledState(with: self.emailAddress)
    }
    
    func updateSendPasswordEmailButtonDisabledState(with emailAddress: String) {
        self.forgotPasswordNavBar.isRedRoundedButtonEnabled = isForgotPasswordEmailAddressValid(with: emailAddress)
    }
}
