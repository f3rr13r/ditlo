//
//  MainDitloNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/29/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

protocol MainDitloNavBarDelegate {
    func goHomeButtonPressed()
    func openCalendarButtonPressed()
}

extension MainDitloNavBarDelegate {
    func goHomeButtonPressed() {}
}

class MainDitloNavBar: BaseView {
    
    // views
    let ditloImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        let ditloImage = #imageLiteral(resourceName: "ditlo-logo")
        iv.image = ditloImage
        return iv
    }()
    
    let ditloNameLabel: UILabel = {
        let label = UILabel()
        label.text = "DITLO"
        label.font = navBarLogoFont
        label.textColor = ditloOffBlack
        return label
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
    
    var delegate: MainDitloNavBarDelegate?
    
    override func setupViews() {
        super.setupViews()
        anchorChildViews()
    }
    
    func anchorChildViews() {
        self.addSubview(ditloImageView)
        ditloImageView.anchor(withTopAnchor: safeAreaLayoutGuide.topAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 20.0, heightAnchor: 20.0, padding: .init(top: 10.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        self.addSubview(ditloNameLabel)
        ditloNameLabel.anchor(withTopAnchor: nil, leadingAnchor: ditloImageView.trailingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: ditloImageView.centerYAnchor, widthAnchor: 84.0, heightAnchor: 20.0, padding: .init(top: 0.0, left: 4.0, bottom: 0.0, right: 0.0))
        
        self.addSubview(calendarButton)
        calendarButton.anchor(withTopAnchor: nil, leadingAnchor: ditloNameLabel.trailingAnchor, bottomAnchor: nil, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: ditloNameLabel.centerYAnchor, widthAnchor: nil, heightAnchor: 20.0, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        self.calendarButton.addSubview(calendarIconImageView)
        calendarIconImageView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: calendarButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: calendarButton.centerYAnchor, widthAnchor: 14.0, heightAnchor: 14.0)
        
        self.calendarButton.addSubview(calendarDateLabel)
        calendarDateLabel.anchor(withTopAnchor: nil, leadingAnchor: calendarButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: calendarIconImageView.leadingAnchor, centreXAnchor: nil, centreYAnchor: calendarButton.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -8.0))
    }
}

// button selector methods
extension MainDitloNavBar {
    @objc func calendarButtonPressed() {
        delegate?.openCalendarButtonPressed()
    }
}
