//
//  VideoTagLocationVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/28/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import CoreLocation

class VideoTagLocationVC: UIViewController {

    // views
    let topPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let videoTagLocationNavBar = VideoTagLocationNavBar()
    
    let mainContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // custom switcher
    let customSwitcher = CustomSwitcherView(firstOption: "Nearby", secondOption: "Current Location", transitionSpeed: 0.25, startingIndex: 1, defaultColour: ditloVeryLightGrey, selectedColour: ditloDarkBlue)
    
    
    let noLocationPermissionsContainer: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    let noLocationPermissionsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Location Access Denied"
        label.font = smallTitleFont
        label.textColor = ditloOffBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let noLocationPermissionsMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Ditlo requires your location permission to serve both your current location and nearby locations for you to select from"
        label.font = defaultParagraphFont
        label.textColor = ditloGrey
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let goToPhoneSettingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open settings", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ditloDarkBlue
        button.titleLabel?.font = defaultParagraphFont
        button.layer.cornerRadius = 4.0
        button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        button.addTarget(self, action: #selector(goToPhoneSettingsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // location
    let locationManager = CLLocationManager()
    
    // variables
    var currentlySelectedOptionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        getUserCurrentLocation()
        anchorSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*-- adding two app delegate notification observers here.
             1.) app did return to foreground for when user leaves the app manually and then returns
             2.) user navigated through to settings and then pressed the phone back button
                 to return to the app
        --*/
        NotificationCenter.default.addObserver(self, selector: #selector(appDelegateNotificationTriggered), name: .appDidReturnToForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDelegateNotificationTriggered), name: .appDidReturnToActiveState, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func appDelegateNotificationTriggered() {
        getUserCurrentLocation()
    }
    
    func getUserCurrentLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            /*-- no permission --*/
            case .notDetermined, .restricted, .denied:
                handleNoLocationPermissionsState()
                break
                
            case .authorizedAlways, .authorizedWhenInUse:
                handleLocationGrantedState()
                break
            }
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
        }
    }
    
    func anchorSubviews() {
        // top padding view
        self.view.addSubview(topPaddingView)
        topPaddingView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: safeAreaTopPadding)
        
        // nav bar
        self.view.addSubview(videoTagLocationNavBar)
        videoTagLocationNavBar.anchor(withTopAnchor: topPaddingView.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        
        // main content
        self.view.addSubview(mainContentView)
        mainContentView.anchor(withTopAnchor: videoTagLocationNavBar.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        
        // custom switcher
        mainContentView.addSubview(customSwitcher)
        customSwitcher.anchor(withTopAnchor: mainContentView.topAnchor, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: mainContentView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        
        // no location permissions view
        mainContentView.addSubview(noLocationPermissionsContainer)
        noLocationPermissionsContainer.anchor(withTopAnchor: nil, leadingAnchor: mainContentView.leadingAnchor, bottomAnchor: nil, trailingAnchor: mainContentView.trailingAnchor, centreXAnchor: nil, centreYAnchor: mainContentView.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        noLocationPermissionsContainer.addSubview(noLocationPermissionsTitleLabel)
        noLocationPermissionsTitleLabel.anchor(withTopAnchor: noLocationPermissionsContainer.topAnchor, leadingAnchor: noLocationPermissionsContainer.leadingAnchor, bottomAnchor: nil, trailingAnchor: noLocationPermissionsContainer.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        noLocationPermissionsContainer.addSubview(noLocationPermissionsMessageLabel)
        noLocationPermissionsMessageLabel.anchor(withTopAnchor: noLocationPermissionsTitleLabel.bottomAnchor, leadingAnchor: noLocationPermissionsContainer.leadingAnchor, bottomAnchor: nil, trailingAnchor: noLocationPermissionsContainer.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0))
        noLocationPermissionsContainer.addSubview(goToPhoneSettingsButton)
        goToPhoneSettingsButton.anchor(withTopAnchor: noLocationPermissionsMessageLabel.bottomAnchor, leadingAnchor: nil, bottomAnchor: noLocationPermissionsContainer.bottomAnchor, trailingAnchor: nil, centreXAnchor: noLocationPermissionsContainer.centerXAnchor, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
    
    func handleNoLocationPermissionsState() {
        noLocationPermissionsContainer.isHidden = false
    }
    
    @objc func goToPhoneSettingsButtonPressed() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    func handleLocationGrantedState() {
        noLocationPermissionsContainer.isHidden = true
    }
}

// location delegate methods
extension VideoTagLocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
