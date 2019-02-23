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
    
    // injector variables
    
    var isDateInMonth: Bool? = true {
        didSet {
            if let isDateInMonth = self.isDateInMonth {
                self.dateLabel.textColor = isDateInMonth ? ditloOffBlack : ditloVeryLightGrey
                if !isDateInMonth {
                    roundedFocusView.backgroundColor = UIColor.clear
                }
            }
        }
    }

    var isDateLaterInMonth: Bool? = false {
        didSet {
            if let isDateLaterInMonth = self.isDateLaterInMonth,
                isDateLaterInMonth {
                    self.dateLabel.textColor = ditloLightGrey
                    roundedFocusView.backgroundColor = UIColor.clear
            }
        }
    }

    var isDateToday: Bool? = false {
        didSet {
            if let isDateToday = self.isDateToday {
                self.roundedFocusView.backgroundColor = isDateToday ? ditloVeryLightGrey : UIColor.clear
            }
        }
    }

    var isDateSelected: Bool? = false {
        didSet {
            if let isDateSelected = self.isDateSelected,
                let isDateToday = self.isDateToday,
                let isDateInMonth = self.isDateInMonth,
                let isDateLaterInMonth = self.isDateLaterInMonth {
                let defaultColor = isDateInMonth && isDateToday ? ditloVeryLightGrey : UIColor.clear
                self.roundedFocusView.backgroundColor = isDateSelected ? ditloRed : defaultColor
                if isDateInMonth && !isDateLaterInMonth {
                    self.dateLabel.textColor = isDateSelected ? UIColor.white : ditloOffBlack
                }
            }
        }
    }
    
    let roundedFocusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14.0
        return view
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = calendarCellLabelFont
        label.textColor = ditloOffBlack
        label.textAlignment = .center
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
        self.addSubview(roundedFocusView)
        roundedFocusView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: centerXAnchor, centreYAnchor: centerYAnchor, widthAnchor: 28.0, heightAnchor: 28.0)
        
        roundedFocusView.addSubview(dateLabel)
        dateLabel.fillSuperview()
    }
    
    override func prepareForReuse() {
        roundedFocusView.backgroundColor = UIColor.clear
        dateLabel.textColor = ditloOffBlack
        dateLabel.text = nil
        isDateToday = nil
        isDateSelected = nil
    }
}
