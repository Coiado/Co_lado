//
//  GroupComment.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 12/08/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import Firebase 
import FirebaseDatabase

class GroupComment {
    
    //let key: String!
//    let name: String!
//    let addedByUser: String!
//    let ref: FIRDatabase?
//    var completed: Bool!

    
    let id: String!
    let message:String!
    
    init (id:String, message:String) {
        self.id = id
        self.message = message
    }
    
//    init(snapshot: FIRDataSnapshot) {
//        //key = snapshot.key
//        message = snapshot.value!["name"] as! String
//        //addedByUser = snapshot.value!["addedByUser"] as! String
//        //completed = snapshot.value!["completed"] as! Bool
//        id = snapshot.value!["id"] as! String
//    
//    }
//    
//    func toAnyObject() -> AnyObject {
//        return ["name": message, "id":id]
//    }
}
