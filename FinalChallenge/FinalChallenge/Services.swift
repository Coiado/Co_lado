//
//  FirebaseServices.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 31/08/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

enum ServicesError: Error {
    case empty
    case badRequest
    case `nil`
}


class Services {
    //private let ref = FIRDatabase.database().reference().child("post")
    init() {
        
    }
    
    func saveResponse(_ response:Response) {
        let ref = FIRDatabase.database().reference().child("/")
        let keys = ref.childByAutoId().key
        
        if (FIRAuth.auth()?.currentUser) != nil {
            
            let responseMessage = ["message": response.message!,
                                   "senderUser": response.author!,
                                   "senderUserId": response.authorId!,
                                   "senderEmail": response.authorEmail!]
            
            let childUpdates = ["/public/response/\(response.post!)/\(keys)": responseMessage,
                                "/private/user-response/\(response.post!)/\(keys)":responseMessage]
            
            ref.updateChildValues(childUpdates)
            
        }
        

    }
    
    
    func responseQuery (_ postId: String, completion: @escaping (FIRDataSnapshot) -> Void) {
       let ref = FIRDatabase.database().reference().child("/public")

       _ = (ref.child("/response")).queryOrdered(byChild: postId).observe(.value) { (snapshot) in
            completion(snapshot)
        }
       //print("POST \(post)")
    
    }
    
