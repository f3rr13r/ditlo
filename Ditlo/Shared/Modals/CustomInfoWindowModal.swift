//
//  CustomInfoWindowModal.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

struct CustomInfoMessageConfig {
    var title: String
    var body: String
}

class CustomInfoWindowModal: BaseView {

    let infoWindowContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    var infoWindowTopAnchorContainer: NSLayoutConstraint?

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
    
    let infoWindowTitleLabel: UILabel = {
        let label = UILabel()
        label.font = smallTitleFont
        label.textColor = ditloOffBlack
        label.numberOfLines = 0
        return label
    }()
    
    let infoWindowBodyLabel: UILabel = {
        let label = UILabel()
        label.font = defaultParagraphFont
        label.textColor = ditloGrey
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = ditloOffBlack.withAlphaComponent(0.75)
        alpha = 0.0
        setupDismissInfoWindowTapGesture()
        anchorChildViews()
    }
    
    func setupDismissInfoWindowTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideInfoWindowModal))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    func anchorChildViews() {
        addSubview(infoWindowContainer)
        infoWindowContainer.anchor(withTopAnchor: nil, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: centerXAnchor, centreYAnchor: nil)
        infoWindowTopAnchorContainer = NSLayoutConstraint(item: infoWindowContainer, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: -1000.0)
        addConstraint(infoWindowTopAnchorContainer!)
        
        infoWindowContainer.addSubview(miniDitloLogoImageView)
        miniDitloLogoImageView.anchor(withTopAnchor: infoWindowContainer.safeAreaLayoutGuide.topAnchor, leadingAnchor: infoWindowContainer.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 14.0, heightAnchor: 14.0, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        infoWindowContainer.addSubview(ditloLogoNameLabel)
        ditloLogoNameLabel.anchor(withTopAnchor: nil, leadingAnchor: miniDitloLogoImageView.trailingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: miniDitloLogoImageView.centerYAnchor, widthAnchor: 60.0, heightAnchor: nil, padding: .init(top: 0.0, left: 4.0, bottom: 0.0, right: 0.0))
        
        infoWindowContainer.addSubview(infoWindowTitleLabel)
        infoWindowTitleLabel.anchor(withTopAnchor: miniDitloLogoImageView.bottomAnchor, leadingAnchor: infoWindowContainer.leadingAnchor, bottomAnchor: nil, trailingAnchor: infoWindowContainer.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        infoWindowContainer.addSubview(infoWindowBodyLabel)
        infoWindowBodyLabel.anchor(withTopAnchor: infoWindowTitleLabel.bottomAnchor, leadingAnchor: infoWindowContainer.leadingAnchor, bottomAnchor: infoWindowContainer.bottomAnchor, trailingAnchor: infoWindowContainer.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 14.0, left: horizontalPadding, bottom: -20.0, right: -horizontalPadding))
    }
    
    func showInfoWindowModal(withInfoWindowConfig infoWindowConfig: CustomInfoMessageConfig, andAnimation needsAnimation: Bool = false) {
        let duration: Double = needsAnimation ? 0.2 : 0.0
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }) { (isAnimationComplete) in
            if isAnimationComplete {
                self.infoWindowTitleLabel.text = infoWindowConfig.title
                self.infoWindowBodyLabel.text = infoWindowConfig.body
                UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
                    self.infoWindowTopAnchorContainer?.constant = 0
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @objc func hideInfoWindowModal() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.infoWindowTopAnchorContainer?.constant = -self.frame.height
            self.layoutIfNeeded()
        }) { (isAnimationComplete) in
            if isAnimationComplete {
                self.infoWindowTitleLabel.text = nil
                self.infoWindowBodyLabel.text = nil
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 0.0
                })
            }
        }
    }
}
