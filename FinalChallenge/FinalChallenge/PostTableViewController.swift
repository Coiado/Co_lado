//
//  PostTableViewController.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 22/08/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseDatabase
import MapKit

protocol PostProtocol {
    func save()
}



class PostTableViewController: UITableViewController{
    
    var geocoder: CLGeocoder!
    
    //Properties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var tagTextField: UITextField!
    //@IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var durationPickerView: UIPickerView!
    @IBOutlet weak var locationLbl: UILabel!
    
    
    
    var presenter: PostPresenter?
    var mapPresenter: MapPresenter?
    
    //var location: MKPointAnnotation?
    var locationManager = CLLocationManager()

    
    var category:String!
    
    let categoryArray = ["Ferramentas", "Alimentos", "Roupas","Material Escolar", "Outros"]
    let durationArray = ["1 hora","2 horas","3 horas"]
    
    var selectedCategoryItem: Int = 0
    var selectedDurationItem: Int = 0
    var location: CLLocation!
    var city: String!
    var neighborhood: String!
    var state: String!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
                
        
//        NotificationCenter.default.addObserver(self, selector: #selector(save), name: NSNotification.Name(rawValue: "buttomSavePressed"), object: nil)
        presenter = PostPresenter(viewController: self)
        
        self.categoryPickerView.dataSource = self
        self.categoryPickerView.delegate = self
        self.categoryPickerView.tag = 0
        //self.durationPickerView.dataSource = self
        //self.durationPickerView.delegate = self
        //self.durationPickerView.tag = 1
        
        //location
        geocoder = CLGeocoder()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.msgTextView.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        locationManager.stopUpdatingLocation()
        self.location = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: NSNotification.Name(rawValue: "buttomSavePressed"), object: nil)

        
        if  self.city != nil {
            self.locationLbl.text = ("\(self.neighborhood!). \(self.city!), \(self.state!)")
        }else {
            self.locationLbl.text = NSLocalizedString("Sem localização", comment: "without location")
        }

    }

    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 3
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        }else if section == 3 {
            return 1
        }else if section == 4 {
            return 1
        }else {
            return 4
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
    func save (){
        
        if location != nil {
            if mapPresenter?.city != nil {
                
                
                if verifyTextFields() {
                    presenter?.saveNewPost(self.titleTextField.text!,
                                           body: self.msgTextView.text!,
                                           tags: categoryArray[self.selectedCategoryItem],
                                           location: ("\(self.neighborhood!). \(self.city!), \(self.state!)"),
                                           duration: "0",
                                           latitude: ("\(self.location.coordinate.latitude)"),
                                           longitude: ("\(self.location.coordinate.longitude)")
                    )
                    
                    self.saveAlert()

                }else {
                    self.emptyFieldAlert()
                }
                
                
            } else {
                
                if verifyTextFields() {
                    
                    presenter?.saveNewPost(self.titleTextField.text!,
                                           body: self.msgTextView.text!,
                                           tags: categoryArray[self.selectedCategoryItem],
                                           location: ("SEM NOME DE CIDADE"),
                                           duration: "0",
                                           latitude: ("\(self.location.coordinate.latitude)"),
                                           longitude: ("\(self.location.coordinate.longitude)")
                    )
                    
                    self.saveAlert()
                    
                }else {
                    self.emptyFieldAlert()
                }
                
                
            }
            
        } else {
            
            if verifyTextFields() {
                
                presenter?.saveNewPost(self.titleTextField.text!,
                                       body: self.msgTextView.text!,
                                       tags: categoryArray[self.selectedCategoryItem],
                                       location: ("SEM LOCALIZAÇÃO"),
                                       duration: "0",
                                       latitude: ("-90"),
                                       longitude: ("-180")
                )
                
                self.saveAlert()
                
            }else {
                self.emptyFieldAlert()
            }
            
           

        }
        
        
    }
    
    
    func setLocation (city:String) {
        self.city = city
    }
    
    func verifyTextFields () -> Bool {
        if (titleTextField.text?.isEmpty)! || msgTextView.text.isEmpty  {
            return false
        }
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "map" {
            let navigationToMap = segue.destination as! UINavigationController
            let mapVC = navigationToMap.topViewController as! MapViewController
            mapVC.mapProtocolDelegate = self
        }
    }
    
    
    func setLocationField() {
        self.locationLbl.text = ("\(self.neighborhood!). \(self.city!), \(self.state!)")
    }
    
    func saveAlert() {
        let alertController = UIAlertController(title: "Publicação salva", message: "Sua publicação foi salva com sucesso", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.dismiss(animated: true, completion: nil)
        }
        
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func emptyFieldAlert(){
        print("CAMPO VAZIO")
        // Create the alert controller
        let alertController = UIAlertController(title: "Campo Vazio", message: "Todos os campos devem ser preenchidos   ", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        _ = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        //alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    

}

//extension for text View
extension PostTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}



extension PostTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            self.selectedCategoryItem = row
            
        }else{
            self.selectedDurationItem = row
        }
    }
    
    
}
extension PostTableViewController: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return categoryArray[row]
        } else {
            return durationArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return categoryArray.count
        if pickerView.tag == 0 {
            return categoryArray.count
        }else {
            return durationArray.count
        }
    }
}


extension PostTableViewController: MapProtocol {
    
    func getMapCoordinate(_ mapViewController: MapViewController ,location: CLLocationCoordinate2D) {
        //self.location = location
        geocoder = CLGeocoder()
        let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
        self.location = loc
        //print(loc)
        
        
        
        
        geocoder.reverseGeocodeLocation(loc) { (placemarks, error) in
            let placemark = placemarks?[0]
            if placemark != nil {
                print(placemark?.addressDictionary! as Any)
                
                if let city = placemark?.locality {
                    self.city = city
                    print("CITY IS \(self.city!)")
                }
                
                mapViewController.dismiss(animated: true, completion: nil)
                if let neighborhood = placemark?.name {
                    self.neighborhood = neighborhood
                }
                
                if let state = placemark?.administrativeArea {
                    self.state = state
                }
            }else {
                self.city = NSLocalizedString("SEM LOCALIZAÇÃO", comment: "WITHOUT LOCATION message")
                self.neighborhood = ""
                self.state = ""
            }
            
        }
        
    }

}



//Map extension try to extract to a service in the future
extension PostTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if self.location == nil {
            
            geocoder.reverseGeocodeLocation(manager.location!) { (placemark, error) in
                if error != nil {
                    print ("Reverse geocoder faild\(error?.localizedDescription)")
                    return
                }
                if (placemark?.count)! >= 0 {
                    //let pm = (placemark[0])! as! CLPlacemark
                    self.city = placemark?[0].locality
                    self.neighborhood = placemark?[0].name
                    self.state = placemark?[0].administrativeArea
                    
                    self.setLocationField()
                }
            }
            
            self.location =  locations.last
            
        }else {
            self.location = locations.last
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error for location \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if self.location == nil {
            
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                manager.startUpdatingLocation()
            }else if status == .denied || status == .notDetermined {
                manager.stopUpdatingLocation()
            }
            
        }

    }
}
