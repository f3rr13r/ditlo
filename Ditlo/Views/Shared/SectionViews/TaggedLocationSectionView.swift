//
//  TaggedLocationSectionView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MapKit

class TaggedLocationSectionView: BaseView {

    // views
    let taggedLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Tagged Location"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    let mapView = MKMapView()
    
    let locationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "U.S Bank Stadium"
        label.font = smallTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    let locationAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "401 Chicago Ave, Minneapolis"
        label.font = defaultParagraphFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    let locationCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "MN 55415"
        label.font = defaultParagraphFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    let locationCountryLabel: UILabel = {
        let label = UILabel()
        label.text = "USA"
        label.font = defaultParagraphFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    // delegate
    var delegate: SectionViewActionDelegate?
    
    override func setupViews() {
        super.setupViews()
        configureMapView()
        anchorSubviews()
        setupGestureRecognizer()
    }
    
    func configureMapView() {
        // UX stuff
        mapView.layer.cornerRadius = 4.0
        mapView.layer.borderWidth = 1.0
        mapView.layer.borderColor = ditloLightGrey.cgColor
        mapView.layer.masksToBounds = true
        
        // conditional stuff
        mapView.isUserInteractionEnabled = false
        
        let stadiumLocation = CLLocation(latitude: 44.973994, longitude: -93.257783)
        centerMapOnLocation(location: stadiumLocation)
        centerPinOnMap(location: stadiumLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerPinOnMap(location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
    }
    
    func anchorSubviews() {
        addSubview(taggedLocationLabel)
        taggedLocationLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        addSubview(mapView)
        //let edgeToEdgeLength: CGFloat = (screenWidth - (horizontalPadding * 2.0)) * 0.3
        mapView.anchor(withTopAnchor: taggedLocationLabel.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 140.0, padding: .init(top: 24.0, left: horizontalPadding, bottom: -24.0, right: -horizontalPadding))
        
        addSubview(locationNameLabel)
        locationNameLabel.anchor(withTopAnchor: mapView.topAnchor, leadingAnchor: mapView.leadingAnchor, bottomAnchor: nil, trailingAnchor: mapView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: 12.0, bottom: 0.0, right: -12.0))
        
        addSubview(locationAddressLabel)
        locationAddressLabel.anchor(withTopAnchor: locationNameLabel.bottomAnchor, leadingAnchor: locationNameLabel.leadingAnchor, bottomAnchor: nil, trailingAnchor: locationNameLabel.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        addSubview(locationCodeLabel)
        locationCodeLabel.anchor(withTopAnchor: locationAddressLabel.bottomAnchor, leadingAnchor: locationAddressLabel.leadingAnchor, bottomAnchor: nil, trailingAnchor: locationAddressLabel.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        addSubview(locationCountryLabel)
        locationCountryLabel.anchor(withTopAnchor: locationCodeLabel.bottomAnchor, leadingAnchor: locationCodeLabel.leadingAnchor, bottomAnchor: nil, trailingAnchor: locationCodeLabel.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
    
    func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(userDidTap))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    @objc func userDidTap() {
        delegate?.taggedLocationSelected(withLocationValue: "some location value")
    }
}
