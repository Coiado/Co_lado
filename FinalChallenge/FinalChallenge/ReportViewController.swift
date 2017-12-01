//
//  ReportViewController.swift
//  FinalChallenge
//
//  Created by Lucas Coiado Mota on 10/17/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    
    var viaSegue: Report!
    var services: Services = Services()
    @IBOutlet weak var reportText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = Color().backgroundStandardColor
        reportText.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reportPost(_ sender: AnyObject) {
        //services.report(reporterUID: viaSegue.reporterUID , postID: viaSegue.postID, userReportedUID: viaSegue.userReportedUID, report: reportText.text)
        
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

extension ReportViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    

}
