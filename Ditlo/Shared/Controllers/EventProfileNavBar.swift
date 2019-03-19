//
//  EventProfileNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/19/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol EventProfileNavBarDelegate {
    func backButtonPressed()
    func rightButtonPressed()
    func customPickerDidChange(toItemIndexValue itemIndex: Int)
}

class EventProfileNavBar: BaseView {

    // injector variables
    var currentlySelectedSectionIndex: Int = 0 {
        didSet {
            updateCustomSwitch(toIndexPosition: currentlySelectedSectionIndex, canPassDelegate: false)
        }
    }
    
    // views
    let topRowView: UIView = {
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
    
    let roundedBorderView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = ditloLightGrey.cgColor
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "event-profile-icon")
        iv.layer.cornerRadius = 18.0
        iv.backgroundColor = ditloLightGrey
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let leftButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let leftButtonIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "three-dot-icon")
        return iv
    }()

    let interactionButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = ditloLightGrey.cgColor
        button.layer.cornerRadius = 4.0
        button.setTitle("Join Event", for: .normal)
        button.setTitleColor(ditloOffBlack, for: .normal)
        button.titleLabel?.font = smallParagraphFont
        button.titleLabel?.textAlignment = .center
        return button
    }()
    var interactionButtonWidthConstraint: NSLayoutConstraint!
    
    let centreInfoContainerView = UIView()
    
    let eventNameLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.numberOfLines = 1
        label.text = "Super Bowl LII - Minneapolis"
        label.font = smallTitleFont
        label.textColor = ditloOffBlack
        label.trailingBuffer = 8.0
        label.fadeLength = 6.0
        return label
    }()
    
    let eventDetailButton: UIButton = {
        let button = UIButton()
        // do selector
        return button
    }()
    
    let eventDetailLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.numberOfLines = 1
        label.text = "Public | 17.5k members"
        label.font = largeProfileInfoJobFont
        label.textColor = ditloOffBlack
        label.textAlignment = .left
        label.trailingBuffer = 8.0
        label.fadeLength = 6.0
        return label
    }()
    
    let bottomRowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let membersButton: UIButton = {
        let button = UIButton()
        return button
    }()
    let membersCountLabel: UILabel = {
        let label = UILabel()
        label.text = "17.5k"
        label.textColor = ditloOffBlack
        label.font = smallTitleFont
        label.textAlignment = .center
        return label
    }()
    
    let membersNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Members"
        label.textColor = ditloOffBlack
        label.font = largeProfileInfoJobFont
        label.textAlignment = .center
        return label
    }()
    
    let notificationsButton: UIButton = {
        let button = UIButton()
        return button
    }()
    let notificationsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "7"
        label.textColor = ditloOffBlack
        label.font = smallTitleFont
        label.textAlignment = .center
        return label
    }()
    
    let notificationsNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Notifications"
        label.textColor = ditloOffBlack
        label.font = largeProfileInfoJobFont
        label.textAlignment = .center
        return label
    }()
    
    let customSwipeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = ditloVeryLightGrey
        view.layer.cornerRadius = 12.0
        return view
    }()
    
    let activeOptionView: UIView = {
        let view = UIView()
        view.backgroundColor = ditloGrey
        view.layer.cornerRadius = 12.0
        view.isUserInteractionEnabled = false
        return view
    }()
    var activeOptionViewLeftAnchorConstraint: NSLayoutConstraint!
    var activeOptionViewWidthConstraint: NSLayoutConstraint!
    
    let firstOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.isUserInteractionEnabled = true
        label.textColor = .white
        label.font = smallParagraphFont
        label.textAlignment = .center
        return label
    }()
    var firstOptionLabelWidthConstraint: NSLayoutConstraint!
    
    let secondOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Member"
        label.isUserInteractionEnabled = true
        label.textColor = ditloGrey
        label.font = smallParagraphFont
        label.textAlignment = .center
        return label
    }()
    var secondOptionLabelWidthConstraint: NSLayoutConstraint!
    
    let filterByLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter posts by"
        label.textColor = ditloOffBlack
        label.textAlignment = .center
        label.font = smallProfileInfoJobFont
        return label
    }()
    
    // delegate
    var delegate: EventProfileNavBarDelegate?
    
    // variables
    var currentlySelectedOptionIndex: Int = 0
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        setupCustomSwitchGestures()
        anchorSubviews()
    }
    
    func setupCustomSwitchGestures() {
        let firstOptionTap = UITapGestureRecognizer(target: self, action: #selector(firstOptionTapped))
        firstOptionTap.numberOfTapsRequired = 1
        firstOptionLabel.addGestureRecognizer(firstOptionTap)
        
        let secondOptionTap = UITapGestureRecognizer(target: self, action: #selector(secondOptionTapped))
        secondOptionTap.numberOfTapsRequired = 1
        secondOptionLabel.addGestureRecognizer(secondOptionTap)
    }
    
    @objc func firstOptionTapped() {
        updateCustomSwitch(toIndexPosition: 0)
    }
    
    @objc func secondOptionTapped() {
        updateCustomSwitch(toIndexPosition: 1)
    }
    
    func updateCustomSwitch(toIndexPosition indexPosition: Int, canPassDelegate: Bool = true) {
        if indexPosition != currentlySelectedOptionIndex {
            self.isUserInteractionEnabled = false
            if canPassDelegate {
                delegate?.customPickerDidChange(toItemIndexValue: indexPosition)
            }
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                self.activeOptionViewWidthConstraint.constant = indexPosition == 0 ? self.firstOptionLabel.frame.width : self.secondOptionLabel.frame.width
                self.activeOptionViewLeftAnchorConstraint.constant = indexPosition == 0 ? 0.0 : self.firstOptionLabel.frame.width
                self.firstOptionLabel.textColor = indexPosition == 0 ? .white : ditloGrey
                self.secondOptionLabel.textColor = indexPosition == 0 ? ditloGrey : .white
                self.layoutIfNeeded()
            }) { (animationDidFinish) in
                if animationDidFinish {
                    self.currentlySelectedOptionIndex = indexPosition
                    self.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func anchorSubviews() {
        // top row
        addSubview(topRowView)
        topRowView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 40.0)
        
        topRowView.addSubview(backButton)
        backButton.anchor(withTopAnchor: topRowView.topAnchor, leadingAnchor: topRowView.leadingAnchor, bottomAnchor: topRowView.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 44.0, heightAnchor: nil)
        backButton.addSubview(backButtonImageView)
        backButtonImageView.anchor(withTopAnchor: nil, leadingAnchor: topRowView.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor, widthAnchor: 26.0, heightAnchor: 26.0, padding: .init(top: 0.0, left: 14.0, bottom: 0.0, right: 0.0))
        
        topRowView.addSubview(roundedBorderView)
        roundedBorderView.anchor(withTopAnchor: nil, leadingAnchor: backButton.trailingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor, widthAnchor: 40.0, heightAnchor: 40.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
        roundedBorderView.addSubview(profileImageView)
        profileImageView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: roundedBorderView.centerXAnchor, centreYAnchor: roundedBorderView.centerYAnchor, widthAnchor: 36.0, heightAnchor: 36.0)
        
        topRowView.addSubview(leftButton)
        leftButton.anchor(withTopAnchor: topRowView.topAnchor, leadingAnchor: nil, bottomAnchor: topRowView.bottomAnchor, trailingAnchor: topRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 58.0, heightAnchor: nil)
        leftButton.addSubview(leftButtonIcon)
        leftButtonIcon.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: leftButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: leftButton.centerYAnchor, widthAnchor: 17.0, heightAnchor: 4.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        
        topRowView.addSubview(interactionButton)
        interactionButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: leftButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor, widthAnchor: nil, heightAnchor: 26.0)
        let interactionButtonWidth = (interactionButton.titleLabel?.text?.widthOfString(usingFont: smallParagraphFont))! + 24.0
        interactionButtonWidthConstraint = NSLayoutConstraint(item: interactionButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: interactionButtonWidth)
        addConstraint(interactionButtonWidthConstraint)
        
        topRowView.addSubview(centreInfoContainerView)
        centreInfoContainerView.anchor(withTopAnchor: nil, leadingAnchor: roundedBorderView.trailingAnchor, bottomAnchor: nil, trailingAnchor: interactionButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 12.0, bottom: 0.0, right: -12.0))
        
        centreInfoContainerView.addSubview(eventNameLabel)
        eventNameLabel.anchor(withTopAnchor: centreInfoContainerView.topAnchor, leadingAnchor: centreInfoContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: centreInfoContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 14.0)
        
        centreInfoContainerView.addSubview(eventDetailButton)
        eventDetailButton.anchor(withTopAnchor: eventNameLabel.bottomAnchor, leadingAnchor: centreInfoContainerView.leadingAnchor, bottomAnchor: centreInfoContainerView.bottomAnchor, trailingAnchor: centreInfoContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 11.0, padding: .init(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        eventDetailButton.addSubview(eventDetailLabel)
        eventDetailLabel.anchor(withTopAnchor: eventDetailButton.topAnchor, leadingAnchor: eventDetailButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: eventDetailButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 11.0)
        
        // bottom row
        addSubview(bottomRowView)
        bottomRowView.anchor(withTopAnchor: topRowView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil)
        
        // members
        bottomRowView.addSubview(membersButton)
        membersButton.anchor(withTopAnchor: bottomRowView.topAnchor, leadingAnchor: bottomRowView.leadingAnchor, bottomAnchor: bottomRowView.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 46.0, bottom: 0.0, right: 0.0))
        membersButton.addSubview(membersCountLabel)
        membersCountLabel.anchor(withTopAnchor: membersButton.topAnchor, leadingAnchor: membersButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: membersButton.trailingAnchor, centreXAnchor: membersButton.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0))
        membersButton.addSubview(membersNameLabel)
        membersNameLabel.anchor(withTopAnchor: membersCountLabel.bottomAnchor, leadingAnchor: membersButton.leadingAnchor, bottomAnchor: membersButton.bottomAnchor, trailingAnchor: membersButton.trailingAnchor, centreXAnchor: membersButton.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: -10.0, right: 0.0))
        
        // notifications
        bottomRowView.addSubview(notificationsButton)
        notificationsButton.anchor(withTopAnchor: bottomRowView.topAnchor, leadingAnchor: membersButton.trailingAnchor, bottomAnchor: bottomRowView.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0))
        notificationsButton.addSubview(notificationsCountLabel)
        notificationsCountLabel.anchor(withTopAnchor: notificationsButton.topAnchor, leadingAnchor: notificationsButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: notificationsButton.trailingAnchor, centreXAnchor: notificationsButton.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0))
        notificationsButton.addSubview(notificationsNameLabel)
        notificationsNameLabel.anchor(withTopAnchor: notificationsCountLabel.bottomAnchor, leadingAnchor: notificationsButton.leadingAnchor, bottomAnchor: notificationsButton.bottomAnchor, trailingAnchor: notificationsButton.trailingAnchor, centreXAnchor: notificationsButton.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: -10.0, right: 0.0))
        
        // option picker
        bottomRowView.addSubview(customSwipeContainer)
        customSwipeContainer.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: bottomRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: bottomRowView.centerYAnchor, widthAnchor: nil, heightAnchor: 24.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        customSwipeContainer.addSubview(activeOptionView)
        activeOptionView.anchor(withTopAnchor: customSwipeContainer.topAnchor, leadingAnchor: nil, bottomAnchor: customSwipeContainer.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: customSwipeContainer.centerYAnchor, widthAnchor: nil, heightAnchor: 24.0)
        activeOptionViewLeftAnchorConstraint = NSLayoutConstraint(item: activeOptionView, attribute: .left, relatedBy: .equal, toItem: customSwipeContainer, attribute: .left, multiplier: 1.0, constant: 0.0)
        addConstraint(activeOptionViewLeftAnchorConstraint)
        customSwipeContainer.addSubview(firstOptionLabel)
        firstOptionLabel.anchor(withTopAnchor: customSwipeContainer.topAnchor, leadingAnchor: customSwipeContainer.leadingAnchor, bottomAnchor: customSwipeContainer.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: customSwipeContainer.centerYAnchor, widthAnchor: nil, heightAnchor: 24.0)
        let firstOptionWidth = (firstOptionLabel.text?.widthOfString(usingFont: firstOptionLabel.font))! + 24.0
        firstOptionLabelWidthConstraint = NSLayoutConstraint(item: firstOptionLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: firstOptionWidth)
        addConstraint(firstOptionLabelWidthConstraint)
        customSwipeContainer.addSubview(secondOptionLabel)
        secondOptionLabel.anchor(withTopAnchor: customSwipeContainer.topAnchor, leadingAnchor: firstOptionLabel.trailingAnchor, bottomAnchor: customSwipeContainer.bottomAnchor, trailingAnchor: customSwipeContainer.trailingAnchor, centreXAnchor: nil, centreYAnchor: customSwipeContainer.centerYAnchor, widthAnchor: nil, heightAnchor: 24.0)
        let secondOptionWidth = (secondOptionLabel.text?.widthOfString(usingFont: secondOptionLabel.font))! + 24.0
        secondOptionLabelWidthConstraint = NSLayoutConstraint(item: secondOptionLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: secondOptionWidth)
        activeOptionViewWidthConstraint = NSLayoutConstraint(item: activeOptionView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: firstOptionWidth)
        addConstraints([secondOptionLabelWidthConstraint, activeOptionViewWidthConstraint])
        
        bottomRowView.addSubview(filterByLabel)
        filterByLabel.anchor(withTopAnchor: nil, leadingAnchor: customSwipeContainer.leadingAnchor, bottomAnchor: customSwipeContainer.topAnchor, trailingAnchor: customSwipeContainer.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: -2.0, right: 0.0))
        
    }
    
    @objc func backButtonPressed() {
        delegate?.backButtonPressed()
    }
}
