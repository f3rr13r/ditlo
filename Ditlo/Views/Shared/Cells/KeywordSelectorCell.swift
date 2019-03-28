//
//  KeywordSelectorCell.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/26/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MarqueeLabel

class KeywordSelectorCell: BaseCell {
    
    // injector variables
    var keyword: String? {
        didSet {
            if let keyword = self.keyword {
                keywordLabel.text = keyword
            }
        }
    }
    
    // views
    let keywordContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = ditloOffBlack.cgColor
        return view
    }()
    var keywordContainerMaxWidthConstraint: NSLayoutConstraint!
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.isEnabled = true
        /*-- we'll handle this target on the parent - silly xcode bug --*/
        return button
    }()
    
    let deleteButtonIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "close icon").withRenderingMode(.alwaysTemplate)
        iv.tintColor = ditloOffBlack
        return iv
    }()
    
    let keywordLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.textColor = ditloOffBlack
        label.font = defaultParagraphFont
        label.trailingBuffer = 8.0
        label.fadeLength = 6.0
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        self.contentView.isUserInteractionEnabled = false
        
        /*-- keyword container view and max-width constraint --*/
        addSubview(keywordContainerView)
        keywordContainerView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: centerYAnchor)
        keywordContainerMaxWidthConstraint = NSLayoutConstraint(item: keywordContainerView, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -horizontalPadding)
        addConstraint(keywordContainerMaxWidthConstraint)
        
        /*-- delete button and icon --*/
        keywordContainerView.addSubview(deleteButton)
        deleteButton.anchor(withTopAnchor: keywordContainerView.topAnchor, leadingAnchor: nil, bottomAnchor: keywordContainerView.bottomAnchor, trailingAnchor: keywordContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil)
        deleteButton.addSubview(deleteButtonIcon)
        deleteButtonIcon.anchor(withTopAnchor: nil, leadingAnchor: deleteButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: deleteButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: deleteButton.centerYAnchor, widthAnchor: 9.0, heightAnchor: 9.0, padding: .init(top: 0.0, left: 12.0, bottom: 0.0, right: -12.0))
        
        /*-- keyword name label --*/
        keywordContainerView.addSubview(keywordLabel)
        keywordLabel.anchor(withTopAnchor: nil, leadingAnchor: keywordContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: deleteButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: keywordContainerView.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 12.0, bottom: 0.0, right: 0.0))
    }
    
    override func prepareForReuse() {
        keyword = nil
        keywordLabel.text = nil
    }
}
