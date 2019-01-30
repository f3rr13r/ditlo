//
//  CustomCalendarModal.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/29/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCalendarModal: BaseView {

    let calendarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    var calendarContainerViewTopAnchorConstraint: NSLayoutConstraint?
    
    let miniDitloLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        let logoImage = #imageLiteral(resourceName: "ditlo-logo")
        iv.image = logoImage
        return iv
    }()

    let ditloLogoNameLabel: UILabel = {
        let label = UILabel()
        label.text = "DITLO"
        label.font = infoWindowModalLogoFont
        label.textColor = ditloOffBlack
        label.numberOfLines = 0
        return label
    }()
    
    let calendar: JTAppleCalendarView = {
        let c = JTAppleCalendarView(frame: .zero)
        c.backgroundColor = UIColor.clear
        c.scrollDirection = .horizontal
        c.allowsDateCellStretching = false
        //c.cellSize = ((screenWidth - (horizontalPadding * 2)) / 7)
        c.isPagingEnabled = true
        c.sectionInset = UIEdgeInsets(top: 0.0, left: horizontalPadding, bottom: 0.0, right: horizontalPadding)
        c.register(CustomCalendarCell.self, forCellWithReuseIdentifier: "CalendarCellId")
        return c
    }()
    
    // variables
    let dateFormatter = DateFormatter()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = ditloOffBlack.withAlphaComponent(0.75)
        alpha = 0.0
        setupChildDelegates()
        setupDismissCalendarContainerViewTapGesture()
        anchorChildViews()
    }
    
    func setupChildDelegates() {
        calendar.calendarDelegate = self
        calendar.calendarDataSource = self
    }
    
    func setupDismissCalendarContainerViewTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideCalendar))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    func anchorChildViews() {
        addSubview(calendarContainerView)
        calendarContainerView.anchor(withTopAnchor: nil, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 322.0)
        calendarContainerViewTopAnchorConstraint = NSLayoutConstraint(item: calendarContainerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: -1000.0)
        addConstraint(calendarContainerViewTopAnchorConstraint!)
        
        calendarContainerView.addSubview(miniDitloLogoImageView)
        miniDitloLogoImageView.anchor(withTopAnchor: calendarContainerView.safeAreaLayoutGuide.topAnchor, leadingAnchor: calendarContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 14.0, heightAnchor: 14.0, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        calendarContainerView.addSubview(ditloLogoNameLabel)
        ditloLogoNameLabel.anchor(withTopAnchor: nil, leadingAnchor: miniDitloLogoImageView.trailingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: miniDitloLogoImageView.centerYAnchor, widthAnchor: 60.0, heightAnchor: nil, padding: .init(top: 0.0, left: 4.0, bottom: 0.0, right: 0.0))
        
        // calendar
        calendarContainerView.addSubview(calendar)
        calendar.anchor(withTopAnchor: miniDitloLogoImageView.bottomAnchor, leadingAnchor: calendarContainerView.leadingAnchor, bottomAnchor: calendarContainerView.bottomAnchor, trailingAnchor: calendarContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: 0.0, bottom: -20.0, right: 0.0))
    }
    
    func showCalendar() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1.0
        }) { (isAnimationComplete) in
            if isAnimationComplete {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.calendarContainerViewTopAnchorConstraint?.constant = 0
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @objc func hideCalendar() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.calendarContainerViewTopAnchorConstraint?.constant = -self.frame.height
            self.layoutIfNeeded()
        }) { (isAnimationComplete) in
            if isAnimationComplete {
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 0.0
                }, completion: { (isAnimationComplete) in
                    if isAnimationComplete {
                        // pass date back here
                    }
                })
            }
        }
    }
}


// calendar delegate and datasource methods
extension CustomCalendarModal: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        // set up date formatter conditions
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        // set parameters
        let startDate = dateFormatter.date(from: "2018 07 01")
        let endDate = Date()
        
        let parameters = ConfigurationParameters(startDate: startDate ?? endDate, endDate: endDate)
        
        return parameters
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let customCalendarCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCellId", for: indexPath) as? CustomCalendarCell else { return JTAppleCell() }
        configureCalendarCell(withCalendarCell: customCalendarCell, cellState: cellState, date: date)
        return customCalendarCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let customCalendarCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCellId", for: indexPath) as? CustomCalendarCell else { return }
        configureCalendarCell(withCalendarCell: customCalendarCell, cellState: cellState, date: date)
    }
    
    func configureCalendarCell(withCalendarCell customCalendarCell: CustomCalendarCell, cellState: CellState, date: Date) {
        customCalendarCell.dateLabel.text = cellState.text
        
        let inbuiltCalendar = Calendar(identifier: .gregorian)
        if inbuiltCalendar.isDateInToday(date) {
            customCalendarCell.backgroundColor = ditloRed
        } else {
            customCalendarCell.backgroundColor = ditloLightGrey
        }
    }
}
