//
//  Report.swift
//  FinalChallenge
//
//  Created by Lucas Coiado Mota on 10/17/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation

class Report: NSObject {
    var reporterUID: String
    var postID: String
    var userReportedUID: String
    
    init(reporterUID:String, postID:String, userReportedUID: String){
        self.reporterUID = reporterUID
        self.postID = postID
        self.userReportedUID = userReportedUID
    }
    
}
