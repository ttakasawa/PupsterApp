//
//  UserDataDepricated.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/1/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

import Foundation

enum DogTypeDepricated {
    case puppy
    case adult
    
    var name: String {
        switch self {
        case .puppy:
            return "Puppy"
        default:
            return "Adult"
        }
    }
}

enum DogSizeDepricated {
    case small
    case medium
    case large
    case giant
    
    var name: String {
        switch self {
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        case .giant:
            return "Giant"
        }
    }
}

struct UserDataDepricated {
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var dogName: String?
    var dogType: DogTypeDepricated?
    var dogSize: DogSizeDepricated?
    var lastStreak: String?
    var lastSession: String?
    
    var dictionary: [String:Any] {
        var user = [String:Any]()
        if let firstName = firstName {
            user["firstName"] = firstName
        }
        if let lastName = lastName {
            user["lastName"] = lastName
        }
        if let email = email {
            user["email"] = email
        }
        if let password = password {
            user["password"] = password
        }
        if let dogName = dogName {
            user["dogName"] = dogName
        }
        if let dogType = dogType {
            user["dogType"] = dogType.name
        }
        if let dogSize = dogSize {
            user["dogSize"] = dogSize.name
        }
        return user
    }
}
