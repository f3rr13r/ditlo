//
//  TagEventsNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/26/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol VideoTagEventsNavBarDelegate {
    func backButtonPressed()
    func searchValueChanged(withValue searchValue: String)
    func searchValueCleared()
    func skipButtonPressed()
    func nextButtonPressed()
}

class VideoTagEventsNavBar: BaseView {
    
    // views
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "ditlo-logo")
        return iv
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "DITLO"
        label.textColor = ditloOffBlack
        label.font = largeProfileInfoNameFont
        return label
    }()
    
    let topContentRowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let backButtonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "back-arrow-icon")
        return iv
    }()
    
    let skipButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = ditloGrey.cgColor
        button.layer.cornerRadius = 4.0
        button.backgroundColor = .clear
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(ditloGrey, for: .normal)
        button.titleLabel?.font = smallParagraphFont
        button.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4.0
        button.backgroundColor = ditloRed
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = smallParagraphFont
        button.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        button.isHidden = true /*-- hidden by default --*/
        return button
    }()
    
    let tagEventsTitleLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.numberOfLines = 1
        label.text = "Tag Events"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        label.trailingBuffer = 8.0
        label.fadeLength = 6.0
        return label
    }()
    
    let searchInputView: UITextField = {
        let input = UITextField()
        input.layer.borderColor = ditloLightGrey.cgColor
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.font = customInputFont
        input.textColor = ditloOffBlack
        input.clearButtonMode = .whileEditing
        input.adjustsFontSizeToFitWidth = true
        input.returnKeyType = .done
        input.keyboardAppearance = .dark
        input.attributedPlaceholder = NSAttributedString(
            string: "What event are you looking for?", attributes: [NSAttributedString.Key.foregroundColor: ditloGrey])
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 12.0, height: 36))
        input.leftView = paddingView
        input.leftViewMode = .always
        input.addTarget(self, action: #selector(searchInputValueDidChange(_:)), for: .editingChanged)
        return input
    }()
    
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = ditloVeryLightGrey
        return view
    }()
    
    // delegate
    var delegate: VideoTagEventsNavBarDelegate?
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        handleChildDelegates()
        anchorSubviews()
    }
    
    func handleChildDelegates() {
        searchInputView.delegate = self
    }
    
    func anchorSubviews() {
        addSubview(topContentRowView)
        topContentRowView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        topContentRowView.addSubview(backButton)
        backButton.anchor(withTopAnchor: topContentRowView.topAnchor, leadingAnchor: topContentRowView.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 44.0, heightAnchor: 44.0)
        backButton.addSubview(backButtonImageView)
        backButtonImageView.anchor(withTopAnchor: backButton.topAnchor, leadingAnchor: backButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 26.0, heightAnchor: 26.0, padding: .init(top: 0.0, left: 14.0, bottom: 0.0, right: 0.0))
        
        topContentRowView.addSubview(logoImageView)
        logoImageView.anchor(withTopAnchor: topContentRowView.topAnchor, leadingAnchor: backButton.trailingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 10.0, heightAnchor: 10.0)
        
        topContentRowView.addSubview(skipButton)
        skipButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: topContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: backButton.centerYAnchor, widthAnchor: 60.0, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        
        topContentRowView.addSubview(nextButton)
        nextButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: topContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: backButton.centerYAnchor, widthAnchor: 60.0, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        
        topContentRowView.addSubview(logoLabel)
        logoLabel.anchor(withTopAnchor: nil, leadingAnchor: logoImageView.trailingAnchor, bottomAnchor: nil, trailingAnchor: skipButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: logoImageView.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 2.0, bottom: 0.0, right: -12.0))
        
        topContentRowView.addSubview(tagEventsTitleLabel)
        tagEventsTitleLabel.anchor(withTopAnchor: logoImageView.bottomAnchor, leadingAnchor: backButton.trailingAnchor, bottomAnchor: nil, trailingAnchor: skipButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 6.0, left: 0.0, bottom: 0.0, right: -12.0))
        
        topContentRowView.addSubview(searchInputView)
        searchInputView.anchor(withTopAnchor: tagEventsTitleLabel.bottomAnchor, leadingAnchor: backButton.trailingAnchor, bottomAnchor: nil, trailingAnchor: topContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 36.0, padding: .init(top: 10.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        
        topContentRowView.addSubview(bottomBorderView)
        bottomBorderView.anchor(withTopAnchor: searchInputView.bottomAnchor, leadingAnchor: topContentRowView.leadingAnchor, bottomAnchor: topContentRowView.bottomAnchor, trailingAnchor: topContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 1.0, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
    
    @objc func backButtonPressed() {
        delegate?.backButtonPressed()
    }
    
    @objc func searchInputValueDidChange(_ textField: UITextField) {
        if let searchValue = textField.text,
            !searchValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            delegate?.searchValueChanged(withValue: searchValue)
        } else {
            delegate?.searchValueCleared()
        }
    }
    
    func dismissKeyboard() {
        if searchInputView.isFirstResponder && searchInputView.canResignFirstResponder {
            searchInputView.resignFirstResponder()
        }
    }
    
    @objc func skipButtonPressed() {
        delegate?.skipButtonPressed()
    }
    
    @objc func nextButtonPressed() {
        delegate?.nextButtonPressed()
    }
}

// textfield delegate methods
extension VideoTagEventsNavBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
