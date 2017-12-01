//
//  ChatManager.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 21/11/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import SocketIO

class ChatManager {
    
    //properties
    var room:String!
    
    ///Instance from SocketIOClient
    var socket: SocketIOClient!
    //var socket = SocketIOClient(socketURL: URL(string: "https://chatcambiando.herokuapp.com/")!)
    
    //var socket = SocketIOClient(socketURL: URL(string: "http://172.16.1.131:3000")!)
    
    //var socket = SocketIOClient(socketURL: URL(string: "http://192.168.0.127:3000")!)
    
    weak var chatTableView: ChatViewController!
    weak var chatView: ChatViewControllerInt!
    weak var tableChat: TableChatViewController!
    let services = Services()
    
    init() {
        self.socket = SocketIOClient(socketURL: URL(string: "http://172.16.1.131:3000")!)
    }
    
    //MARK: - Handle view methods

    
    func attachViewChat(view:ChatViewControllerInt) {
        chatView = view
    }
    
    
    
    
    func detachView() {
        chatView = nil
    }
    
    
    //MARK: - SocketIOConnection methods
    func establishConnection () {
        socket.connect()
    }
    
    func closeConnection () {
        
        socket.off("chatMessage")
        socket.off("loadMessage")
        socket.off("userJoined")
        socket.off("callForChat")
        
        socket.disconnect()
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
    
    
    func joinChat(room: String, user: String) {
        self.room = room
        socket.emit("joinChat", room, user)
    }
    
    

}
