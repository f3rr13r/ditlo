//
//  PrivacyOptionView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/23/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

protocol PrivacyOptionViewActionDelegate {
    func optionViewTapped(withPrivacyOptionType privacyOption: PrivacyOption)
}

class PrivacyOptionView: BaseView {
    
    // views
    let infoButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(showInfoModal), for: .touchUpInside)
        return button
    }()
    
    let infoButtonIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "info-icon")
        return iv
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = smallTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
//    var descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.font = defaultParagraphFont
//        label.textColor = ditloOffBlack
//        return label
//    }()
    
    // delegate
    var delegate: PrivacyOptionViewActionDelegate?
    
    // variables
    private var _privacyOptionConfig: PrivacyOptionViewConfig?
    private var _isDescriptionVisible: Bool = false
    
    init(privacyOptionConfiguration: PrivacyOptionViewConfig) {
        super.init(frame: CGRect.zero)
        self.configurePrivacyOptionView(withConfig: privacyOptionConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        setupBorderStyling()
        setupTapGesture()
        anchorSubviews()
    }
    
    func configurePrivacyOptionView(withConfig config: PrivacyOptionViewConfig) {
        self._privacyOptionConfig = config
        self.titleLabel.text = config.name
        //self.descriptionLabel.text = config.description
    }
    
    func setupBorderStyling() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = ditloLightGrey.cgColor
        self.layer.cornerRadius = 4.0
    }
    
    func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(userDidTap))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    func anchorSubviews() {
        addSubview(infoButton)
        infoButton.anchor(withTopAnchor: topAnchor, leadingAnchor: nil, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 50.0, heightAnchor: nil)
        infoButton.addSubview(infoButtonIcon)
        infoButtonIcon.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: infoButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: infoButton.centerYAnchor, widthAnchor: 14.0, heightAnchor: 14.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -16.0))
        
        addSubview(titleLabel)
        titleLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 16.0, left: 16.0, bottom: -16.0, right: -16.0))
        
//        addSubview(descriptionLabel)
//        descriptionLabel.anchor(withTopAnchor: titleLabel.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: 12.0, bottom: -12.0, right: -12.0))
    }
    
    @objc func showInfoModal() {
        guard let config: PrivacyOptionViewConfig = _privacyOptionConfig else {
            presentErrorModal(withErrorMessage: "We could not get the relevant info for your selected privacy option")
            return
        }
        let infoMessageConfig = CustomInfoMessageConfig(title: "\(config.name) Video", body: config.description)
        SharedModalsService.instance.showInfoWindowModal(withInfoWindowConfig: infoMessageConfig, andAnimation: true)
    }
    
    @objc func userDidTap() {
        guard let privacyOption = _privacyOptionConfig?.privacyOption else {
            presentErrorModal(withErrorMessage: "We weren't able to confirm your privacy selection")
            return
        }
        delegate?.optionViewTapped(withPrivacyOptionType: privacyOption)
    }
    
    func presentErrorModal(withErrorMessage errorMessage: String) {
        let errorMessageConfig = CustomErrorMessageConfig(title: "Something went wrong", body: "\(errorMessage). Please try again or get in contact with us")
        SharedModalsService.instance.showErrorMessageModal(withErrorMessageConfig: errorMessageConfig)
    }
}
