//
//  PDog.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/10/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

enum DogGender: String {
    case girl
    case boy
}

@objc class PDog: NSObject {
    
    override var hashValue: Int {
        return id.hashValue
    }
    
    static var current: PDog?
    
    var id: String
    var name: String
    var gender: DogGender
    var breed: String
    var age: TimeInterval
    var ownershipDuration: TimeInterval
    
    override init() {
        self.id = ""
        self.name = ""
        self.gender = .boy
        self.breed = ""
        self.age = 0.0
        self.ownershipDuration = 0.0
    }
    
    init(id: String, name: String, gender: DogGender, breed: String, age: TimeInterval, ownershipDuration: TimeInterval) {
        self.id = id
        self.name = name
        self.gender = gender
        self.breed = breed
        self.age = age
        self.ownershipDuration = ownershipDuration
    }
    
    static func save(_ dog: PDog) {
        PDog.current = dog
        
        let dogKey = "dog_data_\(dog.id)"
        
        defs.setValue(dog.serialize(), forKey: dogKey)
        defs.synchronize()
    }
    
    func serialize() -> NSDictionary {
        let dict = serializeWithoutID()
        dict.setValue(id, forKey: "id")
        
        return dict
    }
    
    func serializeWithoutID() -> NSDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(name, forKey: "name")
        dict.setValue(gender.rawValue, forKey: "gender")
        dict.setValue(breed, forKey: "breed")
        dict.setValue(age, forKey: "age")
        dict.setValue(ownershipDuration, forKey: "ownership-duration")
        
        return dict
    }
    
    class func deserialize(id: String) -> PDog? {
        let dogKey = "dog_data_\(id)"
        
        if let dict = defs.object(forKey: dogKey) as? NSDictionary {
            if let dog = deserialize(dict: dict) {
                return dog
            }
            return nil
        }
        return nil
    }
    
    class func deserialize(dict: NSDictionary) -> PDog? {
        if let id = dict["id"] as? String {
            let dog = deserialize(dict: dict, id: id)
            return dog
        }
        return nil
    }
    
    class func deserialize(dict: NSDictionary, id: String) -> PDog? {
        if let name = dict["name"] as? String,
            let genderString = dict["gender"] as? String,
            let gender = DogGender.init(rawValue: genderString),
            let breed =  dict["breed"] as? String,
            let age = dict["age"] as? TimeInterval,
            let ownershipDuration = dict["ownership-duration"] as? TimeInterval {
            return PDog(id: id, name: name, gender: gender, breed: breed, age: age, ownershipDuration: ownershipDuration)
        }
        return nil
    }
    
    public static func ==(lhs: PDog, rhs: PDog) -> Bool {
        return lhs.isEqual(rhs)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? PDog {            
            return self.hashValue == rhs.hashValue
        }
        return false
    }
    
}
