//
//  PostDetailPresenter.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 22/09/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation

//This protocol makes possible to link the view and Presenter
protocol PostDetail {
    func startLoading()
    func finishLoading()
    func setEmptyCommentary()
    func setCommentary(_ response:[Response])
}


class PostDetailPresenter {
   
    //properties
    weak fileprivate var postDetail: PostDetailViewController!
    let services = Services()
    var response = [Response]()
    
    
    //MARK: - Link with the view
    func attachView (_ view: PostDetailViewController) {
        postDetail = view
    }
    
    func deattachView () {
        postDetail = nil
    }
    
    
    //MARK: - save the comment
    func saveCommentSave (_ message:String, post:String, author: String, authorId: String, authorEmail: String){
        let response = Response(message: message, post: post, author: author, authorId: authorId, authorEmail: authorEmail)
        services.saveResponse(response)
        
    }
    
    func saveStandardHelpResponse(post:String, author: String, authorId: String, authorEmail: String) {
        let response = Response(message: "Posso ajudar", post: post, author: author, authorId: authorId, authorEmail: authorEmail)
        services.saveResponse(response)
    }
    
    //MARK: - Comment Load
    fileprivate func loadAllComments(_ postId: String, completionHendler: @escaping ([Response]) -> Void) {
        services.responseQuery(postId) { (snapshot) in
            
            if snapshot.exists() {
                self.response.removeAll()
                let rawData = snapshot.value as! [String: [String:AnyObject]]
                let postKey = Array(rawData.keys)
                
                for key in postKey {
                    if key == postId {
                        let rawComments = rawData[key]!
                        let rawKey = Array(rawComments.keys)
                        for commentKey in rawKey {
                            
                            self.response.append(Response(id: commentKey,
                                                          message: rawComments[commentKey]?.value(forKey: "message") as! String,
                                                          post: postId,
                                                          author: rawComments[commentKey]?.value(forKey: "senderUser") as! String,
                                                          authorId: rawComments[commentKey]?.value(forKey: "senderUserId") as! String)
                            )
                            
                        }
                        
                    }
                }
                completionHendler(self.response)
                
            }
        }
    }
    
    
    
    
    //MARK: - View preparation
    func setView(_ postId:String){
        self.loadAllComments(postId) { (response)  in
            if self.postDetail != nil {
                self.postDetail!.setCommentary(response)
            }else {
                print("POST DETAIL PRESENTER: post view is nil")
            }
        }
    }
    
    
    
    
    
}


