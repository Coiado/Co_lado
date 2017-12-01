//
//  Testimony.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 10/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation

class Testimony {
    var testimonyId: String?
    var testimonyAuthor: String!
    var testimonyTitle: String!
    var testimonyMessage: String!
    var testimonyEvaluation: String!
    var testimonyAuthorImage: NSData?
    var testimonyAuthorUid: String!
    var testimonyTargetUid: String!
    
    init(testimonyAuthor: String, testimonyTitle: String, testimonyMessage: String, testimonyEvaluation: String, testimonyAuthorImage: NSData, testimonyAuthorUid: String, testimonyTargetUid: String) {
        self.testimonyAuthor = testimonyAuthor
        self.testimonyTitle = testimonyTitle
        self.testimonyMessage = testimonyMessage
        self.testimonyEvaluation = testimonyEvaluation
        self.testimonyAuthorImage = testimonyAuthorImage
        self.testimonyAuthorUid = testimonyAuthorUid
        self.testimonyTargetUid = testimonyTargetUid
    }
    
    init(testimonyid: String, testimonyAuthor: String, testimonyTitle: String, testimonyMessage: String, testimonyEvaluation: String, testimonyAuthorImage: NSData, testimonyAuthorUid: String, testimonyTargetUid: String) {
        self.testimonyId = testimonyid
        self.testimonyAuthor = testimonyAuthor
        self.testimonyTitle = testimonyTitle
        self.testimonyMessage = testimonyMessage
        self.testimonyEvaluation = testimonyEvaluation
        self.testimonyAuthorImage = testimonyAuthorImage
        self.testimonyAuthorUid = testimonyAuthorUid
        self.testimonyTargetUid = testimonyTargetUid

    }
    
    
    init(testimonyAuthor: String, testimonyTitle: String, testimonyMessage: String, testimonyEvaluation: String, testimonyAuthorUid: String, testimonyTargetUid: String) {
        self.testimonyAuthor = testimonyAuthor
        self.testimonyTitle = testimonyTitle
        self.testimonyMessage = testimonyMessage
        self.testimonyEvaluation = testimonyEvaluation
        self.testimonyAuthorUid = testimonyAuthorUid
        self.testimonyTargetUid = testimonyTargetUid
    }
    
    init(id: String, testimonyAuthor: String, testimonyTitle: String, testimonyMessage: String, testimonyEvaluation: String, testimonyAuthorUid: String, testimonyTargetUid: String) {
        self.testimonyId = id
        self.testimonyAuthor = testimonyAuthor
        self.testimonyTitle = testimonyTitle
        self.testimonyMessage = testimonyMessage
        self.testimonyEvaluation = testimonyEvaluation
        self.testimonyAuthorUid = testimonyAuthorUid
        self.testimonyTargetUid = testimonyTargetUid
    }

    

}
