//
//  RoundProfilePictureView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/29/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

protocol RoundProfilePictureViewDelegate {
    func roundProfilePictureButtonPressed()
}

class RoundProfilePictureView: BaseView {

    // injector variables
    var profilePicture: UIImage? {
        didSet {
            if let profilePicture = self.profilePicture {
                profileIconImageView.image = profilePicture
            }
        }
    }
    
    // views
    let profileIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = ditloLightGrey
        iv.layer.cornerRadius = 18.0
        iv.layer.masksToBounds = true
        return iv
    }()
    
    // delegate
    var delegate: RoundProfilePictureViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40.0, height: 40.0)
    }
    
    override func setupViews() {
        super.setupViews()
        invalidateIntrinsicContentSize()
        self.layer.cornerRadius = 20.0
        self.layer.borderColor = ditloLightGrey.cgColor
        self.layer.borderWidth = 1.0
        
        setupTapGesture()
        anchorChildSubviews()
    }
    
    func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(userDidTap))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }

    func anchorChildSubviews() {
        addSubview(profileIconImageView)
        profileIconImageView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: centerXAnchor, centreYAnchor: centerYAnchor, widthAnchor: 36.0, heightAnchor: 36.0)
    }
}

// selector methods
extension RoundProfilePictureView {
    @objc func userDidTap() {
        delegate?.roundProfilePictureButtonPressed()
    }
}
