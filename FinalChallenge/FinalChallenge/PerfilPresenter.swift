//
//  PerfilPresenter.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 10/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation


class PerfilPresenter {
    
    //properties
    weak var perfilViewController: PerfilViewController?
    weak var myPerfilViewController: MyPerfilViewController?
    let services = Services()
    
    var userPosts = [Post]()
    var testimonies=[Testimony]()

    
    
    
    func attachView (view: PerfilViewController) {
        self.perfilViewController = view
    }
    
    func attachView(view: MyPerfilViewController) {
        self.myPerfilViewController = view
    }
    
    func deattachView () {
        self.perfilViewController = nil
    }
    
    func loadUserInfo () {
    }
    
    func setUserInfo () {
        
    }
    
    func loadUserTestTestimony (uid: String) {
        
    }
    
    func loadUserRequests (uid: String) {
        self.userPosts.removeAll()
        services.loadUserFeed(uid: uid) { (snapshot) in
            if snapshot.exists() {
                let dic = snapshot.value as! [String : AnyObject]
                let postsKey = Array(dic.keys)
                
                for key in postsKey {
        
                    
                    let post = Post(id: key,
                                    author: dic[key]?.value(forKey: "author") as! String,
                                    title: dic[key]?.value(forKey: "title") as! String,
                                    body: dic[key]?.value(forKey: "body") as! String,
                                    tags: dic[key]?.value(forKey: "tags") as! String,
                                    location: dic[key]?.value(forKey: "location") as! String,
                                    duration: dic[key]?.value(forKey: "duration") as! String,
                                    latitude: dic[key]?.value(forKey: "latitude") as! String,
                                    longitude: dic[key]?.value(forKey: "longitude") as! String,
                                    uid: dic[key]?.value(forKey: "uid") as! String,
                                    userEmail: dic[key]?.value(forKey: "userEmail") as! String,
                                    timestamp: dic[key]?.value(forKey: "timestamp") as! String)
                    
                    self.userPosts.append(post)
                    
                }
                
                self.myPerfilViewController?.loadRequestInfo(requests: self.userPosts)
                self.perfilViewController?.loadRequestInfo(requests: self.userPosts)
                
            }
        }
        
    }
    
    func loadUserRequest (uid: String) {
        
        services.loadUserInfo(uid: uid) { (snapshot) in
            if snapshot.exists() {
                let dic = snapshot.value as? NSDictionary
                //print(dic)
                let user = User(username: dic?["nickname"] as! String, location: dic?["location"] as! String, reputation: dic?["evaluation"] as! NSNumber)
                
                self.perfilViewController?.setUserInformation(user: user)
                self.myPerfilViewController?.setUserInformation(user: user)
        
            
            }else {
                print("PERFIL PRESENTER: User information does not exist")
            }
        }
    }
    
    
    func loadTestimony( uid: String) {
        self.testimonies.removeAll()
        services.loadUserTestimony(uid: uid) { (snapshot) in
            if snapshot.exists() {
                print("SERVICES: (LOADING ALL THE TESTIMONIES) \(snapshot)")
                var dic =  snapshot.value as! [String : AnyObject]
                let index = Array(dic.keys)
                
                for key in index {
                    let testimonyArray = dic[key] as! [String : AnyObject]
                    let aIndex = Array(testimonyArray.keys)
                    
                    
                    for tKeys in aIndex {
                        
                        if testimonyArray[tKeys]?.value(forKey: "testemonyTarget") as! String == uid {
                            
                            let test =  Testimony(id: tKeys,
                                                  testimonyAuthor: testimonyArray[tKeys]?.value(forKey: "author") as! String,
                                                  testimonyTitle:  testimonyArray[tKeys]?.value(forKey: "title") as! String,
                                                  testimonyMessage:  testimonyArray[tKeys]?.value(forKey: "message") as! String,
                                                  testimonyEvaluation:  testimonyArray[tKeys]?.value(forKey: "evaluation") as! String,
                                                  testimonyAuthorUid:  testimonyArray[tKeys]?.value(forKey: "authorID") as! String,
                                                  testimonyTargetUid:  testimonyArray[tKeys]?.value(forKey: "testemonyTarget") as! String)
                            
                            self.testimonies.append(test)

                        }
                        
                    }
                }
                
                self.myPerfilViewController?.loadTestimonyInfo(testimonies: self.testimonies)
                self.perfilViewController?.loadTestimonyInfo(testimonies: self.testimonies)
                
            }else {
                print("TESTIMONY PRESENTER: (LOAD USER TESTIMONY) there is no testemony registered")
            }
            
        }
        
    }

}
