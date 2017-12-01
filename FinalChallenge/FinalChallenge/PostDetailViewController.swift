//
//  PostDetailViewController.swift
//  FinalChallenge MVP
//
//  Created by Evandro Henrique Couto de Paula on 16/08/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FirebaseAuth

class PostDetailViewController: UIViewController {
    //properties
    var post: Post!
    var comments = [Post]()
    var services: Services!
    var authUser: FIRUser!
    var postComments = [Response]()
    var report: Report!
    
    let labelGreenColor = UIColor(colorLiteralRed: 23/255, green: 178/255, blue: 138/255, alpha: 1)
    
    let presenter = PostDetailPresenter()
    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var responseTextBox: UITextField!
    
    //Constraints outlets
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttomBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        //TODO
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //set interface
        self.tableView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor(colorLiteralRed: 254/255, green: 248/255, blue: 228/255, alpha: 1)

        
        //print("POST \(self.post.id!)")
        
        services = Services()
        
        if let user = FIRAuth.auth()?.currentUser {
            self.authUser = user
        }else {
            print("there is no user logged")
        }
        //presenter.setView(postId: self.post.id!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PostDetailViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PostDetailViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        presenter.attachView(self)
    
        
    }
    
    
    override func didReceiveMemoryWarning() {
        //TODO
    }
    

    func postOptions(sender:UIButton) {
        
        var nameUser: String!
        var postID: String!
        var userID: String!
        //var cell: UITableViewCell!
        
        if sender.tag == 0 {
            let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! PostDetailTableViewCell
            nameUser = cell.userNameLbl.text
            postID = cell.postID
            userID = cell.userUID
        } else if sender.tag >= 1 {
            let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! PostDetailCommentTableViewCell
            nameUser = postComments[sender.tag - 1].author
                //cell.userNameLbl.text
            postID = postComments[sender.tag - 1].id
                //cell.postID
            userID = postComments[sender.tag - 1].authorId
                //cell.userUID
        }
        
        
        //let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! PostDetailTableViewCell
        //let nameUser = cell.userNameLbl.text
        let popUserName = nameUser?.characters.split{$0 == " "}.map(String.init)
        let chatString = String("Conversar com \(popUserName![0])")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.view.tintColor = self.labelGreenColor
        
        let chatAction = UIAlertAction(title: chatString, style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let navVc = sb.instantiateViewController(withIdentifier: "chatNav") as! UINavigationController
            let vc = navVc.viewControllers[0] as! ChatViewControllerInt
            //vc.reciverUid = self.posts[(indexPath?.row)!].uid
            if (IndexPath(row: sender.tag, section: 0)).row == 0 {
                vc.reciverUid = self.post.uid!
                vc.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName!
                vc.senderId = FIRAuth.auth()?.currentUser?.uid
                self.present(navVc, animated: true, completion: nil)
            } else {
                vc.reciverUid = self.postComments[sender.tag - 1].authorId
                vc.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName!
                vc.senderId = FIRAuth.auth()?.currentUser?.uid
                self.present(navVc, animated: true, completion: nil)
            }
            
            print("Delete button tapped")
        })
        
        ///REMOVE TO ADD THE CHAT AGAIN
        //alertController.addAction(chatAction)
        
        let profileAction = UIAlertAction(title: "Ver Perfil", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            //print("Delete button tapped")
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let navVc = sb.instantiateViewController(withIdentifier: "perfilNav") as! UINavigationController
            let vc = navVc.topViewController as! PerfilViewController
            //vc.reciverUid = self.posts[(indexPath?.row)!].uid
            if (IndexPath(row: sender.tag, section: 0)).row == 0 {
                vc.uid = self.post.uid!
                self.present(navVc, animated: true, completion: nil)
            } else {
                vc.uid = self.postComments[sender.tag - 1].authorId
                self.present(navVc, animated: true, completion: nil)
            }

            
            
        })
        alertController.addAction(profileAction)
        
        
        let reportAction = UIAlertAction(title: "Denuncia", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
//            let postID = cell.postID
//            let userID = cell.userUID
            self.report = Report(reporterUID: (FIRAuth.auth()?.currentUser?.uid)!, postID: postID, userReportedUID: userID)
            
            self.performSegue(withIdentifier: "ReportSegue", sender: self)
            
            
        })
        alertController.addAction(reportAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        let index = tableView.indexPathForSelectedRow
    }
    
    
    //MARK: - Actions
    @IBAction func saveResponse(_ sender: AnyObject) {
        if (self.textView.text?.isEmpty)! {
            print("Response text null")
        }else {
            presenter.saveCommentSave(self.textView.text!, post: "\(self.post.id!)", author: authUser.displayName!, authorId: authUser.uid, authorEmail: authUser.email!)
            self.textView.text = ""
            self.view.endEditing(true)
        }
    }
    
    @IBAction func saveStandardHelpResponse(_ sender: Any) {
        presenter.saveStandardHelpResponse(post: self.post.id!, author: authUser.displayName!, authorId: authUser.uid, authorEmail: authUser.email!)
    }
        
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        presenter.attachView(view: self)
//        presenter.setView(postId: self.post.id!)
        print(postComments.count)
        presenter.setView(self.post.id!)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatViewSegue" {
            let nav = segue.destination as! UINavigationController
            let chatVc = nav.viewControllers.first as! ChatViewControllerInt
            chatVc.senderId = FIRAuth.auth()?.currentUser?.uid
            chatVc.senderDisplayName = "Cool"
        }
        if segue.identifier == "ReportSegue" {
            let navControl = segue.destination as! UINavigationController
            let vc = navControl.topViewController as! ReportViewController
            //let vc = segue.destination as! ReportViewController
            vc.viaSegue = self.report
            //present(vc, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 4
        let changeInHeight = (keyboardFrame.height + (0)) * (show ? 1 : -1)
        //5
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.bottomConstraint.constant += changeInHeight
            self.buttomBottomConstraint.constant += changeInHeight
        })
        
    }
    
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    
}





