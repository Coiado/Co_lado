//
//  TutorialViewController.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 28/11/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var messageLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didChangeIndex(_ sender: Any) {
        self.messageLbl.text = "\(self.pageControl.currentPage)"
    }
    


}
