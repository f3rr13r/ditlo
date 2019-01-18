//
//  TitleLabel.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/17/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

struct TitleLabelConfiguration {
    var titleText: String
    var titleFont: UIFont
}

class TitleLabel: BaseLabel {

    // injector variables
    var titleConfig: TitleLabelConfiguration? {
        didSet {
            if let titleConfig = self.titleConfig {
                self.text = titleConfig.titleText
                self.font = titleConfig.titleFont
            }
        }
    }

    override func configureSelf() {
        super.configureSelf()
        self.textColor = ditloOffBlack
    }
}
