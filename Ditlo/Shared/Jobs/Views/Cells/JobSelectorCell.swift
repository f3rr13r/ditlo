//
//  JobSelectorCell.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/19/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class JobSelectorCell: BaseCell {

    // injector variables
    var job: Job? {
        didSet {
            if let job = self.job {
                jobNameLabel.text = job.jobName
                jobSelectedStateImageView.image = job.isSelected ? selectedStarImage : defaultStarImage
                jobSelectedStateImageView.setNeedsDisplay()
            }
        }
    }
    
    // views
    var jobNameLabel: UILabel = {
        let label = UILabel()
        label.font = defaultParagraphFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    var jobSelectedStateImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // variables -- we need this above view because of it's use
    let defaultStarImage = UIImage(named: "star-icon-default")
    let selectedStarImage = UIImage(named: "star-icon-selected")
    
    override func setupViews() {
        super.setupViews()
        anchorChildViews()
    }
    
    func anchorChildViews() {
        addSubview(jobSelectedStateImageView)
        jobSelectedStateImageView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: centerYAnchor, widthAnchor: 20.0, heightAnchor: 20.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        
        addSubview(jobNameLabel)
        jobNameLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: jobSelectedStateImageView.leadingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
    }
    
    override func prepareForReuse() {
        jobNameLabel.text = nil
        jobSelectedStateImageView.image = nil
        self.job = nil
    }
}
