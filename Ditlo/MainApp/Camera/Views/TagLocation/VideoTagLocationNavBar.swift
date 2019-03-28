//
//  VideoTagLocationNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/28/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol VideoTagLocationNavBarDelegate {
    func backButtonPressed()
    func postDitloButtonPressed()
}

class VideoTagLocationNavBar: BaseView {

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
    
    let postDitloButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4.0
        button.backgroundColor = ditloRed
        button.setTitle("Post Ditlo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = smallParagraphFont
        button.addTarget(self, action: #selector(postDitloButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let tagLocationTitleLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.numberOfLines = 1
        label.text = "Tag Location"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        label.trailingBuffer = 8.0
        label.fadeLength = 6.0
        return label
    }()
    
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = ditloVeryLightGrey
        return view
    }()
    
    // delegate
    var delegate: VideoTagLocationNavBarDelegate?
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        handleChildDelegates()
        anchorSubviews()
    }
    
    func handleChildDelegates() {
        // do we need this?
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
        
        topContentRowView.addSubview(postDitloButton)
        postDitloButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: topContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: backButton.centerYAnchor, widthAnchor: 80.0, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        
        topContentRowView.addSubview(logoLabel)
        logoLabel.anchor(withTopAnchor: nil, leadingAnchor: logoImageView.trailingAnchor, bottomAnchor: nil, trailingAnchor: postDitloButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: logoImageView.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 2.0, bottom: 0.0, right: -12.0))
        
        topContentRowView.addSubview(tagLocationTitleLabel)
        tagLocationTitleLabel.anchor(withTopAnchor: logoImageView.bottomAnchor, leadingAnchor: backButton.trailingAnchor, bottomAnchor: nil, trailingAnchor: postDitloButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 6.0, left: 0.0, bottom: 0.0, right: -12.0))
        
        topContentRowView.addSubview(bottomBorderView)
        bottomBorderView.anchor(withTopAnchor: tagLocationTitleLabel.bottomAnchor, leadingAnchor: topContentRowView.leadingAnchor, bottomAnchor: topContentRowView.bottomAnchor, trailingAnchor: topContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 1.0, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0))
    }

    
    @objc func backButtonPressed() {
        delegate?.backButtonPressed()
    }
    
    @objc func postDitloButtonPressed() {
        delegate?.postDitloButtonPressed()
    }
}
