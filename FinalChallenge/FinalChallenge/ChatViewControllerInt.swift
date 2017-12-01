//
//  ChatViewControllerInt.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 21/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewControllerInt: JSQMessagesViewController {
    
    // MARK: Properties
    //let rootRef = Firebase(url: "https://<your-firebase-app>.firebaseio.com/")
    //var messageRef: Firebase!
    var messages = [JSQMessage]()
    var chatMessage = [ChatMessage]()
    var messageFromTable: ChatMessage!
    
    //var userIsTypingRef: Firebase!
    ///var usersTypingQuery: FQuery!
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    let defaults = UserDefaults.standard
    var user: FIRUser!

    var reciverUid: String!
    
    var chatManager : ChatManager! //= ChatManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBubbles()
        
        //chatManager = ChatManager()
        //messageRef = rootRef.childByAppendingPath("messages")
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        self.inputToolbar.contentView.leftBarButtonItem = nil

        //set user
        if let usr = FIRAuth.auth()?.currentUser {
            self.user = usr
        }else {
            print("There is no user connected")
        }
        
        self.setupBackButton()
        
//        chatManager.establishConnection()
//        chatManager.addHandlers()
//        chatManager.attachViewChat(view: self)
//        chatManager.joinRoom(room: self.user.uid, user: self.user.displayName!)
        
        
        SocketIOManager.sharedInstance.establishConnection()
        SocketIOManager.sharedInstance.addHandlers()
        SocketIOManager.sharedInstance.attachViewChat(view: self)
        //SocketIOManager.sharedInstance.joinRoom(room: self.user.uid,user: self.user.displayName!)
        
        
        if messageFromTable != nil {
            self.reciverUid = messageFromTable.uid
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SocketIOManager.sharedInstance.joinRoom(room: self.user.uid,user: self.user.displayName!)
        self.finishReceivingMessage()
        //self.setSocket()

    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.finishReceivingMessage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //chatManager.closeConnection()
        SocketIOManager.sharedInstance.closeConnection()
        self.messages.removeAll()
        self.chatMessage.removeAll()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Voltar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        }else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        cell.cellTopLabel.text = message.senderDisplayName
        cell.cellTopLabel.textColor = UIColor.black
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.black
        } else {
            cell.textView!.textColor = UIColor.black
        }
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
//        if (indexPath.item % 10 == 0) {
//            let message = self.messages[indexPath.item]
//            
//            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
//        }
//        
//        return nil
//    }
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        // Displaying names above messages
        //Mark: Removing Sender Display Name
       
        if message.senderId == self.senderId {
            return nil
        }
        
        return NSAttributedString(string: message.senderDisplayName)
    }
    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
//        if indexPath.item % 10 == 0 {
//            return kJSQMessagesCollectionViewCellLabelHeightDefault
//        }
//        
//        return 0.0
//
//    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        let currentMessage = self.messages[indexPath.item]
        
        if currentMessage.senderId == self.senderId {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }

    
    
    
    private func observeMessages() {
//        // 1
//        let messagesQuery = messageRef.queryLimitedToLast(25)
//        // 2
//        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
//            // 3
//            let id = snapshot.value["senderId"] as! String
//            let text = snapshot.value["text"] as! String
//            
//            // 4
//            self.addMessage(id, text: text)
//            
//            // 5
//            self.finishReceivingMessage()
//        }
        
        
    }
    
//    func loadMessages (message: String) {
//        do {
//            self.messages.removeAll()
//            self.chatMessage.removeAll()
//            
//            let data = message.data(using: String.Encoding.unicode)
//            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject]
////            self.chatMessage.append(ChatMessage(uid: json!["uid"] as! String, userName: json!["userName"] as! String, message: json!["message"] as! String,  timeStamp: json!["timeStamp"] as! String))
////            
////            //self.addMessage(id: json!["uid"] as! String, text: json!["message"] as! String, userName: json!["username"] as! String)
////            
////            //self.chatMessage =  self.chatMessage.reversed()
////
////            
////            self.finishReceivingMessage()
//            
//            let message = ChatMessage(uid: json!["uid"] as! String, userName: json!["userName"] as! String, message: json!["message"] as! String,  timeStamp: json!["timeStamp"] as! String, toUser: json?["toUser"] as! String)
//            
//            if self.reciverUid != nil {
//                if message.uid == self.reciverUid  {
//                    
//                    self.chatMessage.append(message)
//                    
//                    self.addMessage(id: json!["uid"] as! String, text: json!["message"] as! String, userName: json!["userName"] as! String)
//                    
//                    self.finishReceivingMessage()
//                    
//                }
//            }
//
//            
//        }catch {
//            //self.messages.append(message)
//            print("DEU ERRO DURANTE A CONVERSÃO no CHAT")
//        }
//    }
    
    func loadMessage(message: ChatMessage) {
        
        if self.reciverUid != nil {
            if message.uid == self.reciverUid  {
                
                self.chatMessage.append(message)
                
                self.addMessage(id: message.uid!, text: message.message!, userName: message.userName!)
                
                self.finishReceivingMessage()
                
            }
        }
    }
    
    
