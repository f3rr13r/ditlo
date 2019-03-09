//
//  TestVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class TestVC: UIViewController {

    // injector variables
    var incomingValue: String = "" {
        didSet {
            testLabel.text = incomingValue
        }
    }
    
    let testLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = defaultParagraphFont
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.isNavigationBarHidden = false
        self.view.backgroundColor = .white
        
        self.view.addSubview(testLabel)
        testLabel.fillSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let testNavigationController = self.navigationController {
            testNavigationController.navigationBar.prefersLargeTitles = false
            testNavigationController.hidesBarsOnSwipe = false
        }
        
        SharedModalsService.instance.hideCustomOverlayModal()
    }
}
