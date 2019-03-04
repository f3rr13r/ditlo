//
//  NavigationCell.swift
//  Ditlo
//
//  Created by Harry Ferrier on 2/26/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class NavigationCell: BaseCell {
    
    // custom injector variables
    var title: String? = "" {
        didSet {
            if let title = self.title {
                titleLabel.text = title
                layoutIfNeeded()
            }
        }
    }
    
    var cellColor: UIColor?
    
    override var isSelected: Bool {
        didSet {
            setupCellState(toSelectedState: isSelected)
        }
    }
    
    // views
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = customInputFont
        label.textColor = ditloGrey
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        setupCellState()
        anchorChildViews()
    }
    
    func setupCellState(toSelectedState isSelected: Bool = false) {
        let cellColor = self.cellColor ?? ditloGrey
        layer.cornerRadius = 4.0
        layer.borderWidth = isSelected ? 0.0 : 1.0
        layer.borderColor = isSelected ? nil : cellColor.cgColor
        backgroundColor = isSelected ? cellColor : UIColor.clear
        titleLabel.textColor = isSelected ? UIColor.white : cellColor
    }
    
    func anchorChildViews() {
        addSubview(titleLabel)
        titleLabel.fillSuperview()
    }
    
    override func prepareForReuse() {
        title = nil
        cellColor = nil
        setupCellState()
        self.layoutIfNeeded()
    }
}
