//
//  LocationServices.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 28/09/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationProtocol {
    func setLocation(locations:[CLLocation]) -> [CLLocation]
}

class LocationServices:NSObject, CLLocationManagerDelegate {
    var userLocation: CLLocation!
    var locationManager: CLLocationManager!
    override init() {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LOCATION SERVICE: the error is \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //TODO
    }
    
    func setLocation () {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    
    
}
