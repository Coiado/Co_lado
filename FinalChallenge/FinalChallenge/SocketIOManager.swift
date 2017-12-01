//
//  SocketIOManager.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 29/09/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    //properties
    var room:String!
    static let sharedInstance = SocketIOManager()
    
    ///Instance from SocketIOClient
    //var socket: SocketIOClient!
    //var socket = SocketIOClient(socketURL: URL(string: "https://chatcambiando.herokuapp.com/")!)
    
    var socket = SocketIOClient(socketURL: URL(string: "http://172.16.1.131:3000")!)
    
    //var socket = SocketIOClient(socketURL: URL(string: "http://192.168.0.127:3000")!)
    
    weak var chatTableView: ChatViewController!
    weak var chatView: ChatViewControllerInt!
    weak var tableChat: TableChatViewController!
    let services = Services()
    
    override init() {
        super.init()
        //self.socket = SocketIOClient(socketURL: URL(string: "http://172.16.1.131:3000")!)
    }
    
    //MARK: - Handle view methods
    func attachView(_ view:ChatViewController){
        chatTableView = view
    }
    
    func attachViewChat(view:ChatViewControllerInt) {
        chatView = view
    }
    
    func attachTable(view: TableChatViewController) {
        self.tableChat = view
    }
    
    
    
    func detachView() {
        chatTableView = nil
    }
    
//    func detachTableView() {
//    
//    }
    
    //MARK: - SocketIOConnection methods
    func establishConnection () {
        socket.connect()
    }
    
    func closeConnection () {
        
        socket.off("chatMessage")
        //socket.off("loadMessage")
        socket.off("userJoined")
        socket.off("callForChat")
        
        //socket.disconnect()
    }
    
    //MARK: - Events treatment
    func addHandlers() {
        //This method listen from a message that was just inserted
        socket.on("chatMessage") { (messageData, ack) in
            //self.chatTableView.setMessages(message: messageData[0] as! String)
            print("Imprimindo \(messageData[0] as! NSDictionary)")
            let dic = messageData[0] as! NSDictionary
            let chatMessage = ChatMessage(uid: dic.value(forKey: "uid") as! String, userName: dic.value(forKey: "userName") as! String, message: dic.value(forKey: "message") as! String, timeStamp: dic.value(forKey: "timeStamp") as! String, toUser: dic.value(forKey: "toUser") as! String)
            self.chatView.setMessages(message: chatMessage)
            //self.chatView.setMessages(message: messageData[0] as! String)
        }
        
        //This listener load the messages from database and load inside the table view
        socket.on("loadMessage") { (messageData, ack) in
            print("SOCKET IO: Load message")
            //let m = messageData.reversed()
            for message in messageData {
                let dic = message as! NSDictionary
                let chatMessage = ChatMessage(uid: dic.value(forKey: "uid") as! String, userName: dic.value(forKey: "userName") as! String, message: dic.value(forKey: "message") as! String, timeStamp: dic.value(forKey: "timeStamp") as! String, toUser: dic.value(forKey: "toUser") as! String)
                self.chatView.setMessages(message: chatMessage)
            }
        }
        
        //this listener log the user inside the room
        socket.on("userJoined") { (data, ack) in
            print("imprimindo JOIN ROOM \(data) \(ack)")
            self.socket.emit("loadMessage", self.room)
        }
        
        
    }
    
    func addInitialHandeler() {
        
        socket.on("loadTable") { (messageData, ack) in
            let mData =  messageData[0] as! NSArray
            
            
            for index in 0..<mData.count   {
                if let dic = mData[index] as? NSDictionary {
                    let dicNome = dic.value(forKey: "_id") as! NSDictionary
                    let nome = dicNome.value(forKey: "userName") as! String
                    let arrayUid = dic.value(forKey: "uid") as! NSArray
                    let message = ChatMessage(uid: arrayUid[0] as! String, userName: nome)
                    print("SOCKET IO LOAD TABLE \(message.userName)")
                    self.tableChat.setMessages(message: message)
                }
                
            }
            
            
            //print(mData)
//            if let first = mData[0] as? NSArray {
//                if let dic = first[0] as? NSDictionary {
//                    let dicNome = dic.value(forKey: "_id") as! NSDictionary
//                    let nome = dicNome.value(forKey: "userName") as! String
//                    let arrayUid = dic.value(forKey: "uid") as! NSArray
//                    let message = ChatMessage(uid: arrayUid[0] as! String, userName: nome)
//                    self.tableChat.setMessages(message: message)
//                }
//            }
//            for message in mData {
//                message.
//                let chatMessage = ChatMessage(uid: message.uid!, userName: message.userName!)
//                //self.chatView.setMessages(message: chatMessage)
//                self.tableChat.setMessages(message: chatMessage)
//            }

            //self.tableChat.setMessages(message: messageData[0] as! String)
        }
    }
    
    func offInitialHandler() {
        //socket.off("callForChat")
    }
    
    //MARK: - Send message methods
    
    /**
      This method make possible to communicate with the server and send a new message to be saved in the database.
     
     - parameter msg: The message sent by the user
     - parameter userName: Name from user that sent the message
     - parameter date: Timestamp used to control the messages
     - parameter uid: Code for user identification
     */
    func sendAMessage (msg: String, userName: String, date: String, uid: String, toUser: String ) {
        socket.emit("send", self.room, msg, userName, date, uid, toUser)
        //socket.emit("send", uid, msg, userName, date, uid, uid)
        print(socket.sid)
    
    }
    
    func sendFirstMessage(msg: String, userName: String, date: String, uid: String, toUser: String) {
        socket.emit("firstMessage", self.room, msg, userName, date, uid, toUser)
    }
    
    /**
     This method bind the user and the room to estabilish connection
     
     - parameter room: Identification code for the room
     */
    func joinRoom (room: String, user: String) {
        self.room = room
        socket.emit("joinRoom", room, user)
    }
    
    func loadTableSender(room: String) {
        socket.emit("loadSavedMessages", room )
    }
    
    func joinChat(room: String, user: String) {
        self.room = room
        socket.emit("joinChat", room, user)
    }

    
    
}

