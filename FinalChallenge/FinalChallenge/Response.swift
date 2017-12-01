//
//  Response.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 23/09/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation

class Response {
    var id: String?
    var message: String!
    var post: String!
    var author: String!
    var authorId: String!
    var authorEmail: String!
    
    init (id:String, message:String, post:String, author: String, authorId: String) {
        self.id = id
        self.message = message
        self.post = post
        self.author = author
        self.authorId = authorId
        
    }
    
    init (id:String, message:String, post:String, author: String, authorId: String, authorEmail: String) {
        self.id = id
        self.message = message
        self.post = post
        self.author = author
        self.authorId = authorId
        self.authorEmail = authorEmail
    }

    
    
    init (message:String, post: String, author: String, authorId: String) {
        self.message = message
        self.post = post
        self.author = author
        self.authorId = authorId
    }
    
    
    init (message:String, post: String, author: String, authorId: String, authorEmail: String) {
        self.message = message
        self.post = post
        self.author = author
        self.authorId = authorId
        self.authorEmail = authorEmail
    }

    
}
