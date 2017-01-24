//
//  MessageHandler.swift
//  Translate
//
//  Created by Bryan Ye on 23/1/17.
//  Copyright © 2017 Bryan Ye. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol MessageHandlerDelegate: class {
    func messageReceived(senderId: String, senderName: String, text: String)
}

class MessageHandler {
    private static let _instance = MessageHandler()
    
    private init() {
        
    }
    
    weak var delegate: MessageHandlerDelegate?
    
    static var Instance: MessageHandler {
        return _instance
    }
    
    func sendMessage(senderId: String, senderName: String, text: String) {
        let data: [String: Any] = [Constants.SENDER_ID: senderId, Constants.SENDER_NAME: senderName, Constants.TEXT: text]
        
        DatabaseHelper.Instance.messagesRef.childByAutoId().setValue(data)
        
    }
    
    func sendMediaMessage(senderId: String, senderName: String, url: String) {
        let data: [String: Any] = [Constants.SENDER_ID: senderId, Constants.SENDER_NAME: senderName, Constants.URL: url]
        
        DatabaseHelper.Instance.mediaMessagesRef.childByAutoId().setValue(data)
    }
    
    func sendMedia(image: Data?, video: URL?, senderId: String, senderName: String) {
        if image != nil {
            DatabaseHelper.Instance.imageStorageRef.child(senderId + "\(NSUUID().uuidString).jpg").put(image!, metadata: nil, completion: { (metadata: FIRStorageMetadata?, error: Error?) in
                guard error == nil else { return }
                self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing: metadata!.downloadURL()!))
            })
        } else  {
            DatabaseHelper.Instance.videoStorageRef.child(senderId + "\(NSUUID().uuidString)").putFile(video!, metadata: nil, completion: { (metadata: FIRStorageMetadata?, error: Error?) in
                guard error == nil else { return }
                self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing: metadata!.downloadURL()!))
            })
        }
    }
    
    func observeMessages() {
        DatabaseHelper.Instance.messagesRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let senderId = data[Constants.SENDER_ID] as? String {
                    if let senderName = data[Constants.SENDER_NAME] as? String {
                        if let text = data[Constants.TEXT] as? String {
                            self.delegate?.messageReceived(senderId: senderId, senderName: senderName, text: text)
                        }
                    }
                    
                }
            }
        }
    }
}
