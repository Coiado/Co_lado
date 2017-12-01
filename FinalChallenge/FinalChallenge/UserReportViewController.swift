//
//  UserReportViewController.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 17/11/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit

class UserReportViewController: UIViewController {
    
    var viaSegue: Report!
    @IBOutlet weak var reportText: UITextView!
    let services = Services()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Color().standardAppleBackgroundColor
        //backgroundStandardColor
        self.reportText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveReport(reporterUID: String, postID: String, userReportedUID: String, reportText: String) {
        if viaSegue != nil {
            
            if reportText.isEmpty {
                print("Text is empty")
            }else {
                //save a new report
                services.report(reporterUID: reporterUID, postID: postID, userReportedUID: userReportedUID, report: reportText)
                //clear the text view
                self.reportText.text = ""
                
                let alert = UIAlertController(title: NSLocalizedString("Denuncia Salva", comment: "title for repost save success"), message: NSLocalizedString("Sua Denuncia foi salva e será avaliada", comment: "body for report save success"), preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction (title: NSLocalizedString("OK", comment: "OK message"), style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okAction)
                
                //show the alert
                self.present(alert, animated: true, completion: nil)
            }
            
        }else {
            
            print("Via segue is nil")
            
        }
    }
    
    
    @IBAction func sendReportButton(_ sender: Any) {
        self.saveReport(reporterUID: viaSegue.reporterUID, postID: viaSegue.postID, userReportedUID: viaSegue.userReportedUID, reportText: reportText.text)
    }

    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.reportText.resignFirstResponder()
    }
    
}

extension UserReportViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    
    
}
