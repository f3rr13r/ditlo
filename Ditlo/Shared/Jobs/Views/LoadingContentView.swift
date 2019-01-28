//
//  LoadingContentView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/20/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class LoadingContentView: BaseView {
    
    // injector variables
    var loadingContentMessage: String? = "" {
        didSet {
            if let loadingContentMessage = self.loadingContentMessage {
                loadingMessageLabel.text = loadingContentMessage
                loadingSpinner.startAnimating()
            }
        }
    }
    
    override var isHidden: Bool {
        didSet {
            isHidden ? loadingSpinner.stopAnimating() : loadingSpinner.startAnimating()
        }
    }

    // views
    let loadingSpinnerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = ditloVeryLightGrey
        view.layer.cornerRadius = 4.0
        view.layer.masksToBounds = true
        return view
    }()
    
    let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .gray
        return spinner
    }()
    
    let loadingMessageLabel: UILabel = {
        let label = UILabel()
        label.font = smallTitleFont
        label.textColor = ditloVeryLightGrey
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        anchorChildViews()
    }
    
    func anchorChildViews() {
        addSubview(loadingSpinnerContainerView)
        loadingSpinnerContainerView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 48.0, heightAnchor: 48.0)
        
        loadingSpinner.startAnimating()
        loadingSpinnerContainerView.addSubview(loadingSpinner)
        loadingSpinner.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: loadingSpinnerContainerView.centerXAnchor, centreYAnchor: loadingSpinnerContainerView.centerYAnchor)
        
        addSubview(loadingMessageLabel)
        loadingMessageLabel.anchor(withTopAnchor: loadingSpinnerContainerView.bottomAnchor, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: self.centerXAnchor, centreYAnchor: nil, widthAnchor: screenWidth * (horizontalPadding * 2), heightAnchor: nil, padding: .init(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
}
