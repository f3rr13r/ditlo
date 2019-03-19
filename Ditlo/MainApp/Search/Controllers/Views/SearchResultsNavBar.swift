//
//  SearchResultsNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/19/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol SearchResultsNavBarDelegate {
    func backButtonPressed()
    func navigationCellSelected(itemIndex: IndexPath)
}

class SearchResultsNavBar: BaseView {

    // injector variables
    var searchResult: String = "" {
        didSet {
            searchResultTitleLabel.text = searchResult
            SharedModalsService.instance.hideCustomOverlayModal()
        }
    }

    var sections: [NavigationCellContent] = [] {
        didSet {
            searchResultsNavigationCollectionView.sections = sections
        }
    }
    
    var currentlySelectedSectionIndex: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            searchResultsNavigationCollectionView.updateSelectedCell(withIndexPath: currentlySelectedSectionIndex)
        }
    }
    
    // views
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "ditlo-logo")
        return iv
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "DITLO"
        label.textColor = ditloOffBlack
        label.font = largeProfileInfoNameFont
        return label
    }()
    
    let topContentRowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let backButtonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "back-arrow-icon")
        return iv
    }()
    
    let calendarButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(calendarButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let calendarIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        let calendarImage = #imageLiteral(resourceName: "calendar-icon")
        iv.image = calendarImage
        return iv
    }()
    
    let calendarDateLabel: UILabel = {
        let label = UILabel()
        label.text = "29 DEC 2018"
        label.font = defaultParagraphFont
        label.textColor = ditloOffBlack
        label.textAlignment = .right
        return label
    }()
    
    let searchResultTitleLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.numberOfLines = 1
        label.text = "Categories"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        label.trailingBuffer = 8.0
        label.fadeLength = 6.0
        return label
    }()
    
    let searchResultsNavigationCollectionView = NavigationCollectionView()
    
    // delegate
    var delegate: SearchResultsNavBarDelegate?
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        setupChildDelegates()
        anchorSubviews()
    }
    
    func setupChildDelegates() {
        searchResultsNavigationCollectionView.delegate = self
    }
    
    func anchorSubviews() {
        addSubview(topContentRowView)
        topContentRowView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 44.0, padding: .init(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        topContentRowView.addSubview(backButton)
        backButton.anchor(withTopAnchor: topContentRowView.topAnchor, leadingAnchor: topContentRowView.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 44.0, heightAnchor: 44.0)
        backButton.addSubview(backButtonImageView)
        backButtonImageView.anchor(withTopAnchor: backButton.topAnchor, leadingAnchor: backButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 26.0, heightAnchor: 26.0, padding: .init(top: 6.0, left: 14.0, bottom: 0.0, right: 0.0))
        topContentRowView.addSubview(calendarButton)
        calendarButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: topContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: topContentRowView.centerYAnchor, widthAnchor: nil, heightAnchor: 20.0)
        calendarButton.addSubview(calendarIconImageView)
        calendarIconImageView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: calendarButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: calendarButton.centerYAnchor, widthAnchor: 14.0, heightAnchor: 14.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        calendarButton.addSubview(calendarDateLabel)
        calendarDateLabel.anchor(withTopAnchor: nil, leadingAnchor: calendarButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: calendarIconImageView.leadingAnchor, centreXAnchor: nil, centreYAnchor: calendarButton.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -8.0))
        
        topContentRowView.addSubview(logoImageView)
        logoImageView.anchor(withTopAnchor: topContentRowView.topAnchor, leadingAnchor: backButton.trailingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 10.0, heightAnchor: 10.0)
        topContentRowView.addSubview(logoLabel)
        logoLabel.anchor(withTopAnchor: topContentRowView.topAnchor, leadingAnchor: logoImageView.trailingAnchor, bottomAnchor: nil, trailingAnchor: calendarButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 2.0, bottom: 0.0, right: 0.0))
        topContentRowView.addSubview(searchResultTitleLabel)
        searchResultTitleLabel.anchor(withTopAnchor: logoImageView.bottomAnchor, leadingAnchor: backButton.trailingAnchor, bottomAnchor: nil, trailingAnchor: calendarButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -12.0))
        
        // navigation controller
        addSubview(searchResultsNavigationCollectionView)
        searchResultsNavigationCollectionView.anchor(withTopAnchor: topContentRowView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
    
    @objc func backButtonPressed() {
        delegate?.backButtonPressed()
    }
    
    @objc func calendarButtonPressed() {
        SharedModalsService.instance.showCalendar()
    }
}

extension SearchResultsNavBar: NavigationCollectionViewDelegate {
    func navigationCellSelected(itemIndex: IndexPath) {
        delegate?.navigationCellSelected(itemIndex: itemIndex)
    }
}
