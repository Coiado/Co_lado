//
//  ChatViewController.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 29/09/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController {
    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var msgTextField: UITextField!
    
   //properties
    var messages = [String]()
    var chatMessage = [ChatMessage]()
    var user: FIRUser!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        msgTextField.delegate = self
        
        //set socket
        SocketIOManager.sharedInstance.attachView(self)
        SocketIOManager.sharedInstance.joinRoom(room: "teste1", user: (FIRAuth.auth()?.currentUser?.displayName!)!)
        SocketIOManager.sharedInstance.addHandlers()
        
        
        if let usr = FIRAuth.auth()?.currentUser {
            self.user = usr
        }else {
            print("CHAT: user is not connected")
        }
        
        view.backgroundColor = UIColor(colorLiteralRed: 254/255, green: 248/255, blue: 228/255, alpha: 1)
        tableView.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //chat Operations
    @IBAction func sendMessageButton(_ sender: AnyObject) {
        
        if !(self.msgTextField.text?.isEmpty)! {
            
            let message = self.msgTextField.text?.replacingOccurrences(of: ".*", with: ".*", options: .literal, range: nil)

            SocketIOManager.sharedInstance.sendAMessage(msg: message!, userName: user.displayName!, date: DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short), uid: user.uid, toUser: user.uid)
        }else {
            print("CHAT CONTROLLER: message textField is empty")
        }
        
    }
    
    func setMessages (message:String){
        do {
           let data = message.data(using: String.Encoding.unicode)
            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject]
            self.chatMessage.append(ChatMessage(uid: json!["uid"] as! String, userName: json!["userName"] as! String, message: json!["message"] as! String,  timeStamp: json!["timeStamp"] as! String))
        
        }catch {
            self.messages.append(message)
        }
        //self.messages.append(message)
        self.tableView.reloadData()
    }
    
    func loadMessages (message: String) {
        do {
            let data = message.data(using: String.Encoding.unicode)
            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject]
            self.chatMessage.append(ChatMessage(uid: json!["uid"] as! String, userName: json!["userName"] as! String, message: json!["message"] as! String,  timeStamp: json!["timeStamp"] as! String))
            
        }catch {
            self.messages.append(message)
        }
        //self.messages.append(message)
        self.chatMessage =  self.chatMessage.reversed()
        self.tableView.reloadData()

    }
    
    

}

extension ChatViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.msgTextField.resignFirstResponder()
    }
}

extension ChatViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension ChatViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        //cell?.textLabel?.text = messages[indexPath.row]
        let messageString = chatMessage[indexPath.row].message
    
        cell?.textLabel?.text = messageString!//chatMessage[indexPath.row].message
        cell?.detailTextLabel?.text = chatMessage[indexPath.row].userName
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessage.count
    }
}