    func singUp(_ username: String, mail: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        let ref = FIRDatabase.database().reference(withPath: "private/users")
        
        FIRAuth.auth()?.createUser(withEmail: mail, password: password) { (user, error) in
            
//            if let error = error {
//                print(error.localizedDescription)
//                let alert = UIAlertController(title: NSLocalizedString("Erro", comment: "Error"), message: NSLocalizedString("Erro durante o registro", comment: "fail during the register"), preferredStyle: UIAlertControllerStyle.alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                
//                alert.addAction(okAction)
//                completion(false, error)
//                return
//            }
            
            if error != nil {
                completion(false, error!)
                return
            }
            
            
            user?.sendEmailVerification(completion: { (error) in
                if (error != nil) {
                    print("ERROR")
                    completion(false, error!)
                }else {
                    let alert = UIAlertController(title: NSLocalizedString("Email de confirmação enviado", comment: "email of confimation was sent"), message: NSLocalizedString("Email enviado para \(mail)", comment: "mail sent to"), preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    
        
                    let newUser = ref.child((user?.uid)!)
                    
                    // 4
                    newUser.setValue(["nickname": username,
                                      "provider": "Email & Password",
                                      "mail": mail,
                                      "location": "Não Localizado",
                                      "evaluation": NSNumber(value: 0.0)])
                    self.saveUserData(user!)
                    
                    //completion(alert)
                    completion(true, error)
                }
            })
//            let newUser = ref.child((user?.uid)!)
//            
//            // 4
//            newUser.setValue(["nickname": username,
//                              "provider": "Email & Password",
//                              "mail": mail,
//                              "location": "Não Localizado",
//                              "evaluation": NSNumber(value: 0.0)])
//            self.saveUserData(user!)
            
        }
    }
    
    func saveUserData(_ user: FIRUser) {
        
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email!.components(separatedBy: "@")[0]
        changeRequest.commitChanges(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
        }
    }
    
    func savePost(_ post: Post){
        let ref = FIRDatabase.database().reference().child("/")
        let keys = ref.childByAutoId().key
        //let postRef = ref.childByAutoId()
        
        
        if let user = FIRAuth.auth()?.currentUser {
            
            let post = [
                "title": post.title,
                "author": post.author,
                "body": post.body,
                "tags": post.tags,
                "location": post.location,
                "duration": post.duration,
                "latitude": post.latitude!,
                "longitude": post.longitude!,
                "uid": user.uid,
                "userEmail": user.email!,
                "timestamp" : Date().iso8601]
            
            let childUpdates = ["/public/post/\(keys)": post,
                                "/private/user-posts/\(user.uid)/\(keys)": post]
            ref.updateChildValues(childUpdates)
            
        }else {
            
            print("SERVICES: there's no user logged in")
        }
        
        
//        postRef.setValue([
//            "title": post.title,
//            "author": post.author,
//            "body": post.body,
//            "tags": post.tags,
//            "location": post.location,
//            "duration": post.duration])
//        print("SALVOU")
    }
    
    func report(reporterUID: String!, postID: String!, userReportedUID: String!, report: String!){
        
        if (FIRAuth.auth()?.currentUser) != nil {
            
            let ref = FIRDatabase.database().reference().child("/")
            
            let reportJSON = ["reporterID": reporterUID!,
                              "postID": postID!,
                              "userReportedUID": userReportedUID!,
                              "report": report!]
            
            let childUpdates = ["/private/reports/\(postID!)": reportJSON]
            
            ref.updateChildValues(childUpdates)
            
        }
        
    }

    
    func loadUserFeed (uid: String, completion:@escaping(FIRDataSnapshot)-> Void) {
        let ref = FIRDatabase.database().reference().child("/")
        let userPostRef = ref.child("private").child("user-posts").child(uid)
        userPostRef.observe(.value) { (snapshot) in
            completion(snapshot)
        }
    
        
    }
    
    
    func loadAllFeed(_ completion:@escaping (FIRDataSnapshot, ServicesError)->Void){
        let ref = FIRDatabase.database().reference().child("/public/post")
        
        _ = ref.observe(FIRDataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
                let error = ServicesError.nil
                completion(snapshot, error)
            }else {
                let error = ServicesError.empty
                completion(snapshot, error)
            }
            
        })
    
    }
    
    func saveUserImage (uid: String, data: Data?) {
        let ref = FIRStorage.storage().reference().child("users")
        let storageReference = ref.child(uid)
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        _ = storageReference.put(data! as Data, metadata: metadata) { (metadata, error) in
            if error != nil {
                print("UPLOAD IMAGE: error during user image upload \(error)")
                
            }else {
                print("USER IMAGE FILE DOWNLOAD URL: \(metadata!.downloadURL)")
            }
        }

        
        
    }
    
    func loadUserImage (uid: String, completion:@escaping(Data?)->Void) {
        let ref = FIRStorage.storage().reference().child("users")
        
        let userRef = ref.child(uid)
        
        userRef.data(withMaxSize: 2 * 1024 * 1024) { (data, error) in
            if error == nil {
                completion(data)
            } else {
                print("SERVICE: Load user image error \(error?.localizedDescription)")
            }
        }
        
    }
    
    
    func loadUserTestimony (uid: String, completion:@escaping (FIRDataSnapshot)->Void) {
        let ref = FIRDatabase.database().reference().child("/public/testimony")
        
        let testimonyQuery = ref.queryOrdered(byChild: uid)
        
        testimonyQuery.observe(.value) { (snapshot) in
            completion(snapshot)
        }
    }
    
    func saveTestimony (newTestmony: Testimony){
        let ref = FIRDatabase.database().reference().child("/")
        let key = ref.childByAutoId().key
        self.loadUserTestimony(uid: newTestmony.testimonyTargetUid) { (snapshot) in
            if snapshot.exists() {
                print("SERVICES: (LOADING ALL THE TESTIMONIES) \(snapshot)")
                var dic =  snapshot.value as! [String : AnyObject]
                let index = Array(dic.keys)
                var eval = 0.0
                
                for key in index {
                    let testimonyArray = dic[key] as! [String : AnyObject]
                    let aIndex = Array(testimonyArray.keys)
                    for tKeys in aIndex {
                        
                        if testimonyArray[tKeys]?.value(forKey: "testemonyTarget") as! String == newTestmony.testimonyTargetUid{
                            
                            if let evalString = testimonyArray[tKeys]?.value(forKey: "evaluation") as? NSString {
                                eval += ((evalString as NSString).doubleValue)
                                print("EXECUTOU ESTE")
                                
                            }else {
                                eval = (newTestmony.testimonyEvaluation as NSString).doubleValue
                                ref.child("private").child("users").child(newTestmony.testimonyTargetUid!).child("evaluation").setValue(eval)
                                print("EXECUTOU O OUTRO")
                                
                            }
                            
                        }
                        
                    }
                    eval = eval / Double(testimonyArray.count)
                }
            
                ref.child("private").child("users").child(newTestmony.testimonyTargetUid!).child("evaluation").setValue(eval)

                
                print("THE EVALUATION IS \(eval)")
            }else {
                print("SERVICES: (LOAD USER TESTIMONY) there is no testemony registered")
            }
            
        }
        
        
        let testimony = [
            "title" : newTestmony.testimonyTitle!,
            "author": newTestmony.testimonyAuthor!,
            "evaluation": newTestmony.testimonyEvaluation!,
            "message": newTestmony.testimonyMessage!,
            "testemonyTarget": newTestmony.testimonyTargetUid!,
            "authorID": newTestmony.testimonyAuthorUid!
        ]
        
        let childUpdates = ["/public/testimony/\(newTestmony.testimonyTargetUid!)/\(key)": testimony,
                            "/private/user-testimony/\(newTestmony.testimonyAuthorUid!)/\(key)": testimony]
        
        
        ref.updateChildValues(childUpdates)
        
        
        
        
    }
    
    
    func loadUserInfo (uid: String, completion:@escaping(FIRDataSnapshot) -> Void) {
        let ref = FIRDatabase.database().reference().child("/")
        
        let query = ref.child("private").child("users").child(uid)
        
        query.observe(.value) { (snapshot) in
            completion(snapshot)
        }
        
    }
    
    func saveNewChatInvite(uid:String, userName: String, senderUid: String) {
        let ref = FIRDatabase.database().reference().child("/")
        let keys = ref.childByAutoId().key
        
        if let user = FIRAuth.auth()?.currentUser {
            
            
            let invite = [
                "senderUid": senderUid,
                "userName": userName
            ]
            
            let childUpdates = ["/private/user-chats/\(uid)/\(keys)": invite]
            ref.updateChildValues(childUpdates)
            
        }else {
            
            print("SERVICES: there's no user logged in")
        }

    }
    
    func chatsActiveChats(uid: String, userName: String, completion: @escaping(FIRDataSnapshot) -> Void) {
        let ref = FIRDatabase.database().reference().child("/")
        
        let query = ref.child("private").child("user-chats").child(uid)
        
        query.observe(.value, with: {(snapshot) in
            completion(snapshot)
        })
    }
    

    
    
    
    
    

    
}
