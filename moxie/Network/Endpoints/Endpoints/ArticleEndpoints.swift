//
//  ArticleEndpoints.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/27/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation


enum ArticleEndpoints: FirebaseEndpoints {
    
    //article related
    case getArticleContent(articleId: String)
    case markRead(user: UserData, articleArray: [String])
    case getAuthor(id: String)
    
    
    var path: String? {
        switch self {
        case .markRead(let user, _):
            return "users/\(user.id)/readArticleIds"
        case .getArticleContent(let articleId):
            return "Articles/\(articleId)"
        case .getAuthor(let id):
            return "Authors/\(id)"
        }
    }
    
    
    //TODO: make all cases that uses firebase encoder into one case
    var body: Any? {
        switch self {
        case .markRead( _, let articleArray):
            return self.toData(object: articleArray)
        case .getArticleContent( _), .getAuthor( _):
            return nil
        }
    }
    
    //TODO: finish this
    var type: FirebaseEndpointType? {
        switch self {
        case .getArticleContent( _), .getAuthor( _):
            return FirebaseEndpointType.querySingleObject
            
        case .markRead( _, _):
            return FirebaseEndpointType.storeObject
        }
    }
}



enum MessageEndpoints: FirebaseEndpoints {
    
    // for message
    case uploadImageToStorage(user: UserData, message: Message)
    case uploadVideoToStorage(user: UserData, message: Message)
    case retrieveMessageKey(user: UserData, count: Int?)
    case getMessages(key: String)
    case send(message: Message, user: UserData)
    case toUserMessage(message: Message, messageKey: String)
    case fromUserMessage(message: Message, messageKey: String)
    case unreadMessageUpdate(isUnread: Bool, message: Message)
    case unreadMessageTimeStampUpdate(timestamp: Date, message: Message)
    case checkUnread(user: UserData)
    case markMessageRead(user: UserData)
    
    
    var path: String? {
        switch self {
        case .getMessages(let key):
            return "messages/\(key)"
        case .send( _, _):
            return "messages"
        case .toUserMessage(let message, let messageKey):
            return "UserMessages/\(message.toId)/\(message.fromId)/\(messageKey)"
        case .fromUserMessage(let message, let messageKey):
            return "UserMessages/\(message.fromId)/\(messageKey)"
        case .unreadMessageUpdate( _, let message):
            return "Admin/\(message.toId)/users/\(message.fromId)/isUnreadMessage"
        case .unreadMessageTimeStampUpdate( _, let message):
            return "Admin/\(message.toId)/users/\(message.fromId)/timestamp"
        case .uploadImageToStorage(let user, let message), .uploadVideoToStorage(let user, let message):
            let userId = user.id
            return "messages/\(userId)/\(message.messageId)"
        case .checkUnread(let user), .markMessageRead(let user):
            return "users/\(user.id)/isUnreadMessage"
            
        case .retrieveMessageKey(let user, _):
            let userId = user.id
            return "UserMessages/\(userId)"
        }
    }
    
    //TODO: make all cases that uses firebase encoder into one case
    var body: Any? {
        switch self {
        case .getMessages( _), .retrieveMessageKey( _, _), .checkUnread( _):
            return nil
        case .send(let message, _):
            return self.toData(object: message)
        case .toUserMessage( _, _):
            return self.toData(object: true)
        case .fromUserMessage( _, _), .markMessageRead( _ ):
            return self.toData(object: false)
        case .unreadMessageUpdate(let isUnread, _):
            return isUnread
        case .unreadMessageTimeStampUpdate(let timestamp, _):
            return self.toData(object: timestamp)
        case .uploadImageToStorage( _, let message):
            guard let rawImage = message.image else { return nil }
            return mediaComponent(image: rawImage)
            
        case .uploadVideoToStorage( _, let message):
            guard let videoUrl = message.videoUrl else { return nil }
            guard let thumbnail = message.thumbnail else { return nil }
            return mediaComponent(compressedVideo: videoUrl, thumbnail: thumbnail)
            
        }
    }
    
    //TODO: finish this
    var type: FirebaseEndpointType? {
        switch self {
            
        case .toUserMessage( _, _), .fromUserMessage( _, _), .markMessageRead( _), .unreadMessageUpdate( _, _), .unreadMessageTimeStampUpdate( _, _):
            return FirebaseEndpointType.storeObject
            
        case .checkUnread( _):
            return FirebaseEndpointType.querySingleObject
            
            
        case .getMessages( _):
            return FirebaseEndpointType.queryList
            
        case .send:
            return FirebaseEndpointType.appendList
            
        case .retrieveMessageKey( _, let count):
            if count != nil { return FirebaseEndpointType.queryLastChildrenAdded }
            else { return FirebaseEndpointType.queryChildAdded }
        
        default:
            return nil
        }
    }
}
