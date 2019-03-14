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
    var cellContent: NavigationCellContent? {
        didSet {
            print("updating cell content")
            updateCellUIState()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            print("Cell selected")
            updateCellUIState()
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
        setupBaseCellStyling()
        anchorChildViews()
    }
    
    func setupBaseCellStyling() {
        layer.cornerRadius = 4.0
        backgroundColor = ditloLightGrey
    }
    
    func updateCellUIState() {
        guard let cellContent = self.cellContent else { return }
        titleLabel.text = cellContent.name
        titleLabel.textColor = isSelected ? .white : cellContent.colour
        layer.borderWidth = isSelected ? 0.0 : 1.0
        layer.borderColor = isSelected ? nil : cellContent.colour.cgColor
        backgroundColor = isSelected ? cellContent.colour : .white
    }
    
    func anchorChildViews() {
        addSubview(titleLabel)
        titleLabel.fillSuperview()
    }
    
    override func prepareForReuse() {
        cellContent = nil
        titleLabel.text = nil
        titleLabel.textColor = .clear
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.clear.cgColor
        backgroundColor = ditloLightGrey
    }
}
