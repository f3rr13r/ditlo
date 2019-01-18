//
//  SelectJobPositionVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class SelectJobPositionVC: UIViewController {

    // views
    let selectJobPositionNavBar: AuthenticationNavBar = {
        let navbar = AuthenticationNavBar()
        navbar.needsBackButton = true
        navbar.needsRedRoundedButton = false
        navbar.isRedRoundedButtonEnabled = false
        navbar.needsGreyBorderButton = true
        navbar.greyBorderRoundedButtonText = "SKIP"
        return navbar
    }()
    
    let titleLabel = TitleLabel()
    var titleLabelWidthConstraint: NSLayoutConstraint?
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    let infoButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(presentInfoWindowModal), for: .touchUpInside)
        return button
    }()
    
    let infoButtonIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        let infoIcon = #imageLiteral(resourceName: "info-icon")
        iv.image = infoIcon
        return iv
    }()
    
    let searchJobsInput: CustomInputView = {
        let customInputView = CustomInputView()
        customInputView.titleConfig = TitleLabelConfiguration(titleText: "JOB KEYWORDS", titleFont: smallTitleFont)
        customInputView.hideBottomBorder = false
        customInputView.layer.zPosition = 2
        return customInputView
    }()
    

    let addJobContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        view.layer.zPosition = 1
        return view
    }()
    var addJobContainerTopConstraint: NSLayoutConstraint?

    let addJobButton = GreyBorderRoundedButton()
    var addJobButtonWidthConstraint: NSLayoutConstraint?

    let addJobLabel: UILabel = {
        let label = UILabel()
        label.text = "Can't find your job in the list?"
        label.textColor = ditloGrey
        label.font = defaultParagraphFont
        return label
    }()
    
    let addJobBottomBorder = PaddedBorderView()
    
    
    let dismissKeyboardView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    
    // variables
    let jobPositionInfoWindowConfig = CustomInfoMessageConfig(title: "SELECT YOUR JOB POSITION", body: "Select your job by searching from the list below, or add a new one to our database. Doing this will help you be more reachable to people who are interested in what you do. If you prefer not to then you can just click skip")
    var isAddJobViewVisible: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    
        setupChildDelegates()
        getCategoriesData()
        anchorChildViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func animateWithKeyboard(_ notification: NSNotification) {
        let moveUp = (notification.name == UIResponder.keyboardWillShowNotification)
        dismissKeyboardView.alpha = moveUp ? 1.0 : 0.0

    }
    
    @objc func presentInfoWindowModal() {
        self.navigationController?.showInfoWindowModal(withInfoWindowConfig: jobPositionInfoWindowConfig, andAnimation: true)
    }
    
    @objc func dismissKeyboard() {
        searchJobsInput.dismissKeyboard()
    }
    
    func showAddJobView() {
        addJobContainerView.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.addJobContainerTopConstraint?.constant = 0.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideAddJobView() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.addJobContainerTopConstraint?.constant = -44.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func setupChildDelegates() {
        selectJobPositionNavBar.delegate = self
    }
    
    func getCategoriesData() {
        JobService.instance.getJobsList()
    }
    
    func anchorChildViews() {
        // custom navbar
        self.view.addSubview(selectJobPositionNavBar)
        selectJobPositionNavBar.anchor(withTopAnchor: self.view.safeAreaLayoutGuide.topAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: self.view.safeAreaLayoutGuide.centerXAnchor, centreYAnchor: nil)
        
        // title label
        let titleConfig = TitleLabelConfiguration(titleText: "JOB POSITION", titleFont: defaultTitleFont)
        titleLabel.titleConfig = titleConfig
        
        self.view.addSubview(titleLabel)
        titleLabel.anchor(withTopAnchor: selectJobPositionNavBar.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        // calculate title label width and height
        let titleLabelSize: CGSize = CGSize(width: titleConfig.titleText.widthOfString(usingFont: titleConfig.titleFont) + 1.0, height: titleConfig.titleText.heightOfString(usingFont: titleConfig.titleFont))
        titleLabelWidthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: titleLabelSize.width)
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: titleLabelSize.height)
        self.view.addConstraints([titleLabelWidthConstraint!, titleLabelHeightConstraint!])
        
        // info button
        self.view.addSubview(infoButton)
        infoButton.anchor(withTopAnchor: titleLabel.topAnchor, leadingAnchor: titleLabel.trailingAnchor, bottomAnchor: titleLabel.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 10.0, bottom: 0.0, right: -horizontalPadding))
        infoButton.addSubview(infoButtonIconImageView)
        infoButtonIconImageView.anchor(withTopAnchor: nil, leadingAnchor: infoButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: infoButton.centerYAnchor, widthAnchor: 14.0, heightAnchor: 14.0)
        
        // search bar
        self.view.addSubview(searchJobsInput)
        searchJobsInput.anchor(withTopAnchor: titleLabel.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 30.0, left: 0.0, bottom: 0.0, right: 0.0))

       // add job stuff
        self.view.addSubview(addJobContainerView)
        addJobContainerView.anchor(withTopAnchor: searchJobsInput.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 44.0, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        addJobContainerTopConstraint = NSLayoutConstraint(item: addJobContainerView, attribute: .top, relatedBy: .equal, toItem: searchJobsInput, attribute: .bottom, multiplier: 1.0, constant: -44.0)
        self.view.addConstraint(addJobContainerTopConstraint!)
        
        addJobContainerView.addSubview(addJobButton)
        addJobButton.isUserInteractionEnabled = false
        addJobButton.buttonText = "ADD IT"
        addJobButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: addJobContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: addJobContainerView.centerYAnchor, widthAnchor: nil, heightAnchor: 26.0)
        let addJobButtonWidth = (addJobButton.buttonText?.widthOfString(usingFont: redButtonFont))! + 32.0
        addJobButtonWidthConstraint = NSLayoutConstraint(item: addJobButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: addJobButtonWidth)
        self.view.addConstraint(addJobButtonWidthConstraint!)

        addJobContainerView.addSubview(addJobLabel)
        addJobLabel.anchor(withTopAnchor: addJobContainerView.topAnchor, leadingAnchor: addJobContainerView.leadingAnchor, bottomAnchor: addJobContainerView.bottomAnchor, trailingAnchor: addJobButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: nil)

       // dismiss keyboard view
        self.view.addSubview(dismissKeyboardView)
        dismissKeyboardView.fillSuperview()
    }
}


// select job position nav bar delegate methods
extension SelectJobPositionVC: AuthentationNavBarDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func greyBorderRoundedButtonPressed() {
        if isAddJobViewVisible {
            hideAddJobView()
        } else {
            showAddJobView()
        }
        
        isAddJobViewVisible = !isAddJobViewVisible
    }
    
    func redRoundedButtonPressed() {
        // update profile on database, and proceed to next view controller
    }
}
