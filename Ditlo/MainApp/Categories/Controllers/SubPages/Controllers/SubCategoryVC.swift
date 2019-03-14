//
//  SubCategoryVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/14/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class SubCategoryVC: UIViewController {

    // injector variables
    var category: Category? {
        didSet {
            if let category = self.category {
                self.view.backgroundColor = category.backgroundColor
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
