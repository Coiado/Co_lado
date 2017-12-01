//
//  MapViewController.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 18/08/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    
    //outlets
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchField: UIView!
    
    @IBOutlet weak var textSearch: UITextField!

    var locationManager: CLLocationManager?
    
    var previousLocation : CLLocation!
    //properties
    
    var selectedPin:MKPlacemark? = nil
    var searchController: UISearchController!
    var annotation: MKAnnotation!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var error: NSError!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
    var mapPresenter = MapPresenter()
    
    var mapProtocolDelegate: MapProtocol?
    
    var postController = PostTableViewController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //kCLLocationAccuracyBest
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.startUpdatingLocation()
        
        //Configurate SearchController
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        searchController = UISearchController(searchResultsController: locationSearchTable)
        searchController?.searchResultsUpdater = locationSearchTable
        
        
        //Customizing searchBar
        let searchBar = searchController!.searchBar
        searchBar.placeholder = "Onde quer receber o pedido?"
        print("O NUMERO DE SUBVIEWS É  \(searchController.searchBar.subviews.count)")
        searchController.searchBar.barTintColor = UIColor(red: 244/255, green: 124/255, blue: 71/255, alpha: 1.0)
    

        searchField.addSubview(searchController.searchBar)
        for subview in searchBar.subviews {
            if subview.isKind(of: NSClassFromString("UINavigationButton")!) { //checking if it is a button
                let button:UIButton!
                //subview.tintColor = UIColor(red: 254/255, green: 247/255, blue: 228/255, alpha: 1.0)
                button = subview as! UIButton
                button.setTitle("Cancelar", for: .normal)
            }
        }
        
        let cancelButton: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButton as? [String : Any], for: .normal)
    
        
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        
        
        
        
        //Configurate Map
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        //mapProtocolDelegate = self.mapPresenter
        //mapProtocolDelegate = self.postController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        //Adjusting Layout of SearchBar
        searchController.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
    
    }
    
    
    
    //function to add annotation to map view
    func addAnnotationsOnMap(_ locationToPoint : CLLocation){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationToPoint.coordinate
        let geoCoder = CLGeocoder ()
        geoCoder.reverseGeocodeLocation(locationToPoint, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks! as? [CLPlacemark] , placemarks.count > 0 {
                let placemark = placemarks[0]
                _ = placemark.addressDictionary;
                //annotation.title = addressDictionary!["Name"] as? String
                annotation.title = "VOCÊ ESTA AQUI"
                self.mapView.addAnnotation(annotation)
            }
        })
    }
    
    
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            self.mapPresenter.getNotation(self.pointAnnotation)
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            print(self.pointAnnotation.debugDescription)
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            
            //self.mapProtocolDelegate?.getMapCoordinate(self,location: self.pointAnnotation.coordinate)
            
            
        }
    }
    

    @IBAction func buttonDone(_ sender: Any) {
        
        self.mapProtocolDelegate?.getMapCoordinate(self,location: self.mapView.annotations[0].coordinate)
    }
    

}


extension MapViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations = \(locations)")
        
        
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.0))
        
        self.mapView.setRegion(region, animated: true)
        
        manager.stopUpdatingLocation()
        
        
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
//        
//        //println("present location : \(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)")
//        
//        //drawing path or route covered
//        if let oldLocationNew = oldLocation as CLLocation?{
//            let oldCoordinates = oldLocationNew.coordinate
//            let newCoordinates = newLocation.coordinate
//            var area = [oldCoordinates, newCoordinates]
//            let polyline = MKPolyline(coordinates: &area, count: area.count)
//            mapView.add(polyline)
//        }
//        
//        
//        //calculation for location selection for pointing annoation
//        if (previousLocation as CLLocation?) != nil{
//            //case if previous location exists
//            if previousLocation.distance(from: newLocation) > 200 {
//                addAnnotationsOnMap(newLocation)
//                previousLocation = newLocation
//                manager.stopUpdatingLocation()  
//            }
//        }else{
//            //case if previous location doesn't exists
//            addAnnotationsOnMap(newLocation)
//            previousLocation = newLocation
//        }
//    }
    
  
    
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        
        let pin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        return pin
    }
    
//    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
//        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 20, 20)
//        
//        self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
//        
//        let point = MKPointAnnotation()
//        
//        point.coordinate = userLocation.coordinate
//        point.title = "VOCÊ ESTÁ AQUI"
//        
//        self.mapView.addAnnotation(point)
//    }
}


extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}





