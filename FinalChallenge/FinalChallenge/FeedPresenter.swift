//
//  FeedPresenter.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 01/09/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import Firebase

protocol postView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setPosts(_ users: [Post])
    func setEmptyPosts()
}



class FeedPresenter {
    //properties
    let services = Services()
    var posts = [Post]()
    weak fileprivate var feedTableView: MainViewController!
    
    let totalPosts = [Post]()
    
    func attachView(_ view:MainViewController){
        feedTableView = view
    }
    
    
    func detachView() {
        feedTableView = nil
    }
    
 
    
    func loadFeed(){
        self.posts.removeAll()
        services.loadAllFeed { (snapshot, error) in
            
            if error == ServicesError.nil {
                let rawPosts = snapshot.value as! [String : AnyObject]
                let postsKey = Array(rawPosts.keys)
                
                for key in postsKey {
//                    self.posts.append(
//                        Post(
//                            id: key,
//                            author: rawPosts[key]?.value(forKey:"author") as! String,
//                            title: rawPosts[key]?.value(forKey: "title") as! String,
//                            body: rawPosts[key]?.value(forKey:"body") as! String,
//                            tags: rawPosts[key]?.value(forKey:"tags") as! String,
//                            location: rawPosts[key]?.value(forKey:"location") as! String,
//                            duration: rawPosts[key]?.value(forKey:"duration") as! String)
//                    )
                    self.posts.append(Post(id: key,
                                           author: rawPosts[key]?.value(forKey: "author") as! String,
                                           title: rawPosts[key]?.value(forKey: "title") as! String,
                                           body: rawPosts[key]?.value(forKey: "body") as! String,
                                           tags: rawPosts[key]?.value(forKey: "tags") as! String,
                                           location: rawPosts[key]?.value(forKey: "location") as! String,
                                           duration: rawPosts[key]?.value(forKey: "duration") as! String,
                                           latitude: rawPosts[key]?.value(forKey: "latitude") as! String,
                                           longitude: rawPosts[key]?.value(forKey: "longitude") as! String,
                                           uid: rawPosts[key]?.value(forKey: "uid") as! String,
                                           userEmail: rawPosts[key]?.value(forKey: "userEmail") as! String,
                                           timestamp: rawPosts[key]?.value(forKey: "timestamp") as! String)
                    )
                }
                
                //print("POST DUDE: \(self.posts)")
                self.feedTableView.setPost(self.posts)
                self.feedTableView.finishLoading()

            }else {
                print("VAZIO")
            }
        }
    }
    

    
    
    
    
    
}
