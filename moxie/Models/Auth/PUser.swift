//
//  PUser.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/9/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

@objc class PUser: NSObject {
    
    override var hashValue: Int {
        return uid.hashValue
    }
    
    static var current: PUser?
    
    var uid: String
    var firstName: String
    var lastName: String
    var email: String
    var dogId: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(uid: String) {
        self.uid = uid
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.dogId = ""
    }
    
    convenience init(uid: String, email: String) {
        self.init(uid: uid)
        self.email = email
    }
    
    init(uid: String, email: String, firstName: String, lastName: String, dogId: String) {
        self.uid = uid
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.dogId = dogId
    }
    
    static func save(_ user: PUser) {
        PUser.current = user
        
        let userKey = "user_data_\(user.uid)"
        
        defs.setValue(user.serialize(), forKey: userKey)
        defs.synchronize()
    }
    
    func serialize() -> NSDictionary {
        let dict = serializeWithoutID()
        dict.setValue(uid, forKey: "id")
        
        return dict
    }
    
    func serializeWithoutID() -> NSDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(email, forKey: "email")
        dict.setValue(firstName, forKey: "firstName")
        dict.setValue(lastName, forKey: "lastName")
        dict.setValue(dogId, forKey: "dog")
        
        return dict
    }
    
    class func deserialize(uid: String) -> PUser? {
        let userKey = "user_data_\(uid)"
        
        if let dict = defs.object(forKey: userKey) as? NSDictionary {
            if let user = deserialize(dict: dict) {
                return user
            }
            return nil
        }
        return nil
    }
    
    class func deserialize(dict: NSDictionary) -> PUser? {
        if let uid = dict["id"] as? String {
            let user = deserialize(dict: dict, uid: uid)
            return user
        }
        return nil
    }
    
    class func deserialize(dict: NSDictionary, uid: String) -> PUser? {
        if let email = dict["email"] as? String,
            let firstName = dict["firstName"] as? String,
            let lastName = dict["lastName"] as? String,
            let dogId = dict["dog"] as? String {
            return PUser(uid: uid, email: email, firstName: firstName, lastName: lastName, dogId: dogId)
        } else {
            return nil
        }
    }
    
    public static func ==(lhs: PUser, rhs: PUser) -> Bool {
        return lhs.isEqual(rhs)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? PUser {
            return self.hashValue == rhs.hashValue
        }
        return false
    }
    
}
