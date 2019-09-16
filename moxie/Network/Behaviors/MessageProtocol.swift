//
//  MessageProtocol.swift
//  moxie
//
//  Created by Tomoki Takasawa on 8/14/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//
import Foundation
import MessageKit
import UIKit

protocol MessageProtocol {
    var currentSender: Sender? { get }
    var now: Date? { get }
    var adminId: String { get }
    var initialMessages: [Message]? { get }
    //func getRecentMessages(user)
    func getMessages(user: UserData, count: Int?, completion: @escaping ([Message]) -> Void)
    func getAvatarFor(sender: Sender, user: UserData, image: UIImage?) -> Avatar
    func processMessageForUpload(message: Message, user: UserData)
    func send(message: Message, user: UserData)
    
    func getRecentMessages()
}

extension MessageProtocol where Self: FirebaseQueryProtocol {
    
    var now: Date {
        return Date()
    }
    
    func getMessages(user: UserData, count: Int?, completion: @escaping ([Message]) -> Void) {
        var messages: [Message] = []
        
        //NOTE: count is set to 15 in .retrieveMessageKey -> Need fix here
        self.fetchFirebase(endpoint: MessageEndpoints.retrieveMessageKey(user: user, count: count)) { (key: String?, error: Error?) in
            
            if key != nil {
                self.fetchFirebase(endpoint: MessageEndpoints.getMessages(key: key!)) { (message: Message?, error: Error?) in
                    
                    if (error != nil) { return }
                    
                    if let message = message {
                        if message.fromId == Global.network.user?.id {
                            message.sender = Global.network.currentSender!
                        }else {
                            message.sender = Sender(id: message.fromId, displayName: "Gwen")
                        }
                        
                        messages.append(message)
                        completion(messages)
                    }
                    
                }
            }else{
                completion(messages)
            }
        }
        //completion(messages)
    }
    
    func getAvatarFor(sender: Sender, user: UserData, image: UIImage?) -> Avatar {
        //TODO: Figure out what to do with Avatar
        //Perhaps, image of the profile
        
        if sender == Global.network.currentSender {
            return Avatar(image: image, initials: user.firstName[0] + user.lastName[0])
        }else{
            //return user.isOnSubscription ? Avatar(image: #imageLiteral(resourceName: "gwen"), initials: "G") : Avatar(image: #imageLiteral(resourceName: "bill"), initials: "G")
            return user.isOnSubscription ? Avatar(image: #imageLiteral(resourceName: "gwen"), initials: "G") : Avatar(image: #imageLiteral(resourceName: "bill"), initials: "B")
        }
    }
    
    
    func processMessageForUpload(message: Message, user: UserData){
        
        if message.image != nil {
            
            let endpoint = MessageEndpoints.uploadImageToStorage(user: user, message: message)
            self.fetchFirebaseStorage(endpoint: endpoint) { media in
                //TODO: what if media returned nil
                let messageToUpload = Message(toId: self.adminId, fromId: user.id, messageId: message.messageId, date: message.sentDate, sender: message.sender, imageUrl: media?.imageUrl)
                self.send(message: messageToUpload, user: user)
            }
            
        }else if message.thumbnail != nil {
            
            let endpoint = MessageEndpoints.uploadVideoToStorage(user: user, message: message)
            self.fetchFirebaseStorage(endpoint: endpoint) { media in
                let messageToUpload = Message(toId: self.adminId, fromId: user.id, messageId: message.messageId, date: message.sentDate, sender: message.sender, thumbnailUrl: media?.thumbnailUrl, videoUrl: media?.uploadedVideoUrl)
                self.send(message: messageToUpload, user: user)
            }
        }
    }
    
    func send(message: Message, user: UserData) {
        
        self.fetchFirebase(endpoint: MessageEndpoints.send(message: message, user: user)) { (key: String?, error: Error?) in
            if error != nil {
                //TODO: message could not be sent, pop up and load image again
                print("error in send")
                return 
               
            }else{
                guard let messageKey = key else {
                    print("key conversion fail")
                    return
                }
                
                self.firebaseAtomicStore(endpoints: [MessageEndpoints.toUserMessage(message: message, messageKey: messageKey), MessageEndpoints.fromUserMessage(message: message, messageKey: messageKey), MessageEndpoints.unreadMessageUpdate(isUnread: true, message: message), MessageEndpoints.unreadMessageTimeStampUpdate(timestamp: Date(), message: message)]) { (success) in
                    //TODO: check success
                    print("success?")
                }
            }
        }
    }
    
    func checkMessage(user: UserData, completion: @escaping(_ isUnread: Bool) -> Void){
        self.fetchFirebase(endpoint: MessageEndpoints.checkUnread(user: user)) { (isUnread: Bool?, error: Error?) in
            if error != nil{
                completion(false)
            }else{
                completion(isUnread!)
            }
        }
    }
    
    func markMessageRead(user: UserData){
        self.fetchFirebase(endpoint: MessageEndpoints.markMessageRead(user: user)) { (isUnread: Bool?, error: Error?) in
            if error != nil{
                print("error")
            }
        }
    }
    
}
