//
//  ChatMessage.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 05/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation


class ChatMessage {
    var userName: String?
    var timeStamp: String?
    var message: String?
    var uid: String?
    var toUser: String?
    
    init(uid: String, userName: String, message: String, timeStamp: String ){
        self.uid = uid
        self.userName = userName
        self.message = message
        self.timeStamp = timeStamp
    }
    
    init(uid: String, userName: String, message: String, timeStamp: String, toUser:String ){
        self.uid = uid
        self.userName = userName
        self.message = message
        self.timeStamp = timeStamp
        self.toUser = toUser
    }
    
    init(uid: String, userName: String) {
        self.uid = uid
        self.userName = userName
    }
    
    
}

