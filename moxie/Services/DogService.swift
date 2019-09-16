//
//  DogService.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/10/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import Firebase

class DogService {
    
    static let shared = DogService()
    
    let dogReference = Database.database().reference().child("dogs")
    
    func setCurrent(dog: PDog) {
        PDog.save(dog)
    }
    
    func uploadDogToDatabase(completion: @escaping (String?)->Void) {
        guard let current = PUser.current, let dog = PDog.current else {
            completion("Not authorized")
            return
        }
        dogReference.childByAutoId().setValue(dog.serializeWithoutID()) { (error, ref) in
            current.dogId = ref.key!
            dog.id = ref.key!
            PDog.save(dog)
            PUser.save(current)
            UserService.shared.uploadProfileToDatabase(completion: completion)
        }
    }
    
    func getDogFromFirebase(id: String, completion: @escaping (PDog?,String?)->Void) {
        dogReference.child(id).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? NSDictionary else {
                completion(nil,"Error getting data.")
                return
            }
            
            guard let dog = PDog.deserialize(dict: dict, id: id) else {
                completion(nil,"Couldn't parse responce from the database")
                return
            }
            
            completion(dog,nil)
        }
    }
}
