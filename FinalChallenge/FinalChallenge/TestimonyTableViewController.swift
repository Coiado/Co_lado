//
//  TestemonyTableViewController.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 17/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import Cosmos
import Firebase

class TestimonyTableViewController: UITableViewController {

    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    
    var uid: String!
    var evaluation: Double!
    let presenter = TestimonyPresenter()
    
    let service = Services()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        cosmosView.settings.fillMode = .half
        
        cosmosView.didFinishTouchingCosmos = {rating in
            print(rating)
            self.evaluation = rating
        }
        
        //uid = FIRAuth.auth()?.currentUser?.uid
        self.textView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: NSNotification.Name(rawValue: "buttomSaveTPressed"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func save () {
        
        if let user = FIRAuth.auth()?.currentUser {
            if !(titleTextBox.text?.isEmpty)! {
                if !textView.text.isEmpty {
                    if self.evaluation != nil {
                        presenter.saveTestmony(idTarget: uid!, userId: user.uid, userName: user.displayName!, title: titleTextBox.text!, message: textView.text, evaluation: "\(self.evaluation!)")
                    }else {
                        presenter.saveTestmony(idTarget: uid, userId: user.uid, userName: user.displayName!, title: titleTextBox.text!, message: textView.text, evaluation: "0")
                    }
                }else {
                    print("TESTIMONY CONTROLLER: text view is empty")
                    let alert  = UIAlertController(title: NSLocalizedString("Campo vazio", comment: "empty field"), message: NSLocalizedString("Todos os campos devem ser preenchidos", comment: "all the fields must be fiiled"), preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }else {
                print("TESTIMONY CONTROLLER: title text box is empty")
                print("TESTIMONY CONTROLLER: text view is empty")
                let alert  = UIAlertController(title: NSLocalizedString("Campo vazio", comment: "empty field"), message: NSLocalizedString("Todos os campos devem ser preenchidos", comment: "all the fields must be fiiled"), preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let alert  = UIAlertController(title: NSLocalizedString("Depoimento salvo", comment: "Testimony saved"), message: NSLocalizedString("Depoimento salvo com sucesso", comment: "Testimony saved with success"), preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }



}

extension TestimonyTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