//    func setMessages (message:String){
//        do {
//            let data = message.data(using: String.Encoding.unicode)
//            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject]
//            let message = ChatMessage(uid: json!["uid"] as! String, userName: json!["userName"] as! String, message: json!["message"] as! String,  timeStamp: json!["timeStamp"] as! String, toUser: json?["toUser"] as! String)
//            
//            if self.reciverUid != nil {
//                if message.toUser == user.uid && message.uid == self.reciverUid || (message.uid == user.uid && message.toUser == self.reciverUid)  {
//                
//                    self.chatMessage.append(message)
//                    
//                    self.addMessage(id: json!["uid"] as! String, text: json!["message"] as! String, userName: json!["userName"] as! String)
//                    
//                    self.finishReceivingMessage()
//
//                }
//            }
//            
//            
//        }catch {
//            //self.messages.append(message)
//            print("NOVO CHAT CONTROLLER")
//        }
//    }
    
    func setMessages(message: ChatMessage) {
        if self.reciverUid != nil {
            if message.toUser   == user.uid && message.uid == self.reciverUid || (message.uid == user.uid && message.toUser == self.reciverUid) {
                self.chatMessage.append(message)
                self.addMessage(id: message.uid!, text: message.message!, userName: message.userName!)
                self.finishReceivingMessage()
            }
        }
        self.finishReceivingMessage()
    }

    
    
    func addMessage(id: String, text: String, userName:String) {
      
        //let m = JSQMessage(senderId: id, senderDisplayName: userName, text: text)
        let m = JSQMessage(senderId: id, displayName: userName, text: text)
        //let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(m!)
        self.finishReceivingMessage()
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
    }
    

    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        
        if !text.isEmpty{
            let message = text?.replacingOccurrences(of: ".*", with: ".*", options: .literal, range: nil)
    
            
            if self.reciverUid == nil {
                print("CHAT reciver nil")
                
                if chatMessage.isEmpty {
                    
                    //SocketIOManager.sharedInstance.sendAMessage(msg: message!, userName: senderDisplayName!, date: DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .long), uid: senderId, toUser: senderId)
                }else {
                    //chatManager.sendAMessage(msg: message!, userName: senderDisplayName!, date: Date().iso8601, uid: senderId, toUser: chatMessage[0].uid!)
                    SocketIOManager.sharedInstance.sendAMessage(msg: message!, userName: senderDisplayName!, date: Date().iso8601, uid: senderId, toUser: chatMessage[0].uid!)
                }
                
            }else {
                
                if chatMessage.isEmpty {
                    //chatManager.sendAMessage(msg: message!, userName: senderDisplayName!, date: Date().iso8601, uid: senderId, toUser: self.reciverUid)
                    
                    SocketIOManager.sharedInstance.sendAMessage(msg: message!, userName: senderDisplayName!, date: Date().iso8601, uid: senderId, toUser: self.reciverUid)
                }else {
                    SocketIOManager.sharedInstance.sendAMessage(msg: message!, userName: senderDisplayName!, date: Date().iso8601, uid: senderId, toUser: self.reciverUid)
                    //chatManager.sendAMessage(msg: message!, userName: senderDisplayName!, date: Date().iso8601, uid: senderId, toUser: self.reciverUid)
                }
                
            }
            
            
        }
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }
    
    private func setupBubbles() {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = bubbleImageFactory?.outgoingMessagesBubbleImage(with: Color().orangeCustomColor)
        incomingBubbleImageView = bubbleImageFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
}
