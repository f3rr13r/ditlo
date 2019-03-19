//
//  SignUpVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/17/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    // views
    let signUpNavBar: AuthenticationNavBar = {
        let navbar = AuthenticationNavBar()
        navbar.needsBackButton = false
        navbar.redRoundedButtonText = "SIGN UP"
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
    var emailInputViewTopAnchorConstraint: NSLayoutConstraint?
    
    let nameInputView: CustomInputView = {
        let customInputView = CustomInputView()
        customInputView.inputType = .name
        customInputView.titleConfig = TitleLabelConfiguration(titleText: "FIRST AND LAST NAME(S)", titleFont: smallTitleFont)
        customInputView.hideBottomBorder = false
        return customInputView
    }()
    
    let passwordInputView: CustomInputView = {
        let customInputView = CustomInputView()
        customInputView.inputType = .password
        customInputView.titleConfig = TitleLabelConfiguration(titleText: "PASSWORD", titleFont: smallTitleFont)
        customInputView.hideBottomBorder = true
        return customInputView
    }()
    
    let logInButton = GreyBorderRoundedButton()
    var logInButtonWidthConstraint: NSLayoutConstraint?
    
    let logInQuestionLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have a ditlo account?"
        label.font = defaultParagraphFont
        label.textColor = ditloGrey
        label.numberOfLines = 0
        return label
    }()
    
    // variables
    var signUpInfo: SignupInfo = SignupInfo(emailAddress: "", name: "", password: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupChildDelegates()
        addDismissKeyboardGesture()
        anchorChildViews()
    }
    
    func setupChildDelegates() {
        signUpNavBar.delegate = self
        emailInputView.delegate = self
        nameInputView.delegate = self
        passwordInputView.delegate = self
        logInButton.delegate = self
    }
    
    func addDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(userDidTap(_:)))
        dismissKeyboardTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc func userDidTap(_ tap: UITapGestureRecognizer) {
        let tapLocation = tap.location(in: self.view)
        let signUpNavBarFrame: CGRect = signUpNavBar.frame
        let emailInputViewFrame: CGRect = emailInputView.frame
        let nameInputViewFrame: CGRect = nameInputView.frame
        let passwordInputViewFrame: CGRect = passwordInputView.frame
        
        if (!signUpNavBarFrame.contains(tapLocation) && !emailInputViewFrame.contains(tapLocation) && !nameInputViewFrame.contains(tapLocation) && !passwordInputViewFrame.contains(tapLocation)) {
            emailInputView.dismissKeyboard()
            nameInputView.dismissKeyboard()
            passwordInputView.dismissKeyboard()
        }
    }
    
    func anchorChildViews() {
        // custom navbar
        self.view.addSubview(signUpNavBar)
        signUpNavBar.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: self.view.safeAreaLayoutGuide.centerXAnchor, centreYAnchor: nil)
        
        // title label
        let titleConfig = TitleLabelConfiguration(titleText: "SIGN UP", titleFont: defaultTitleFont)
        titleLabel.titleConfig = titleConfig
        
        self.view.addSubview(titleLabel)
        titleLabel.anchor(withTopAnchor: signUpNavBar.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        // calculate title label width and height
        let titleLabelSize: CGSize = CGSize(width: titleConfig.titleText.widthOfString(usingFont: titleConfig.titleFont) + 1.0, height: titleConfig.titleText.heightOfString(usingFont: titleConfig.titleFont))
        titleLabelWidthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: titleLabelSize.width)
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: titleLabelSize.height)
        self.view.addConstraints([titleLabelWidthConstraint!, titleLabelHeightConstraint!])
        
        // email input view
        self.view.addSubview(emailInputView)
        emailInputView.anchor(withTopAnchor: nil, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        emailInputViewTopAnchorConstraint = NSLayoutConstraint(item: emailInputView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 50.0)
        self.view.addConstraint(emailInputViewTopAnchorConstraint!)
        
        // name input view
        self.view.addSubview(nameInputView)
        nameInputView.anchor(withTopAnchor: emailInputView.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // password input view
        self.view.addSubview(passwordInputView)
        passwordInputView.anchor(withTopAnchor: nameInputView.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // sign up button
        self.view.addSubview(logInButton)
        logInButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 26.0, padding: .init(top: 0.0, left: 0.0, bottom: -20.0, right: -horizontalPadding))
        logInButton.buttonText = "LOG IN"
        let logInButtonWidth: CGFloat = "LOG IN".widthOfString(usingFont: redButtonFont) + 32.0
        logInButtonWidthConstraint = NSLayoutConstraint(item: logInButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: logInButtonWidth)
        self.view.addConstraint(logInButtonWidthConstraint!)
        
        // sign up question
        self.view.addSubview(logInQuestionLabel)
        logInQuestionLabel.anchor(withTopAnchor: nil, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: logInButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: logInButton.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
    }
}

// auth nav bar delegate methods
extension SignUpVC: AuthentationNavBarDelegate {
    func redRoundedButtonPressed() {
        self.view.isUserInteractionEnabled = false
        SharedModalsService.instance.showCustomOverlayModal(withMessage: "CREATING DITLO ACCOUNT")
        AuthService.instance.signUpUser(with: self.signUpInfo) { (signUpResponse) in
            SharedModalsService.instance.hideCustomOverlayModal()
            self.view.isUserInteractionEnabled = true
            if signUpResponse.success {
                let selectProfilePictureVC = SelectProfilePictureVC()
                self.navigationController?.pushViewController(selectProfilePictureVC, animated: true)
            } else {
                let errorMessageConfig = CustomErrorMessageConfig(title: "SIGN UP ERROR", body: signUpResponse.errorMessage!)
                SharedModalsService.instance.showErrorMessageModal(withErrorMessageConfig: errorMessageConfig)
            }
        }
    }
}

// custom input delegate methods
extension SignUpVC: CustomInputViewDelegate {
    
    func inputValueDidChange(inputType: CustomInputType, inputValue: String) {
        switch inputType {
            case .emailAddress:
                self.signUpInfo.emailAddress = inputValue
                break
            case .name:
                self.signUpInfo.name = inputValue
                break
            case .password:
                self.signUpInfo.password = inputValue
                break
            case .unspecified:
                break
        }
        updateSignUpButtonDisabledState(with: self.signUpInfo)
    }
    
    func inputClearButtonPressed(inputType: CustomInputType) {
        switch inputType {
        case .emailAddress:
            self.signUpInfo.emailAddress = ""
            break
        case .name:
            self.signUpInfo.name = ""
            break
        case .password:
            self.signUpInfo.password = ""
            break
        case .unspecified:
            break
        }
        updateSignUpButtonDisabledState(with: self.signUpInfo)
    }
    
    func updateSignUpButtonDisabledState(with signUpInfo: SignupInfo) {
        signUpNavBar.isRedRoundedButtonEnabled = isSignUpInfoValid(with: signUpInfo)
    }
}

// navigate to log in button delegate
extension SignUpVC: GreyBorderRoundedButtonDelegate {
    func greyBorderRoundedButtonTapped(buttonType: GreyBorderRoundedButtonType?) {
        self.navigationController?.popViewController(animated: true)
    }
}
