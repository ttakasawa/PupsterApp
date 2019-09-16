//
//  FirebaseProtocol.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/23/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase
import FirebaseStorage
import FirebaseDatabase

protocol FirebaseQueryProtocol {
    var firebaseDBConnection: DatabaseReference { get set } // TODO: make this a real connection
    func fetchFirebase<T: Decodable>(endpoint: FirebaseEndpoints, completion: @escaping (_ result: T?, _ error: Error?) -> Void)
    func fetchFirebaseStorage(endpoint: FirebaseEndpoints, completion: @escaping (_ url: mediaComponent?) -> Void)
    func fetchAuth(endpoint: FirebaseEndpoints, completion: @escaping (_ id: String?, _ error: Error?) -> Void)
    func firebaseStorageHelper(storageRef: StorageReference, image: UIImage, completion: @escaping (_ stringUrl: String?, Error?) -> Void)
    
    func firebaseAtomicStore(endpoints: [FirebaseEndpoints], completion: @escaping ( _ success: Bool) -> Void)
}


extension FirebaseQueryProtocol where Self: Global.Network {
    
    func firebaseAtomicStore(endpoints: [FirebaseEndpoints], completion: @escaping ( _ success: Bool) -> Void) {
        let ref = Global.network.firebaseDBConnection
        var fanoutObj: [String: Any] = [:]
        for i in 0..<endpoints.count{
            
            guard let path = endpoints[i].path else {
                print("path not found")
                return
            }
            
            guard let body = endpoints[i].body else {
                print("body not found")
                return
            }
            
            fanoutObj[path] = body
        }
        
        ref.updateChildValues(fanoutObj) { (error, ref) in
            if error != nil {
                completion(false)
            }else{
                completion (true)
            }
        }
    }
    
    
    func firebaseStorageHelper(storageRef: StorageReference, image: UIImage, completion: @escaping (_ stringUrl: String?, Error?) -> Void){
        if let uploadData = UIImagePNGRepresentation(image){
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                
                if ((error) != nil){
                    completion(nil, error)
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    guard let stringURL = url?.absoluteString else {
                        completion(nil, error)
                        return
                    }
                    completion(stringURL, error)
                }
            }
        }
    }
    
    func fetchFirebaseStorage(endpoint: FirebaseEndpoints, completion: @escaping (_ url: mediaComponent?) -> Void) {
        
        let path = endpoint.path
        let storageRef = Storage.storage().reference().child(path!)
        
        if let body = endpoint.body as? mediaComponent {
            if let image = body.image {
                //self.firebaseStorageHe
                self.firebaseStorageHelper(storageRef: storageRef, image: image) { (urlString: String?, error: Error?) in
                    guard let url = urlString else { return }       //TODO: error handling
                    completion(mediaComponent(imageUrl: url))
                }
            }else{
                
                guard let localUrl: String = body.compressedVideo else { return }
                guard let thumbnailImage: UIImage = body.thumbnail else { return }
                guard let localFile = URL(string: localUrl) else { return }
                
                let storageRefForVideo = storageRef.child("videoUrl")
                storageRefForVideo.putFile(from: localFile, metadata: nil) { metadata, error in
                    
                    storageRefForVideo.downloadURL { (url, error) in
                        guard let videoDownloadURL = url?.absoluteString else { return }
                        
                        let storageRefForThumbnail = storageRef.child("thumbnail")
                        self.firebaseStorageHelper(storageRef: storageRefForThumbnail, image: thumbnailImage) { (urlString: String?, error: Error?) in
                            guard let thumbnailDownloadURL = urlString else { return }       //TODO: error handling
                            completion(mediaComponent(uploadedVideoUrl: videoDownloadURL, thumbnailUrl: thumbnailDownloadURL))
                        }
                        
                    }
                }
            }
        }else{
            print("no body")
            //TODO: error handling
        }
    }
    
    func fetchFirebase<T: Decodable>(endpoint: FirebaseEndpoints, completion: @escaping (_ result: T?, _ error: Error?) -> Void) {
        var realtimeRef: DatabaseReference!
        
        if let path = endpoint.path {
            realtimeRef = Global.network.firebaseDBConnection.child(path)
        }else{
            realtimeRef = Global.network.firebaseDBConnection
        }
        
        if let body = endpoint.body {
            if (endpoint.type == FirebaseEndpointType.appendList) {
                let childRef = realtimeRef.childByAutoId()
                
                childRef.setValue(body) { (error, reference) in
                    if (error != nil){
                        print("error")
                        completion (nil, error)
                    }else{
                        guard let firebaseMessageKey = childRef.key as? T else{
                                print("key did not get stored")
                            return
                        }
                        completion(firebaseMessageKey, nil)
                    }
                }
//                childRef.setValue(body)
//                completion(nil, nil)
            }else if (endpoint.type == FirebaseEndpointType.storeObject){
                realtimeRef.setValue(body)
                
                if let storedData = body as? T{
                    completion(storedData, nil)
                }else{
                    completion(nil, nil)
                }
                
            }else{
                //TODO: error
                print("error in firebase endpoint type")
            }
        } else {
            if (endpoint.type == FirebaseEndpointType.queryList){
                
                realtimeRef.observeSingleEvent(of: .value) { (snapshot) in
                    guard let value = snapshot.value else {
                        print("no value")
                        return
                    }
                    do {
                        let model = try FirebaseDecoder().decode(T.self, from: value)
                        completion(model, nil)
                    } catch let error {
                        print("decode fail")
                        completion(nil, error)
                    }

                }
                
            }else if (endpoint.type == FirebaseEndpointType.querySingleObject){
                realtimeRef.observeSingleEvent(of: .value, with: { snapshot in
                    guard let value = snapshot.value else { return }
                    do {
                        let model = try FirebaseDecoder().decode(T.self, from: value)
                        completion(model, nil)
                    } catch let error {
                        completion(nil, error)
                    }
                })

            }else if (endpoint.type == FirebaseEndpointType.queryLastChildrenAdded){
                realtimeRef.queryLimited(toLast: 30).observe(.childAdded) { (snapshot) in
                    let key = snapshot.key
                    
                    if let messageKey = key as? T {
                        completion(messageKey, nil)
                    }else{
                        completion(nil, nil)
                    }
                }
                completion(nil, nil)
                
            }else if (endpoint.type == FirebaseEndpointType.queryChildAdded){
                
                realtimeRef.observe(.childAdded) { (snapshot) in
                    let key = snapshot.key
                    
                    if let messageKey = key as? T {
                        completion(messageKey, nil)
                    }else{
                        completion(nil, nil)
                    }
                }
                completion(nil, nil)//queryChildAdded
            }
        }
    }
    
    func fetchAuth(endpoint: FirebaseEndpoints, completion: @escaping (_ id: String?, _ error: Error?) -> Void){
        guard let newUser = endpoint.body as? signInUser else { return }
        if let _ = endpoint.path {
            Auth.auth().signIn(withEmail: newUser.email, password: newUser.password) { (result, error) in
                self.firebaseAuthenticationHelper(authResult: result, error: error, completion: { (userId, error) in
                    completion(userId, error)
                })
            }
        }else {
            Auth.auth().createUser(withEmail: newUser.email, password: newUser.password) { (result, error) in
                self.firebaseAuthenticationHelper(authResult: result, error: error, completion: { (userId, error) in
                    completion(userId, error)
                })
            }
        }
    }
    
    func firebaseAuthenticationHelper(authResult: AuthDataResult?, error: Error?, completion: @escaping (_ id: String?, _ error: Error?) -> Void){
        if let error = error{
            print(error.localizedDescription)
            completion(nil, error)
            return
        }else{
            completion(authResult?.user.uid, nil)
            return
        }
    }
}

extension FirebaseQueryProtocol where Self: Global.DemoNetwork {
    
    func firebaseStorageHelper(storageRef: StorageReference, image: UIImage, completion: @escaping (_ stringUrl: String?, Error?) -> Void){
        //no need here
    }
    
    //Firebase storage
    func fetchFirebaseStorage(endpoint: FirebaseEndpoints, completion: @escaping (_ url: mediaComponent?) -> Void) {
        
    }
    
    
    //Real time database & authentication for now
    func fetchFirebase<T: Decodable>(endpoint: FirebaseEndpoints, completion: @escaping (_ result: T?, _ error: Error?) -> Void) {
    }
    
    //authentication
    func fetchAuth(endpoint: FirebaseEndpoints, completion: @escaping (_ id: String?, _ error: Error?) -> Void){
        
    }
    func firebaseAtomicStore(endpoints: [FirebaseEndpoints], completion: @escaping ( _ success: Bool) -> Void){
        
    }
}



