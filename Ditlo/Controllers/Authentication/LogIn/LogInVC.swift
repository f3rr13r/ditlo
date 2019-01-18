//
//  LogInVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/17/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {
    
    // views
    let logInNavBar: AuthenticationNavBar = {
        let navbar = AuthenticationNavBar()
        navbar.needsBackButton = false
        navbar.redRoundedButtonText = "LOG IN"
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
    
    let passwordInputView: CustomInputView = {
        let customInputView = CustomInputView()
        customInputView.inputType = .password
        customInputView.titleConfig = TitleLabelConfiguration(titleText: "PASSWORD", titleFont: smallTitleFont)
        customInputView.hideForgotPasswordButton = false
        customInputView.hideBottomBorder = true
        return customInputView
    }()
    
    let signUpButton = GreyBorderRoundedButton()
    var signUpButtonWidthConstraint: NSLayoutConstraint?
    
    let signUpQuestionLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have a ditlo account yet?"
        label.font = defaultParagraphFont
        label.textColor = ditloGrey
        label.numberOfLines = 0
        return label
    }()
    
    // variables
    var loginInfo: LoginInfo = LoginInfo(emailAddress: "", password: "")
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setupChildDelegates()
        addDismissKeyboardGesture()
        anchorChildViews()
    }
    
    func setupChildDelegates() {
        logInNavBar.delegate = self
        emailInputView.delegate = self
        passwordInputView.delegate = self
        signUpButton.delegate = self
    }
    
    func addDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(userDidTap(_:)))
        dismissKeyboardTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc func userDidTap(_ tap: UITapGestureRecognizer) {
        let tapLocation = tap.location(in: self.view)
        let logInNavBarFrame: CGRect = logInNavBar.frame
        let emailInputViewFrame: CGRect = emailInputView.frame
        let passwordInputViewFrame: CGRect = passwordInputView.frame
        
        if (!logInNavBarFrame.contains(tapLocation) && !emailInputViewFrame.contains(tapLocation) && !passwordInputViewFrame.contains(tapLocation)) {
            emailInputView.dismissKeyboard()
            passwordInputView.dismissKeyboard()
        }
    }
    
    func anchorChildViews() {
        
        // custom navbar
        self.view.addSubview(logInNavBar)
        logInNavBar.anchor(withTopAnchor: self.view.safeAreaLayoutGuide.topAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: self.view.safeAreaLayoutGuide.centerXAnchor, centreYAnchor: nil)
        
        // title label
        let titleConfig = TitleLabelConfiguration(titleText: "LOG IN", titleFont: defaultTitleFont)
        titleLabel.titleConfig = titleConfig
        
        self.view.addSubview(titleLabel)
        titleLabel.anchor(withTopAnchor: logInNavBar.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        // calculate title label width and height
        let titleLabelSize: CGSize = CGSize(width: titleConfig.titleText.widthOfString(usingFont: titleConfig.titleFont) + 1.0, height: titleConfig.titleText.heightOfString(usingFont: titleConfig.titleFont))
        titleLabelWidthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: titleLabelSize.width)
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: titleLabelSize.height)
        self.view.addConstraints([titleLabelWidthConstraint!, titleLabelHeightConstraint!])
        
        
        // email input view
        self.view.addSubview(emailInputView)
        emailInputView.anchor(withTopAnchor: titleLabel.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 50.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // password input view
        self.view.addSubview(passwordInputView)
        passwordInputView.anchor(withTopAnchor: emailInputView.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // sign up button
        self.view.addSubview(signUpButton)
        signUpButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 26.0, padding: .init(top: 0.0, left: 0.0, bottom: -20.0, right: -horizontalPadding))
        signUpButton.buttonText = "SIGN UP"
        let signUpButtonWidth: CGFloat = "SIGN UP".widthOfString(usingFont: redButtonFont) + 32.0
        signUpButtonWidthConstraint = NSLayoutConstraint(item: signUpButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: signUpButtonWidth)
        self.view.addConstraint(signUpButtonWidthConstraint!)
        
        // sign up question
        self.view.addSubview(signUpQuestionLabel)
        signUpQuestionLabel.anchor(withTopAnchor: nil, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: signUpButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: signUpButton.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
    }
}

// auth nav bar delegate methods
extension LogInVC: AuthentationNavBarDelegate {
    func redRoundedButtonPressed() {
        self.navigationController?.showCustomOverlayModal(withMessage: "LOGGING IN TO DITLO")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigationController?.hideCustomOverlayModal()
        }
    }
}

// custom input view delegate methods
extension LogInVC: CustomInputViewDelegate {
    
    func inputValueDidChange(inputType: CustomInputType, inputValue: String) {
        switch inputType {
            case .emailAddress:
                self.loginInfo.emailAddress = inputValue
                break
            case .password:
                self.loginInfo.password = inputValue
                break
            default: return
        }
        
        updateLogInButtonDisabledState(with: self.loginInfo)
    }
    
    func updateLogInButtonDisabledState(with logInInfo: LoginInfo) {
        logInNavBar.isRedRoundedButtonEnabled = isLogInInfoValid(with: logInInfo)
    }
    
    func forgotPasswordButtonPressed() {
        let forgotPasswordVC = ForgotPasswordVC()
        if !loginInfo.emailAddress.isEmpty {
            forgotPasswordVC.logInEmailAddress = loginInfo.emailAddress
        }
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
}

// sign up button delegate methods
extension LogInVC: GreyBorderRoundedButtonDelegate {
    func greyBorderRoundedButtonTapped() {
        let signUpVC = SignUpVC()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
}
