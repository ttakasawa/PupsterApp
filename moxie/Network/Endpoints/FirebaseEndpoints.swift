//
//  FirebaseEndpoints.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/27/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import CodableFirebase

protocol FirebaseEndpoints {
    var path: String? { get }
    var body: Any? { get }
    var type: FirebaseEndpointType? { get }
    
    func toData<T: Encodable>(object: T) -> Any?
}


extension FirebaseEndpoints {
    func toData<T: Encodable>(object: T) -> Any? {
        let encoder = FirebaseEncoder()
        do{
            let jsonData = try encoder.encode(object)
            return jsonData // json body
        }catch{
            return nil
        }
        //return try encoder.encode(object)
    }
}



enum FirebaseEndpointType {
    case storeObject
    case appendList
    case queryList
    case querySingleObject
    case image
    case video
    case queryLastChildrenAdded
    case queryChildAdded
}



struct signInUser: Codable{
    var email: String
    var password: String
    func getEmail()-> String { return self.email }
    func getPassword()-> String { return self.password }
}

struct mediaComponent {
    var compressedVideo: String?
    var thumbnail: UIImage?
    var image: UIImage?
    
    var uploadedVideoUrl: String?
    var thumbnailUrl: String?
    var imageUrl: String?
    
    init (compressedVideo: String? = nil, thumbnail: UIImage? = nil, image: UIImage? = nil, uploadedVideoUrl: String? = nil, thumbnailUrl: String? = nil, imageUrl: String? = nil){
        
        self.compressedVideo = compressedVideo
        self.thumbnail = thumbnail
        self.image = image
        self.uploadedVideoUrl = uploadedVideoUrl
        self.thumbnailUrl = thumbnailUrl
        self.imageUrl = imageUrl
    }
}
