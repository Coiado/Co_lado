//
//  TestimonyContainerViewController.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 17/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit

class TestimonyContainerViewController: UIViewController {
    //property
    ///user id for testimony target
    var uid: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("TestimonyContainerViewController: THE UID IS \(self.uid)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)

    }
    
    @IBAction func buttomPressed(_ sender: AnyObject) {
        print("TESTIMONY CONTAINER: button save pressed")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "buttomSaveTPressed"), object: nil)

    }

    @IBAction func cancelButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "testimonySegue" {
            let testimonyController = segue.destination as! TestimonyTableViewController
            testimonyController.uid = uid
        }
    }
    
    
    
    
    

}
