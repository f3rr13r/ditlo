//
//  CategoryCell.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/27/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class CategoryCell: BaseCell {
    
    // injector variables
    var needsSelectedUnderlineState: Bool = true
    
    var category: ChildCategory? {
        didSet {
            if let category = self.category {
                if !category.name.contains(find: "Toggle All") {
                    backgroundColor = category.isSelected ? category.backgroundColor : category.backgroundColor.withAlphaComponent(0.65)
                    categoryNameLabel.text = category.name
                    if category.isSelected && needsSelectedUnderlineState {
                        categoryNameLabel.underline()
                    }
                } else {
                    backgroundColor = ditloLightGrey
                    categoryNameLabel.text = category.name
                }
            }
        }
    }
    
    // views
    let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = defaultParagraphFont
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        self.layer.cornerRadius = 4.0
        anchorChildViews()
    }
    
    func anchorChildViews() {
        self.addSubview(categoryNameLabel)
        categoryNameLabel.fillSuperview()
    }
    
    override func prepareForReuse() {
        backgroundColor = nil
        categoryNameLabel.text = nil
        category = nil
    }
}
