//
//  DitloPlayerPopupVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/4/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class DitloPlayerPopupVC: UIViewController {

    // views
    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Ditlo player popup VC"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ditloOffWhite

        self.view.addSubview(testLabel)
        testLabel.fillSuperview()
    }
}
