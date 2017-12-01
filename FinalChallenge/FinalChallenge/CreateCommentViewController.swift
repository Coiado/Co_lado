//
//  CreateCommentViewController.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 24/08/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit

class CreateCommentViewController: UIViewController {
    
    var postId:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(pressed), name: NSNotification.Name(rawValue: "buttomSavedPressed"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)

    }
    
    
    @IBAction func buttonSavePressed(sender: AnyObject) {
        print("UHULL")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "buttomSavedPressed"), object: nil)
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableComment" {
            let destinationVC = segue.destination as! CreateCommentTableViewController
            destinationVC.postId = self.postId
        }
    }
    

    func pressed(){
        print("OLA COMMENT")
    }


}
