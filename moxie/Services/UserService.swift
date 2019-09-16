//
//  UserService.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/9/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static let shared = UserService()
    
    let userReference = Database.database().reference().child("users")
    
    func setCurrent(user: PUser) {
        PUser.save(user)
    }
    
    func uploadProfileToDatabase(completion: @escaping (String?)->Void) {
        if let current = PUser.current {
            userReference.child(current.uid).setValue(current.serializeWithoutID()) { (error, ref) in
                completion(error?.localizedDescription)
            }
        } else {
            completion("Not authorized")
        }
    }
    
    func update(dogId: String, completion: @escaping (String?)->Void) {
        guard let current = PUser.current else {
            completion("Not authorized")
            return
        }
        userReference.child(current.uid).child("dog").setValue(dogId) { (error, ref) in
            completion(error?.localizedDescription)
        }
    }
    
    func getUserFromFirebase(uid: String, completion: @escaping (PUser?,String?)->Void) {
        userReference.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? NSDictionary else {
                completion(nil,"Error getting data.")
                return
            }
            
            guard let user = PUser.deserialize(dict: dict, uid: uid) else {
                completion(nil,"Couldn't parse responce from the database")
                return
            }
            
            completion(user,nil)
        }
    }
    
}
