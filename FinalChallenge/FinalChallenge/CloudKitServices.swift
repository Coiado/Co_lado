//
//  CloudKitServices.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 09/11/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitSerices {
    let container: CKContainer!
    let publicDB: CKDatabase!
    let privateDB:CKDatabase!
    
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    func queryForChat(uid: String) {
        
        let predicate = NSPredicate(format: "uid == @", uid)
        let query = CKQuery(recordType: "ChatSender", predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
            if error == nil {
                
                if records == nil {
                    print("iCLOUD SERVICES: theres no records")
                }else {
                    print("iCLOUD SERVICES: there is a record \(records?[0])")
                }

            } else {
                
                print("iCLOUD SERVICES:\(error?.localizedDescription)")
            }
        })
        
        
        
    }
    
    
    func saveNewConversation(uid:String, userName: String) {
        let record = CKRecord(recordType: "ChatSender")
        record["uid"] = uid as CKRecordValue?
        record["userName"] = userName as CKRecordValue?
        publicDB.save(record, completionHandler: { (record, error) in
            
            if error == nil {
                
            }
            
        })
        
    }
}
