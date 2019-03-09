//
//  OtherUserProfileNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

protocol OtherUserProfileNavBarDelegate {
    func backButtonPressed()
}

class OtherUserProfileNavBar: BaseView {
    
    let topRowView = UIView()
    
    let backButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let backButtonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "back-arrow-icon")
        return iv
    }()
    
    let bottomPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = ditloLightGrey
        return view
    }()
    
    // delegate
    var delegate: OtherUserProfileNavBarDelegate?
    
    override func setupViews() {
        super.setupViews()
        anchorSubviews()
    }
    
    func anchorSubviews() {
        addSubview(topRowView)
        topRowView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 58.0)
        topRowView.addSubview(backButton)
        backButton.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 58.0, heightAnchor: nil)
        backButton.addSubview(backButtonImageView)
        backButtonImageView.anchor(withTopAnchor: nil, leadingAnchor: topRowView.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: topRowView.centerYAnchor, widthAnchor: 26.0, heightAnchor: 26.0, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        topRowView.addSubview(bottomPaddingView)
        bottomPaddingView.anchor(withTopAnchor: nil, leadingAnchor: topRowView.leadingAnchor, bottomAnchor: topRowView.bottomAnchor, trailingAnchor: topRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 1.0)
    }
}

// selector methods
extension OtherUserProfileNavBar {
    @objc func backButtonPressed() {
        delegate?.backButtonPressed()
    }
}
