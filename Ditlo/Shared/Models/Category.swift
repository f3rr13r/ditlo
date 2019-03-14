//
//  CategoryModels.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/27/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

struct Category {
    var id: Int
    var name: String
    var isSelected: Bool
    var allCategoriesSelected: Bool
    var backgroundColor: UIColor
    var childCategories: [ChildCategory]
}

struct ChildCategory {
    var id: Int
    var name: String
    var backgroundColor: UIColor
    var isSelected: Bool
}
