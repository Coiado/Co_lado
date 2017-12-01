//
//  TestimonyPresenter.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 18/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation

class TestimonyPresenter {
    
    //properties
    weak var testimonyController: TestimonyTableViewController!
    let services = Services()
    
    func attach (view: TestimonyTableViewController) {
        self.testimonyController = view
    }
    
    func deattach () {
        self.testimonyController = nil
    }
    
    
    func saveTestmony (idTarget: String, userId: String, userName: String, title: String, message: String, evaluation: String) {
        
        let testomony = Testimony(testimonyAuthor: userName, testimonyTitle: title, testimonyMessage: message, testimonyEvaluation: evaluation, testimonyAuthorUid: userId, testimonyTargetUid: idTarget)
        
        services.saveTestimony(newTestmony: testomony)
    }
    
    
    
    
}
