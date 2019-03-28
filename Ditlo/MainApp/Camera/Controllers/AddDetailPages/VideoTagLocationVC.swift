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

    // location
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserCurrentLocation()
    }
    
    func getUserCurrentLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            /*-- no permission --*/
            case .notDetermined, .restricted, .denied:
                print("Locations services not permitted")
                break
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Location services permitted")
                break
            }
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
        }
    }
}

// location delegate methods
extension VideoTagLocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
