//
//  MapPresenter.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 09/09/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import MapKit

protocol MapProtocol {
    func getMapCoordinate(_ mapViewController: MapViewController,location:CLLocationCoordinate2D)
}

class MapPresenter: MapProtocol {
    weak var mapController: MapViewController!
    var geocoder: CLGeocoder!
    var location: CLLocationCoordinate2D?
    var importantInfo = [String]()
    var city: String!
    var neighborhood: String!
    var state: String!
    weak var postControl = PostTableViewController()
    init () {
        
    }
    
    func getNotation (_ annotation: MKPointAnnotation) {
        print(annotation.coordinate.latitude)
    }
    
    func getMapCoordinate(_ mapViewController: MapViewController,location: CLLocationCoordinate2D) {
        self.location = location
        geocoder = CLGeocoder()
        let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
        print(loc)
        geocoder.reverseGeocodeLocation(loc) { (placemarks, error) in
            let placemark = placemarks?[0]
            
            print(placemark?.addressDictionary! as Any)
            if let street  = placemark?.addressDictionary?["Thoroughfare"] as? NSString {
                print("STREET\(street)")
            }
            if let city = placemark?.locality {
                self.city = city
                print("CITY IS \(self.city)")
                self.postControl?.locationLbl.text = self.city
            }
            
            if let neighborhood = placemark?.name {
                self.neighborhood = neighborhood
            }
            
            if let state = placemark?.administrativeArea {
                self.state = state
            }
        }
  
        print("I get Location \(self.location!)")
    }
    
    
}
