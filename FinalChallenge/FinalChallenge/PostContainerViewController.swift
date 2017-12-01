//
//  PostContainerViewController.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 22/08/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit

protocol PostViewControllerDelegate {
    func savePostOnFacebook()
}
class PostContainerViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(buttomPressed), name: NSNotification.Name(rawValue: "buttomSavePressed"), object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func savePost(sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "buttomSavePressed"), object: nil)
    }
    
    func buttomPressed() {
        print("Buttom was pressed")
    }

    
    

}
