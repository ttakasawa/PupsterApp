//
//  Activity.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/22/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation


struct CheckIn: Codable {
    var id: String
    var activity: [Activity]?
    var date: Date
}

struct Activity: Codable {
    var id: String
    var type: ActivityType
    var dogs: [DogActivity]? = []
}

struct DogActivity: Codable {
    var dogId: String
    var rating: Double?
    var globalLessonId: String?
}

enum ActivityType: String, Codable {
    case walk
    case play
    case train
    case park
    case feed
    case water
    case cuddle
    case adventure
    case socialize
    
}
