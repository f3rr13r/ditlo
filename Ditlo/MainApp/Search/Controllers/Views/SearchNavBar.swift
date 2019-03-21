//
//  SearchNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/19/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol SearchNavBarDelegate {
    func searchInputWasTapped()
    func searchButtonPressed(withValue searchValue: String)
}

class SearchNavBar: BaseView {

    // views
    let logoContainerRowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
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
    
    let calendarButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(calendarButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let calendarIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        let calendarImage = #imageLiteral(resourceName: "calendar-icon")
        iv.image = calendarImage
        return iv
    }()
    
    let calendarDateLabel: UILabel = {
        let label = UILabel()
        label.text = "29 DEC 2018"
        label.font = defaultParagraphFont
        label.textColor = ditloOffBlack
        label.textAlignment = .right
        return label
    }()

    let searchTitleLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.numberOfLines = 1
        label.text = "Search"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        label.trailingBuffer = 8.0
        label.fadeLength = 6.0
        return label
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let searchButtonIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "search-icon")
        return iv
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
        input.returnKeyType = .search
        input.keyboardAppearance = .dark
        input.attributedPlaceholder = NSAttributedString(
            string: "What are you looking for?", attributes: [NSAttributedString.Key.foregroundColor: ditloGrey])
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 12.0, height: 36))
        input.leftView = paddingView
        input.leftViewMode = .always
        return input
    }()
    
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = ditloVeryLightGrey
        return view
    }()
    
    // delegate
    var delegate: SearchNavBarDelegate?
    
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
        // logo container row
        addSubview(logoContainerRowView)
        logoContainerRowView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 10.0)
        logoContainerRowView.addSubview(logoImageView)
        logoImageView.anchor(withTopAnchor: logoContainerRowView.topAnchor, leadingAnchor: logoContainerRowView.leadingAnchor, bottomAnchor: logoContainerRowView.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 10.0, heightAnchor: 10.0, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        logoContainerRowView.addSubview(logoLabel)
        logoLabel.anchor(withTopAnchor: logoContainerRowView.topAnchor, leadingAnchor: logoImageView.trailingAnchor, bottomAnchor: logoContainerRowView.bottomAnchor, trailingAnchor: logoContainerRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 2.0, bottom: 0.0, right: 0.0))
        
        // top content
        addSubview(topContentRowView)
        topContentRowView.anchor(withTopAnchor: logoContainerRowView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 32.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
        topContentRowView.addSubview(calendarButton)
        calendarButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: topContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: topContentRowView.centerYAnchor, widthAnchor: nil, heightAnchor: 20.0)
        calendarButton.addSubview(calendarIconImageView)
        calendarIconImageView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: calendarButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: calendarButton.centerYAnchor, widthAnchor: 14.0, heightAnchor: 14.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        calendarButton.addSubview(calendarDateLabel)
        calendarDateLabel.anchor(withTopAnchor: nil, leadingAnchor: calendarButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: calendarIconImageView.leadingAnchor, centreXAnchor: nil, centreYAnchor: calendarButton.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -8.0))
        topContentRowView.addSubview(searchTitleLabel)
        searchTitleLabel.anchor(withTopAnchor: topContentRowView.topAnchor, leadingAnchor: topContentRowView.leadingAnchor, bottomAnchor: topContentRowView.bottomAnchor, trailingAnchor: calendarButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -12.0))
        
        // search
        addSubview(searchButton)
        searchButton.anchor(withTopAnchor: topContentRowView.bottomAnchor, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 56.0, heightAnchor: 36.0, padding: .init(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0))
        searchButton.addSubview(searchButtonIcon)
        searchButtonIcon.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: searchButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: searchButton.centerYAnchor, widthAnchor: 24.0, heightAnchor: 24.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        addSubview(searchInputView)
        searchInputView.anchor(withTopAnchor: topContentRowView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: searchButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 36.0, padding: .init(top: 10.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        addSubview(bottomBorderView)
        bottomBorderView.anchor(withTopAnchor: searchInputView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 1.0, padding: .init(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
    
    @objc func calendarButtonPressed() {
        SharedModalsService.instance.showCalendar()
    }
    
    @objc func searchButtonPressed() {
        if searchInputView.text != nil && !(searchInputView.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            delegate?.searchButtonPressed(withValue: searchInputView.text!)
            dismissKeyboard()
        }
    }
    
    func dismissKeyboard() {
        if searchInputView.isFirstResponder && searchInputView.canResignFirstResponder {
            searchInputView.resignFirstResponder()
        }
    }
}

// text field delegate methods
extension SearchNavBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchInputWasTapped()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonPressed()
        return true
    }
}
