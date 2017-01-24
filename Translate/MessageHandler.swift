//
//  MessageHandler.swift
//  Translate
//
//  Created by Bryan Ye on 23/1/17.
//  Copyright © 2017 Bryan Ye. All rights reserved.
//

import Foundation

class MessageHandler {
    private static let _instance = MessageHandler()
    private init() {
        
    }
    
    static var Instance: MessageHandler {
        return _instance
    }
    
    func sendMessage(senderId: String, senderName: String, text: String) {
        let data: [String: Any] = [Constants.SENDER_ID: senderId, Constants.SENDER_NAME: senderName, Constants.TEXT: text]
        
        DatabaseHelper.Instance.messagesRef.childByAutoId().setValue(data)
        
    }
}
