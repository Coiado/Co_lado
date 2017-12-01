//
//  FeedPresenter.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 31/08/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase



protocol PostView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setPost(_ users: [Post])
    func setEmptyPosts()
}
class PostPresenter {
    //var properties
    let services = Services()
    weak var postTableViewController:PostTableViewController?
    
    
    //var delegate
    //weak private var postTableViewController: PostTableViewController?
    
    
    init (viewController: PostTableViewController){
        self.postTableViewController = viewController
    }
    
    func attachView(_ postView: PostTableViewController){
        self.postTableViewController = postView
    }
    
    func detachView() {
        self.postTableViewController = nil
    }
    
    func savePost() {
//        self.services.savePost(Post(id: "2", author: "EU", title: "Titutlo teste", body: "MENSAGEM DE TESTE PARA CARREGAMENTO NO BANCO", tags: "#CATEGORIA TESTE", location: "CAMPINAS", duration: "1 SEMANA"))
//        self.services.savePost(Post(id: "1" ,
//            author: "EU",
//            title: (postTableViewController?.titleTextField.text)!,
//            body: (postTableViewController?.msgTextField.text)!,
//            tags: (postTableViewController?.tagTextField.text)!,
//            location: (postTableViewController?.locationTextField.text)!,
//            duration: (postTableViewController?.durationTextField.text)!
//            ))
        
        print("SAVED")
        
    }
    
    func saveNewPost(_ title:String, body: String, tags: String, location: String, duration:String, latitude: String, longitude: String) {
        let date = NSDate()
        
        if let user = FIRAuth.auth()?.currentUser {
            self.services.savePost(Post(
                author: user.displayName!,
                title: title,
                body: body,
                tags: tags,
                location: location,
                duration: duration,
                latitude: latitude,
                longitude: longitude,
                uid: user.uid,
                userEmail: user.email!,
                timestamp: "\(date)"))

    
            print("NEW POST SAVED")
        } else {
            // No user is signed in.
            print("There is no user connected")
            print("FAIL")
        }

        
    }
    
    func valuesToSave(_ post: PostProtocol) {
        print("alo \(post.save())")
    }
}
