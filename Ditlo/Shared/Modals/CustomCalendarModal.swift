//
//  CustomCalendarModal.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/29/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class CustomCalendarModal: BaseView {

    let calendarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    var calendarContainerViewTopAnchorConstraint: NSLayoutConstraint?
    
    let miniDitloLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        let logoImage = #imageLiteral(resourceName: "ditlo-logo")
        iv.image = logoImage
        return iv
    }()

    let ditloLogoNameLabel: UILabel = {
        let label = UILabel()
        label.text = "DITLO"
        label.font = infoWindowModalLogoFont
        label.textColor = ditloOffBlack
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = ditloOffBlack.withAlphaComponent(0.75)
        alpha = 0.0
        setupDismissCalendarContainerViewTapGesture()
        anchorChildViews()
    }
    
    func setupDismissCalendarContainerViewTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideCalendar))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    func anchorChildViews() {
        addSubview(calendarContainerView)
        calendarContainerView.anchor(withTopAnchor: nil, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 322.0)
        calendarContainerViewTopAnchorConstraint = NSLayoutConstraint(item: calendarContainerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: -1000.0)
        addConstraint(calendarContainerViewTopAnchorConstraint!)
        
        calendarContainerView.addSubview(miniDitloLogoImageView)
        miniDitloLogoImageView.anchor(withTopAnchor: calendarContainerView.safeAreaLayoutGuide.topAnchor, leadingAnchor: calendarContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 14.0, heightAnchor: 14.0, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        calendarContainerView.addSubview(ditloLogoNameLabel)
        ditloLogoNameLabel.anchor(withTopAnchor: nil, leadingAnchor: miniDitloLogoImageView.trailingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: miniDitloLogoImageView.centerYAnchor, widthAnchor: 60.0, heightAnchor: nil, padding: .init(top: 0.0, left: 4.0, bottom: 0.0, right: 0.0))
    }
    
    func showCalendar() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1.0
        }) { (isAnimationComplete) in
            if isAnimationComplete {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.calendarContainerViewTopAnchorConstraint?.constant = 0
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @objc func hideCalendar() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.calendarContainerViewTopAnchorConstraint?.constant = -self.frame.height
            self.layoutIfNeeded()
        }) { (isAnimationComplete) in
            if isAnimationComplete {
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 0.0
                }, completion: { (isAnimationComplete) in
                    if isAnimationComplete {
                        // pass date back here
                    }
                })
            }
        }
    }
}