extension PostDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 3
        if postComments.isEmpty {
            return 1
        }else {
            //services.seachForUser(usersId: postComments[0].authorId)

            return postComments.count + 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostDetailTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.userNameLbl.text =  self.post.author
            cell.postID = self.post.id!
            cell.userUID = self.post.uid!
            cell.userEmail = self.post.userEmail!
            let uid  = self.post.uid
            services.loadUserImage(uid: uid!, completion: { (data) in
                if data != nil {
                    cell.userImage.image = UIImage(data: data!)
                }else {
                    cell.userImage.image = #imageLiteral(resourceName: "profile")
                }
            })
            cell.requestMsgLbl.text = self.post.body
            cell.distanceLbl.text = ""
            cell.publicationTimeLbl.text = ""
            
            //button cell
            cell.buttonOption.tag = indexPath.row
            cell.buttonOption.addTarget(self, action: #selector(postOptions(sender:)), for: UIControlEvents.touchUpInside)
            
            //title cell
            cell.postTitleLbl.text = self.post.title.uppercased()
            cell.postTitleLbl.font = UIFont(name: "OstrichSans-Heavy", size: 25)
            cell.postTitleLbl.textColor = UIColor(colorLiteralRed: 23/255, green: 178/255, blue: 138/255, alpha: 1)
            
            //name cell
            cell.userNameLbl.font = UIFont(name: "Lato-Medium", size: 13)
            cell.userNameLbl.textColor = UIColor(colorLiteralRed: 213/255, green: 13/155, blue: 76/255, alpha: 1)
            
            //distance and publication time cell
            cell.distanceLbl.font = UIFont(name: "Lato-ThinItalic", size: 11)
            cell.publicationTimeLbl.font = UIFont(name: "Lato-ThinItalic", size: 11)
            
            //message label 
            cell.requestMsgLbl.font = UIFont(name: "Lato-Medium", size: 15)
            
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "responseCell", for: indexPath) as! PostDetailCommentTableViewCell
            //cell.userNameLbl.text = "Response label for name"
            cell.backgroundColor = UIColor.clear
            if !postComments.isEmpty {
                cell.buttonOption.tag = indexPath.row
                cell.buttonOption.addTarget(self, action: #selector(postOptions(sender:)), for: UIControlEvents.touchUpInside)
                cell.helpMsgLbl.text = postComments[indexPath.row - 1].message
                cell.userNameLbl.text = postComments[indexPath.row - 1].author
                
                cell.helpMsgLbl.font = UIFont(name: "Lato-Medium", size: 13)
                cell.userNameLbl.textColor = UIColor(colorLiteralRed: 213/255, green: 13/155, blue: 76/255, alpha: 1)
                cell.userNameLbl.font = UIFont(name: "Lato-Medium", size: 13)
                cell.postID = self.post.id!
                cell.userUID = self.post.uid!
                cell.userEmail = self.post.userEmail!
                
                cell.userImage.image = #imageLiteral(resourceName: "profile")
                let uid  = postComments[indexPath.row - 1].authorId
                services.loadUserImage(uid: uid!, completion: { (data) in
                    if data != nil {
                        cell.userImage.image = UIImage(data: data!)
                    }else {
                        cell.userImage.image = #imageLiteral(resourceName: "profile")
                    }
                })

            }else {
                cell.helpMsgLbl.text = "celula vazia"
            }
            
            return cell
            
        }
        
    }
}

extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


extension PostDetailViewController: PostDetail {
    
    func startLoading() {
        //TODO
    }
    
    func finishLoading() {
        //TODO
    }
    func setEmptyCommentary() {
        //TODO
    }
    //set view
    func setCommentary(_ response: [Response]) {
        self.comments.removeAll()
        self.postComments = response
        self.tableView.reloadData()
    }
    
    
}







