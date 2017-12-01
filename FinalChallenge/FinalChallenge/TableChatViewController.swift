//
//  TableChatViewController.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 31/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import Firebase
class TableChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let services = Services()
    var chatInvites = [ChatMessage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Color().backgroundStandardColor
        self.tableView.backgroundColor = Color().backgroundStandardColor
        
        //tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        SocketIOManager.sharedInstance.attachTable(view: self)
        
//        if (SocketIOManager.sharedInstance.socket.status == .disconnected) || (SocketIOManager.sharedInstance.socket.status == .notConnected) {
//            SocketIOManager.sharedInstance.establishConnection()
//            self.addInitialHandeler()
//            SocketIOManager.sharedInstance.joinChat(room: (FIRAuth.auth()?.currentUser?.uid)!, user: (FIRAuth.auth()?.currentUser?.displayName)!)
//            self.tableView.reloadData()
//
//        }else {
//            self.addInitialHandeler()
//            SocketIOManager.sharedInstance.joinChat(room: (FIRAuth.auth()?.currentUser?.uid)!, user: (FIRAuth.auth()?.currentUser?.displayName)!)
//        }

        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VIEW DID APPEAR")

        
        SocketIOManager.sharedInstance.loadTableSender(room: (FIRAuth.auth()?.currentUser?.uid)!)
        

        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("VIEW WILL APPEAR")
        
        if (SocketIOManager.sharedInstance.socket.status == .disconnected) || (SocketIOManager.sharedInstance.socket.status == .notConnected){
            SocketIOManager.sharedInstance.establishConnection()
            self.addInitialHandeler()
            SocketIOManager.sharedInstance.joinChat(room: (FIRAuth.auth()?.currentUser?.uid)!, user: (FIRAuth.auth()?.currentUser?.displayName)!)
        }else{
            self.addInitialHandeler()
            SocketIOManager.sharedInstance.joinChat(room: (FIRAuth.auth()?.currentUser?.uid)!, user: (FIRAuth.auth()?.currentUser?.displayName)!)
        
        }

        //SocketIOManager.sharedInstance.joinChat(room: (FIRAuth.auth()?.currentUser?.uid)!, user: (FIRAuth.auth()?.currentUser?.displayName)!)
        
        

        self.tableView.reloadData()
        
        
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "chatSegue" {
            if let destination  = segue.destination as? UINavigationController {
                let vc = destination.topViewController as! ChatViewControllerInt
                vc.senderId = FIRAuth.auth()?.currentUser?.uid
                vc.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName!
                
                let index = self.tableView.indexPathForSelectedRow
                let row = index?.row
                
                vc.messageFromTable = chatInvites[row!]
                
                self.chatInvites.removeAll()
                SocketIOManager.sharedInstance.socket.off("loadTable")
        
            }
        }
    }
    
    
    func setMessages(message: ChatMessage) {
        self.tableView.reloadData()
        chatInvites.append(message)
        self.tableView.reloadData()
    }
    
    
    
    
    func addInitialHandeler() {
        
        
        SocketIOManager.sharedInstance.socket.on("loadTable") { (messageData, ack) in
            let mData =  messageData[0] as! NSArray
            
            self.chatInvites.removeAll()
            
            for index in 0..<mData.count   {
                if let dic = mData[index] as? NSDictionary {
                    let dicNome = dic.value(forKey: "_id") as! NSDictionary
                    let nome = dicNome.value(forKey: "userName") as! String
                    let arrayUid = dic.value(forKey: "uid") as! NSArray
                    let message = ChatMessage(uid: arrayUid[0] as! String, userName: nome)
                    print("MESSAGE IO LOAD TABLE \(message.userName)")
                    self.setMessages(message: message)
                }
                
            }
            self.tableView.reloadData()
        }
    }

    
}



extension TableChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension TableChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatInvites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let uid = chatInvites[indexPath.row].uid!
        services.loadUserImage(uid: uid) { (data) in
            if data != nil {
                let image = UIImage(data: data!)
                cell?.imageView?.frame = CGRect(x: 15.0, y: 10.0, width: 50.0, height: 50.0)
                cell?.imageView?.cornerRadius = (cell?.imageView?.frame.height)! / 2
                cell?.imageView?.clipsToBounds = true
                cell?.imageView?.image = image
                //cell?.textLabel?.text = self.chatInvites[indexPath.row].userName

            }else {
                cell?.imageView?.image = #imageLiteral(resourceName: "profile")
            }
            
        }
        
        
        cell?.textLabel?.text = chatInvites[indexPath.row].userName
        cell?.backgroundColor = Color().backgroundStandardColor
        return cell!
    }
}
