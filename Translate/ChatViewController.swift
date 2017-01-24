//
//  ChatViewController.swift
//  Translate
//
//  Created by Bryan Ye on 23/1/17.
//  Copyright © 2017 Bryan Ye. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import SDWebImage

class ChatViewController: JSQMessagesViewController {
    
    let picker = UIImagePickerController()
    
    var messages = [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = AuthHelper.Instance.userId()
        self.senderDisplayName = AuthHelper.Instance.userName
        
        picker.delegate = self
        MessageHandler.Instance.delegate = self
        
        MessageHandler.Instance.observeMessages()
        MessageHandler.Instance.observeMediaMessages()
    }
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        alertUserToChooseMedia()
    }
    
    
    // Data Source Functions
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .blue)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .red)
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "profile"), diameter: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // Delegate Functions
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        MessageHandler.Instance.sendMessage(senderId: senderId, senderName: senderDisplayName, text: text)
        finishSendingMessage()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message = messages[indexPath.item]
        
        if message.isMediaMessage {
            if let mediaItem = message.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.present(playerController, animated: true, completion: nil)
            }
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func chooseMedia(type: CFString) {
        picker.mediaTypes = [type as String]
        present(picker, animated: true, completion: nil)
        
    }
    
    func alertUserToChooseMedia() {
        let alertController = UIAlertController(title: "Media Messages", message: "Please Select A Media", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let photo = UIAlertAction(title: "Photo", style: .default) { (alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeImage)
        }
        let video = UIAlertAction(title: "Video", style: .default) { (alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeMovie)
        }
        
        alertController.addAction(photo)
        alertController.addAction(video)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let data = UIImageJPEGRepresentation(image, 0.01)
            MessageHandler.Instance.sendMedia(image: data, video: nil, senderId: senderId, senderName: senderDisplayName)
            
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            MessageHandler.Instance.sendMedia(image: nil, video: videoURL, senderId: senderId, senderName: senderDisplayName)
        }
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
}

extension ChatViewController: MessageHandlerDelegate {
    func messageReceived(senderId: String, senderName: String, text: String) {
        let message = JSQMessage(senderId: senderId, displayName: senderName, text: text)
        messages.append(message!)
        collectionView.reloadData()
    }
    
    func mediaReceived(senderId: String, senderName: String, mediaUrl: String) {
        if let url = URL(string: mediaUrl) {
            do {
                let data = try Data(contentsOf: url)
                if let _ = UIImage(data: data) {
                    let _ = SDWebImageDownloader.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, data, error, finished) in
                        DispatchQueue.main.async {
                            let photo = JSQPhotoMediaItem(image: image)
                            if senderId == self.senderId {
                                photo?.appliesMediaViewMaskAsOutgoing = true
                            } else {
                                photo?.appliesMediaViewMaskAsOutgoing = false
                            }
                            let message = JSQMessage(senderId: senderId, displayName: senderName, media: photo)
                            self.messages.append(message!)
                            self.collectionView.reloadData()
                        }
                    })
                } else {
                    let video = JSQVideoMediaItem(fileURL: url, isReadyToPlay: true)
                    if senderId == self.senderId {
                        video?.appliesMediaViewMaskAsOutgoing = true
                    } else {
                        video?.appliesMediaViewMaskAsOutgoing = false
                    }
                    let message = JSQMessage(senderId: senderId, displayName: senderName, media: video)
                    self.messages.append(message!)
                    self.collectionView.reloadData()
                    
                    
                }
            } catch {
                // Catch errors
            }
        }
    }
}
