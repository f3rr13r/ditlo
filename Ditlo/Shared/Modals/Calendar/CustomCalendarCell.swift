//
//  CustomCalendarCell.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/29/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCalendarCell: JTAppleCell {

    let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override var intrinsicContentSize: CGSize {
        let cellWidth: CGFloat = ((screenWidth - (horizontalPadding * 2)) / 7)
        let cellHeight: CGFloat = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        invalidateIntrinsicContentSize()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(dateLabel)
        dateLabel.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: centerXAnchor, centreYAnchor: centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 6.0, left: 6.0, bottom: -6.0, right: -6.0))
    }
}
