//
//  MainViewController.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 11/08/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseDatabase
import MapKit

class MainViewController: UIViewController{
    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    

    //properties
    var messages = [String]()
    let refreshControl = UIRefreshControl()
    var posts = [Post]()
    let presenter = FeedPresenter()
    
    let services = Services()
    
    //location
    ///user current location
    let locationManager = CLLocationManager()
    var location: CLLocation!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        
        refreshControl.backgroundColor = UIColor.gray
        refreshControl.addTarget(self, action:#selector(refreshTable), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Updated: \(self.refreshMessage())")
        //tableView.addSubview(refreshControl)
        self.posts.removeAll()
        
        presenter.attachView(self)
        //presenter.loadFeed()
        
        
        self.refreshTable()
        
        view.backgroundColor = UIColor(colorLiteralRed: 254/255, green: 248/255, blue: 228/255, alpha: 1)
        tableView.backgroundColor = UIColor.clear
        
        //try! FIRAuth.auth()?.signOut()
        
        self.setLocationManager()
        
        SocketIOManager.sharedInstance.establishConnection()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.loadFeed()


        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - refresh table
    func refreshTable(){
        self.tableView.reloadData()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Updated: \(self.refreshMessage())")
        refreshControl.endRefreshing()
        

    }
    
    func refreshMessage() -> String {
        
        let formater = DateFormatter()
        formater.dateStyle = DateFormatter.Style.short
        formater.timeStyle = .short
        
        let dateString = formater.string(from: Date() as Date)
        
        
        return dateString
    }
    
    
    func loadInfo(_ posts:[Post]){
        self.posts = posts
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.topViewController as! PostDetailViewController
            print("SELECTED POST \(posts[(tableView.indexPathForSelectedRow?.row)!])")
            vc.post = posts[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    func callPerfilView(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.tableView)
        var indexPath = self.tableView.indexPathForRow(at: tapLocation)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let navVc = sb.instantiateViewController(withIdentifier: "perfilNav") as! UINavigationController
        let vc = navVc.viewControllers[0] as! PerfilViewController
        vc.uid = posts[(indexPath?.row)!].uid
        present(navVc, animated: true, completion: nil)
       
    }
    
    
    @IBAction func addFeed(_ sender: AnyObject) {
        
        FIRAnalytics.logEvent(withName: "addFeed", parameters:
           [kFIRParameterContentType:"cont" as NSObject,
            kFIRParameterItemID:"1" as NSObject]

        )
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "postViewController") as! UITableViewController
        
        
        self.present(vc, animated: true, completion: nil)
        
        

    }
    func logout() {
        if FIRAuth.auth()?.currentUser != nil {
            try! FIRAuth.auth()!.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navLogin = storyboard.instantiateViewController(withIdentifier: "loginNavigation") as! UINavigationController
            let vc = navLogin.viewControllers[0]
            //present(vc, animated: true, completion: nil)
            present(vc, animated: true, completion: nil)
            
        }

    }
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        self.logout()
    }
    
    func chatAlert(sender: UITapGestureRecognizer) {
//        let alert = UIAlertController(title: NSLocalizedString("Opções", comment: "title for alert for choose options"), message: NSLocalizedString("Escolha a opção desejada", comment: "message indicating to choose the right option"), preferredStyle: .actionSheet)
//        let action = UIAlertAction(title: NSLocalizedString("Conversar Com ", comment: "Message that make the chat between two users"), style: .default, handler: { (action) in
//            
//            let tapLocation = sender.location(in: self.tableView)
//            var indexPath = self.tableView.indexPathForRow(at: tapLocation)
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//            let navVc = sb.instantiateViewController(withIdentifier: "chatNav") as! UINavigationController
//            let vc = navVc.viewControllers[0] as! ChatViewControllerInt
//            vc.reciverUid = self.posts[(indexPath?.row)!].uid
//            vc.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName!
//            vc.senderId = FIRAuth.auth()?.currentUser?.uid
//            self.present(navVc, animated: true, completion: nil)
//
//        })
//        
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
        
        let tapLocation = sender.location(in: self.tableView)
        var indexPath = self.tableView.indexPathForRow(at: tapLocation)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let navVc = sb.instantiateViewController(withIdentifier: "chatNav") as! UINavigationController
        let vc = navVc.viewControllers[0] as! ChatViewControllerInt
        vc.reciverUid = self.posts[(indexPath?.row)!].uid
        vc.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName!
        vc.senderId = FIRAuth.auth()?.currentUser?.uid
        self.present(navVc, animated: true, completion: nil)

    }


}




extension MainViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}


extension MainViewController:UITableViewDataSource {
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainTableViewCell
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.callPerfilView(sender:)))
        let longPress = UITapGestureRecognizer(target: self, action: #selector(self.chatAlert(sender:)))

        
        cell.userImage.image = #imageLiteral(resourceName: "profile")
        
        let uid = posts[indexPath.row].uid!
        services.loadUserImage(uid: uid) { (data) in
            if data != nil {
                let image = UIImage(data: data!)
                cell.userImage.image = image
            }else {
                cell.userImage.image = #imageLiteral(resourceName: "profile")
            }
            
        }
        longPress.numberOfTapsRequired = 1
        tap.numberOfTapsRequired = 1
        cell.userNameLbl.addGestureRecognizer(tap)
        cell.userImage.addGestureRecognizer(tap)


        cell.descriptionLbl.text = posts[indexPath.row].body
        cell.userNameLbl.text = posts[indexPath.row].author
        let title = posts[indexPath.row].title
        //title Label
        cell.titleLbl.text = title.uppercased()
        cell.titleLbl.font = UIFont(name: "OstrichSans-Heavy", size: 25)
        cell.titleLbl.textColor = UIColor(colorLiteralRed: 23/255, green: 178/255, blue: 138/255, alpha: 1)
        
        //Name label
        cell.userNameLbl.font = UIFont(name: "Lato-Medium", size: 13)
        cell.userNameLbl.textColor = UIColor(colorLiteralRed: 213/255, green: 13/255, blue: 76/255, alpha: 1)
    
    
        //description text
        cell.descriptionLbl.font = UIFont(name:"Lato-Regular", size: 18)
        
        let postDistance = CLLocation(latitude: Double(posts[indexPath.row].latitude!)!, longitude: Double(posts[indexPath.row].longitude!)!)
        
        if self.location == nil {
            cell.distanceLbl.text = NSLocalizedString("0.0 Km de Você", comment: "Standard message from location nil")
        }else {
            let postDistanceFromUser = (postDistance.distance(from: self.location)) / 1000
            cell.distanceLbl.text = String(format: "%.1f Km de Você", postDistanceFromUser)


        }
        
        
        cell.backgroundColor = UIColor.clear

    
        
        return cell
    }
}

extension MainViewController: PostView {
    func startLoading() {
        print("STARTED")
    }
    func finishLoading() {
        print("FINISHED")
    }
    func setEmptyPosts() {
        //TODO
    }
    func setPost(_ post: [Post]) {
        self.posts.removeAll()
        self.posts = post
        self.tableView.reloadData()
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("MAIN VIEW CONTROLLER: location Fail with error \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last
    }
    
    func setLocationManager () {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

