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
    
    let monthNameLabel: UILabel = {
        let label = UILabel()
        label.text = "January 2018"
        label.font = navBarCalendarButtonFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    let borderView = PaddedBorderView()
    
    let datesStackView = UIStackView()
    
    let sundayLabel: UILabel = {
        let label = UILabel()
        label.text = "S"
        label.font = calendarCellLabelFont
        label.textColor = ditloGrey
        label.textAlignment = .center
        return label
    }()
    
    let mondayLabel: UILabel = {
        let label = UILabel()
        label.text = "M"
        label.font = calendarCellLabelFont
        label.textColor = ditloGrey
        label.textAlignment = .center
        return label
    }()
    
    let tuesdayLabel: UILabel = {
        let label = UILabel()
        label.text = "T"
        label.font = calendarCellLabelFont
        label.textColor = ditloGrey
        label.textAlignment = .center
        return label
    }()
    
    let wednesdayLabel: UILabel = {
        let label = UILabel()
        label.text = "W"
        label.font = calendarCellLabelFont
        label.textColor = ditloGrey
        label.textAlignment = .center
        return label
    }()
    
    let thursdayLabel: UILabel = {
        let label = UILabel()
        label.text = "T"
        label.font = calendarCellLabelFont
        label.textColor = ditloGrey
        label.textAlignment = .center
        return label
    }()
    
    let fridayLabel: UILabel = {
        let label = UILabel()
        label.text = "F"
        label.font = calendarCellLabelFont
        label.textColor = ditloGrey
        label.textAlignment = .center
        return label
    }()
    
    let saturdayLabel: UILabel = {
        let label = UILabel()
        label.text = "S"
        label.font = calendarCellLabelFont
        label.textColor = ditloGrey
        label.textAlignment = .center
        return label
    }()
    
    let calendar: JTAppleCalendarView = {
        let c = JTAppleCalendarView(frame: .zero)
        c.backgroundColor = UIColor.clear
        c.scrollDirection = .horizontal
        c.minimumLineSpacing = 0.0
        c.minimumInteritemSpacing = 0
        c.showsHorizontalScrollIndicator = false
        c.cellSize = screenWidth / 7
        let todayDate = Date()
        c.scrollToDate(todayDate)
        c.selectDates([todayDate])
        c.isPagingEnabled = true
        c.register(CustomCalendarCell.self, forCellWithReuseIdentifier: "CalendarCellId")
        return c
    }()
    
    let calendarDismissButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissCalendarButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // variables
    let dateFormatter = DateFormatter()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = ditloOffBlack.withAlphaComponent(0.75)
        alpha = 0.0
        setupChildDelegates()
        anchorChildViews()
    }
    
    func setupChildDelegates() {
        calendar.calendarDelegate = self
        calendar.calendarDataSource = self
    }
    
    func anchorChildViews() {
        // calendar container view
        addSubview(calendarContainerView)
        calendarContainerView.anchor(withTopAnchor: nil, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil)
        calendarContainerViewTopAnchorConstraint = NSLayoutConstraint(item: calendarContainerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: -1000.0)
        addConstraint(calendarContainerViewTopAnchorConstraint!)
        
        // logo image view
        calendarContainerView.addSubview(miniDitloLogoImageView)
        miniDitloLogoImageView.anchor(withTopAnchor: calendarContainerView.safeAreaLayoutGuide.topAnchor, leadingAnchor: calendarContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 14.0, heightAnchor: 14.0, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        calendarContainerView.addSubview(ditloLogoNameLabel)
        ditloLogoNameLabel.anchor(withTopAnchor: nil, leadingAnchor: miniDitloLogoImageView.trailingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: miniDitloLogoImageView.centerYAnchor, widthAnchor: 60.0, heightAnchor: nil, padding: .init(top: 0.0, left: 4.0, bottom: 0.0, right: 0.0))
        
        // month name
        calendarContainerView.addSubview(monthNameLabel)
        monthNameLabel.anchor(withTopAnchor: miniDitloLogoImageView.bottomAnchor, leadingAnchor: calendarContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: calendarContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 6.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        calendarContainerView.addSubview(borderView)
        borderView.anchor(withTopAnchor: monthNameLabel.bottomAnchor, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: calendarContainerView.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // days labels
        calendarContainerView.addSubview(datesStackView)
        datesStackView.anchor(withTopAnchor: borderView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 12.0, padding: .init(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        let dates: [UILabel] = [sundayLabel, mondayLabel, tuesdayLabel, wednesdayLabel, thursdayLabel, fridayLabel, saturdayLabel]
        dates.forEach { (dateLabel) in
            datesStackView.addArrangedSubview(dateLabel)
        }
        datesStackView.distribution = .fillEqually
        
        // calendar
        calendarContainerView.addSubview(calendar)
        calendar.anchor(withTopAnchor: datesStackView.bottomAnchor, leadingAnchor: calendarContainerView.leadingAnchor, bottomAnchor: calendarContainerView.bottomAnchor, trailingAnchor: calendarContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: screenWidth, heightAnchor: 300.0, padding: .init(top: 20.0, left: 0.0, bottom: -20.0, right: 0.0))
        
        // dismiss calendar button
        addSubview(calendarDismissButton)
        calendarDismissButton.anchor(withTopAnchor: calendarContainerView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
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
    
    @objc func dismissCalendarButtonPressed() {
        hideCalendar()
    }
    
    func hideCalendar(withDate date: Date? = nil) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.calendarContainerViewTopAnchorConstraint?.constant = -self.frame.height
            self.layoutIfNeeded()
        }) { (isAnimationComplete) in
            if isAnimationComplete {
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 0.0
                }, completion: { (isAnimationComplete) in
                    if isAnimationComplete {
                        if date != nil {
                            // pass the date back
                        }
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
        let todayDate = Date()

        let parameters = ConfigurationParameters(startDate: startDate ?? todayDate, endDate: todayDate)

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
        handleCellStylingState(withCell: customCalendarCell, cellState: cellState, andDate: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let cell = cell {
            handleCellSelectedState(withCell: cell, cellState: cellState, date: date, andIsSelectedState: true)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let cell = cell {
            handleCellSelectedState(withCell: cell, cellState: cellState, date: date, andIsSelectedState: false)
        }
    }
    
    /*-- custom calendar helper methods --*/
    func handleCellStylingState(withCell cell: JTAppleCell, cellState: CellState, andDate date: Date) {
        guard let cell = cell as? CustomCalendarCell else { return }
        let inbuiltCalendar = Calendar(identifier: .gregorian)
        
        cell.isUserInteractionEnabled = cellState.dateBelongsTo == .thisMonth && date.timeIntervalSinceNow.sign != .plus ? true : false
        cell.isDateInMonth = cellState.dateBelongsTo == .thisMonth
        cell.isDateLaterInMonth = cellState.dateBelongsTo == .thisMonth && date.timeIntervalSinceNow.sign == .plus
        cell.isDateToday = inbuiltCalendar.isDateInToday(date)
        cell.dateLabel.text = cellState.text
    }
    
    func handleCellSelectedState(withCell cell: JTAppleCell, cellState: CellState, date: Date, andIsSelectedState isSelected: Bool) {
        guard let cell = cell as? CustomCalendarCell else { return }
        
        if isSelected {
            if cellState.dateBelongsTo == .thisMonth && date.timeIntervalSinceNow.sign != .plus {
                cell.isDateSelected = isSelected
                hideCalendar(withDate: date)
            }
        } else {
            cell.isDateSelected = isSelected
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let currentMonth = formatter.string(from: (visibleDates.monthDates.first?.date)!)
        monthNameLabel.text = currentMonth
    }
}
