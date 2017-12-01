//
//  ConfigurationViewController.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 13/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ConfigurationViewController: UIViewController {
    //outlets
    @IBOutlet weak var tableView: UITableView!
    let fbLoginManager = FBSDKLoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.backgroundColor = Color().backgroundStandardColor
        self.tableView.backgroundColor = Color().backgroundStandardColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func firebaseLogout () {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let loginNC = sb.instantiateViewController(withIdentifier: "firstViewNav") as! UINavigationController
                self.present(loginNC, animated: true, completion: nil)
                
            } catch {
                print("CONFIG CONTROLLER: It was impossible to signout from sistem")
            }
            
        }
    }

}

extension ConfigurationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            if FBSDKAccessToken.current() != nil {
                fbLoginManager.logOut()
                self.firebaseLogout()
            }else {
                self.firebaseLogout()
            }
            
        }else {
            //UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
            UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: { (success) in
                if success {
                    print("CONFIGURATION: OPEN SETTINGS")
                }else {
                    print("CONFIGURATION: SOMETHING GONE WRONG")
                }
            })
        }
    }
    
}

extension ConfigurationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.backgroundColor = Color().backgroundStandardColor
        
        if indexPath.row == 0 {
            cell?.textLabel?.text = "Localização"
        }else {
            cell?.textLabel?.text = "Sair"

        }
        return cell!
        
    }
}
