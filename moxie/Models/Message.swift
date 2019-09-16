//
//  Message.swift
//  moxie
//
//  Created by Tomoki Takasawa on 8/13/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import MessageKit
import UIKit
import FirebaseAuth

//TODO: Computed value for "unread" Bool
class Message: MessageType, Codable, Cachable {
    var fileName: String {
        return "PupsterMessages-\(messageId)"
    }
    
    
    var messageId: String = ""
    var toId: String = ""
    var fromId: String = ""
    var sentDate: Date = Date()
    var kind: MessageKind = .text("Whoops error..")
    var sender: Sender = Sender(id: "fake", displayName: "tech support")
    //var timeStamp: Date = 0
    
    var text: String?
    var image: UIImage?
    var imageUrl: String?
    var thumbnail: UIImage?
    var thumbnailUrl: String?
    var emoji: String?
    var videoUrl: String?
    
    enum CodingKeys: String, CodingKey, ImageProtocol {
        case messageId, fromId, sentDate, text, imageUrl, thumbnailUrl, emoji, videoUrl
    }
    
    convenience required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let messageId: String = try container.decode(String.self, forKey: .messageId) // extracting the data
        //let toId: String = try container.decode(String.self, forKey: .toId) // extracting the data
        let fromId: String = try container.decode(String.self, forKey: .fromId) // extracting the data
        let sentDate: Date = try container.decode(Date.self, forKey: .sentDate) // extracting the data
        
        var text: String?
        var imageUrl: String?
        var thumbnailUrl: String?
        var emoji: String?
        var videoUrl: String?
        
        do{
            text = try container.decode(String.self, forKey: .text)
        }catch{
            text = nil
        }
        
        do{
            imageUrl = try container.decode(String.self, forKey: .imageUrl)
        }catch{
            imageUrl = nil
        }
        
        do{
            thumbnailUrl = try container.decode(String.self, forKey: .thumbnailUrl)
        }catch{
            thumbnailUrl = nil
        }
        
        do{
            emoji = try container.decode(String.self, forKey: .emoji)
        }catch{
            emoji = nil
        }
        
        do{
            videoUrl = try container.decode(String.self, forKey: .videoUrl)
        }catch{
            videoUrl = nil
        }
        
        self.init(fromId: fromId, messageId: messageId, date: sentDate, text: text, imageUrl: imageUrl, thumbnailUrl: thumbnailUrl, emoji: emoji, videoUrl: videoUrl)
    }
    
    
    init(toId: String? = nil, fromId: String, messageId: String, date: Date, sender: Sender? = Sender(id: "fake", displayName: "tech support"), text: String? = nil, image: UIImage? = nil, imageUrl: String? = nil, thumbnail: UIImage? = nil, thumbnailUrl: String? = nil, emoji: String? = nil, videoUrl: String? = nil) {
        
        
        if sender != Sender(id: "fake", displayName: "tech support"){
            self.sender = sender!
            self.fromId = sender!.id
        }else{
            //no sender info given
            self.fromId = fromId
//            self.getSender(id: fromId) { (sender) in
//                self.sender = sender
//            }
        }
        
        self.messageId = messageId
        self.sentDate = date
        
        if (toId != nil) {
            self.toId = toId!
        }
        
        if (text != nil) {
            self.kind = .text(text!)
            self.text = text
        }else if (image != nil){
            let mediaItem = messageMediaItem(image: image!)
            self.kind = .photo(mediaItem)
            self.image = image
        }else if (imageUrl != nil){
            let mediaItem = messageMediaItem(urlString: imageUrl!)
            self.kind = .photo(mediaItem)
            self.imageUrl = imageUrl
            
        }else if (thumbnail != nil){
            let mediaItem = messageMediaItem(image: thumbnail!)
            self.kind = .video(mediaItem)
            self.thumbnail = thumbnail
            self.videoUrl = videoUrl
        }else if (thumbnailUrl != nil){
            let mediaItem = messageMediaItem(urlString: thumbnailUrl!)
            self.kind = .video(mediaItem)
            self.thumbnailUrl = thumbnailUrl
            self.videoUrl = videoUrl
        
        }else if (emoji != nil){
            self.emoji = emoji
            self.kind = .emoji(emoji!)
        }
    }
    
}

class messageMediaItem: MediaItem, ImageProtocol {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
        
    }
    
    init (urlString: String){
        
        if let url = URL(string: urlString){
            
            self.url = url
            self.size = CGSize(width: 240, height: 240)
            self.placeholderImage = UIImage()
            self.downloadImage(url: url) { downloadedImage in
                self.image = downloadedImage
            }
            
        }else{
            self.size = CGSize(width: 240, height: 240)
            self.placeholderImage = UIImage()
            self.image = UIImage()
        }
    }
    
    init (urlWithCompletion: String, completion: @escaping (_ mediaItem: messageMediaItem?) -> Void){
        if let url = URL(string: urlWithCompletion){
            
            self.url = url
            self.size = CGSize(width: 240, height: 240)
            self.placeholderImage = UIImage()
            self.downloadImage(url: url) { downloadedImage in
                self.image = downloadedImage
                completion(self)
            }
            
        }else{
            self.size = CGSize(width: 240, height: 240)
            self.placeholderImage = UIImage()
            self.image = UIImage()
            completion(self)
        }
    }
}


protocol SenderProtocol{
    func getSender(id: String, completion: (_ sender: Sender) -> Void)
}

extension Message: SenderProtocol{
    func getSender(id: String, completion: (_ sender: Sender) -> Void) {
        
        guard let userId = Global.network.user?.id else { return }
        
        if id == userId {
            completion(Global.network.currentSender!)
        }else{
            completion(Sender(id: id, displayName: "Gwen"))
        }
    }
}

//extension SenderProtocol where Self: Global.Network {
//    func getSender(id: String, completion: (_ sender: Sender) -> Void) {
//        if let userSenderObj = Global.network.currentSender {
//            completion(userSenderObj)
//        }else{
//            completion(Sender(id: id, displayName: "Gwen"))
//        }
//    }
//}





