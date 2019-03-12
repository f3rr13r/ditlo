//
//  CategoriesNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/12/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol CategoriesNavBarDelegate {
    func calendarButtonPressed()
    func navigationCellSelected(itemIndex: IndexPath)
}

class CategoriesNavBar: BaseView {
    
    // injector variables
    var categorySections: [String] = [] {
        didSet {
            categoriesNavigationCollectionView.navigationSections = categorySections
        }
    }
    
    var categoryColours: [UIColor] = [] {
        didSet {
            categoriesNavigationCollectionView.cellColours = categoryColours
        }
    }
    
    var currentlySelectedSectionIndex: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            categoriesNavigationCollectionView.updateSelectedCell(withIndexPath: currentlySelectedSectionIndex)
        }
    }
    
    // views
    let logoContainerRowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
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
    
    let calendarButton: UIButton = {
        let button = UIButton()
        //button.addTarget(self, action: #selector(calendarButtonPressed), for: .touchUpInside)
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
    
    let categoriesTitleLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.numberOfLines = 1
        label.text = "Categories"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        label.trailingBuffer = 8.0
        label.fadeLength = 6.0
        return label
    }()
    
    let categoriesNavigationCollectionView = NavigationCollectionView()
    
    // delegate
    var delegate: CategoriesNavBarDelegate?
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        setupChildDelegates()
        anchorSubviews()
    }
    
    func setupChildDelegates() {
        categoriesNavigationCollectionView.delegate = self
    }
    
    func anchorSubviews() {
        // logo container row
        addSubview(logoContainerRowView)
        logoContainerRowView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 10.0)
        logoContainerRowView.addSubview(logoImageView)
        logoImageView.anchor(withTopAnchor: logoContainerRowView.topAnchor, leadingAnchor: logoContainerRowView.leadingAnchor, bottomAnchor: logoContainerRowView.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 10.0, heightAnchor: 10.0, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        logoContainerRowView.addSubview(logoLabel)
        logoLabel.anchor(withTopAnchor: logoContainerRowView.topAnchor, leadingAnchor: logoImageView.trailingAnchor, bottomAnchor: logoContainerRowView.bottomAnchor, trailingAnchor: logoContainerRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 2.0, bottom: 0.0, right: 0.0))
        
        // top content
        addSubview(topContentRowView)
        topContentRowView.anchor(withTopAnchor: logoContainerRowView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 32.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
        topContentRowView.addSubview(calendarButton)
        calendarButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: topContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: topContentRowView.centerYAnchor, widthAnchor: nil, heightAnchor: 20.0)
        calendarButton.addSubview(calendarIconImageView)
        calendarIconImageView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: calendarButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: calendarButton.centerYAnchor, widthAnchor: 14.0, heightAnchor: 14.0, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        calendarButton.addSubview(calendarDateLabel)
        calendarDateLabel.anchor(withTopAnchor: nil, leadingAnchor: calendarButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: calendarIconImageView.leadingAnchor, centreXAnchor: nil, centreYAnchor: calendarButton.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -8.0))
        topContentRowView.addSubview(categoriesTitleLabel)
        categoriesTitleLabel.anchor(withTopAnchor: topContentRowView.topAnchor, leadingAnchor: topContentRowView.leadingAnchor, bottomAnchor: topContentRowView.bottomAnchor, trailingAnchor: calendarButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -12.0))
        
        // navigation controller
        addSubview(categoriesNavigationCollectionView)
        categoriesNavigationCollectionView.anchor(withTopAnchor: topContentRowView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
}

extension CategoriesNavBar: NavigationCollectionViewDelegate {
    func navigationCellSelected(itemIndex: IndexPath) {
        delegate?.navigationCellSelected(itemIndex: itemIndex)
    }
}
