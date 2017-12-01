//
//  Post.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 29/08/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation

class Post: NSObject {
    var id: String?
    var author: String
    var title: String
    var body: String
    var tags: String
    var location: String
    var duration: String
    var latitude: String?
    var longitude: String?
    var uid: String?
    var userEmail: String?
    var timestamp: String?
    
    init(author: String, title:String, body: String, tags: String, location: String, duration: String) {
        self.author = author
        self.title = title
        self.body = body
        self.tags = tags
        self.location = location
        self.duration = duration
    }
    
    init(author: String, title:String, body: String, tags: String, location: String, duration: String, latitude: String, longitude: String) {
        self.author = author
        self.title = title
        self.body = body
        self.tags = tags
        self.location = location
        self.duration = duration
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(author: String, title:String, body: String, tags: String, location: String, duration: String, latitude: String, longitude: String, uid: String, userEmail: String, timestamp: String) {
        self.author = author
        self.title = title
        self.body = body
        self.tags = tags
        self.location = location
        self.duration = duration
        self.latitude = latitude
        self.longitude = longitude
        self.uid = uid
        self.userEmail = userEmail
        self.timestamp = timestamp
    }

    
    init(id: String, author: String, title:String, body: String, tags: String, location: String, duration: String, latitude: String, longitude: String) {
        self.id = id
        self.author = author
        self.title = title
        self.body = body
        self.tags = tags
        self.location = location
        self.duration = duration
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(id: String, author: String, title:String, body: String, tags: String, location: String, duration: String, latitude: String, longitude: String, uid: String, userEmail: String, timestamp: String) {
        self.id = id
        self.author = author
        self.title = title
        self.body = body
        self.tags = tags
        self.location = location
        self.duration = duration
        self.latitude = latitude
        self.longitude = longitude
        self.uid = uid
        self.userEmail = userEmail
        self.timestamp = timestamp
    }


    
    
    
    convenience override init() {
        self.init(author: "", title:"", body: "", tags: "", location: "", duration: "")
    }
    
    
}
