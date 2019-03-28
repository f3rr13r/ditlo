//
//  CustomSwitcherView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/28/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

protocol CustomSwiperDelegate {
    func customPickerValueDidChange(toIndex index: Int)
}

class CustomSwiperView: BaseView {
    
    // initializer
    convenience init(firstOption: String, secondOption: String, startingIndex: Int = 0, transitionSpeed: Double = 0.25) {
        self.init()
        
        /*-- configure the views --*/
        firstOptionLabel.text = firstOption
        secondOptionLabel.text = secondOption
        currentlySelectedOptionIndex = startingIndex
    }
    
    // injector variables
    var currentlySelectedOptionIndex: Int = 0
    var transitionSpeed: Double = 0.25
    var needsTitle: Bool = false
    var title: String = ""
    
    // views
    private let activeOptionView: UIView = {
        let view = UIView()
        view.backgroundColor = ditloGrey
        view.layer.cornerRadius = 12.0
        view.isUserInteractionEnabled = false
        return view
    }()
    private var activeOptionViewLeftAnchorConstraint: NSLayoutConstraint!
    private var activeOptionViewWidthConstraint: NSLayoutConstraint!
    
    private let firstOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.isUserInteractionEnabled = true
        label.textColor = .white
        label.font = smallParagraphFont
        label.textAlignment = .center
        return label
    }()
    private var firstOptionLabelWidthConstraint: NSLayoutConstraint!
    
    private let secondOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Member"
        label.isUserInteractionEnabled = true
        label.textColor = ditloGrey
        label.font = smallParagraphFont
        label.textAlignment = .center
        return label
    }()
    private var secondOptionLabelWidthConstraint: NSLayoutConstraint!
    
    private let filterByLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter posts by"
        label.textColor = ditloOffBlack
        label.textAlignment = .center
        label.font = smallProfileInfoJobFont
        return label
    }()
    
    // delegate
    var delegate: CustomSwiperDelegate?
    
    override func setupViews() {
        super.setupViews()
        configureSwiper()
        addCustomSwiperTapGestureRecognizers()
    }
    
    private func configureSwiper() {
        /*-- active option view (this is what moves) --*/
        addSubview(activeOptionView)
        activeOptionView.anchor(withTopAnchor: topAnchor, leadingAnchor: nil, bottomAnchor: bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: centerYAnchor, widthAnchor: nil, heightAnchor: 24.0)
        activeOptionViewLeftAnchorConstraint = NSLayoutConstraint(item: activeOptionView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
        addConstraint(activeOptionViewLeftAnchorConstraint)
        
        /*-- first option view --*/
        addSubview(firstOptionLabel)
        firstOptionLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: centerYAnchor, widthAnchor: nil, heightAnchor: 24.0)
        let firstOptionWidth = (firstOptionLabel.text?.widthOfString(usingFont: firstOptionLabel.font))! + 24.0
        firstOptionLabelWidthConstraint = NSLayoutConstraint(item: firstOptionLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: firstOptionWidth)
        addConstraint(firstOptionLabelWidthConstraint)
        
        /*-- second option view --*/
        addSubview(secondOptionLabel)
        secondOptionLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: firstOptionLabel.trailingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: centerYAnchor, widthAnchor: nil, heightAnchor: 24.0)
        let secondOptionWidth = (secondOptionLabel.text?.widthOfString(usingFont: secondOptionLabel.font))! + 24.0
        secondOptionLabelWidthConstraint = NSLayoutConstraint(item: secondOptionLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: secondOptionWidth)
        
        /*-- calculate the active option view width constraint --*/
        activeOptionViewWidthConstraint = NSLayoutConstraint(item: activeOptionView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: firstOptionWidth)
        addConstraints([secondOptionLabelWidthConstraint, activeOptionViewWidthConstraint])
    }
    
    private func addCustomSwiperTapGestureRecognizers() {
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
                delegate?.customPickerValueDidChange(toIndex: indexPosition)
            }
            UIView.animate(withDuration: transitionSpeed, delay: 0.0, options: .curveEaseOut, animations: {
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
}
