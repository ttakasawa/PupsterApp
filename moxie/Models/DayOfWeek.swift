//
//  DayOfWeek.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/22/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

enum DayOfWeek: String, Codable {
    case Sun
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
    
    var intVal: Int {
        switch self {
            
        case .Sun:
            return 1
        case .Mon:
            return 2
        case .Tue:
            return 3
        case .Wed:
            return 4
        case .Thu:
            return 5
        case .Fri:
            return 6
        case .Sat:
            return 7
        }
    }
    
    var notificationId: String {
        switch self {
            
        case .Sun:
            return "Sun"
        case .Mon:
            return "Mon"
        case .Tue:
            return "Tue"
        case .Wed:
            return "Wed"
        case .Thu:
            return "Thu"
        case .Fri:
            return "Fri"
        case .Sat:
            return "Sat"
        }
    }
}
