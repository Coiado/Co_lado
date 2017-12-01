//
//  User.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 29/08/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    var username: String
    var mail: String?
    var phone: String?
    var location: String?
    var password: String?
    var userImage: NSData?
    var userReputation: NSNumber?
    
    init(username:String, mail:String, phone: String, location: String, password: String ){
        self.username = username
        self.location = location
        self.mail = mail
        self.phone = phone
        self.password = password
    }
    
    init(username:String, mail:String, phone: String, location: String, password: String, reputation: NSNumber ){
        self.username = username
        self.location = location
        self.mail = mail
        self.phone = phone
        self.password = password
        self.userReputation = reputation
    }
    
    init (username: String, location: String, reputation: NSNumber) {
        self.username = username
        self.location = location
        self.userReputation = reputation
    }

    
    convenience override init (){
        self.init(username: "", mail: "", phone: "", location: "", password: "")
    }
}
