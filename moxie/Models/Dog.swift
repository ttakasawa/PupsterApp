//
//  Dog.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/22/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation


struct Dog: Codable {
    var id: String
    var name: String
    var gender: Gender
    var birthTime: Date
    var ownershipStart: Date
    var breed: String
    var profileImageUrl: String?
    
    
}

enum Mood: String, Codable {
    case hungry
    case tired
    case energized
    
    var result: String {
        switch self {
        case .hungry:
            return "Hungry"
        case .tired:
            return "Tired"
        case .energized:
            return "Energized"
        }
    }
}




enum Gender: String, Codable {
    case male
    case female
    
    var gender: String {
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        }
    }
}




