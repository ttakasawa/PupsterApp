//
//  LessonEndpoints.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/27/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation


import Foundation
import UIKit

enum LessonEndpoints: FirebaseEndpoints {
    
    case getLessonContent(lessonId: String)
    case updateProgram(user: UserData, program: [Program])
    
    case getAvailableProgram
    //case enrollInProgram(programId: String)   TODO: future use..
    
    case getSubPrograms
    
    var path: String? {
        switch self {
        case .getLessonContent(let lessonId):
            return "GlobalLessons/\(lessonId)"
        case .updateProgram(let user, _):
            return "users/\(user.id)/programs/"
        case .getAvailableProgram:
            return "availablePrograms"
        case .getSubPrograms:
            return "SubPrograms"
        }
    }
    
    
    //TODO: make all cases that uses firebase encoder into one case
    var body: Any? {
        switch self {
        case .updateProgram( _, let program):
            return self.toData(object: program)
        case .getLessonContent( _), .getAvailableProgram, .getSubPrograms:
            return nil
        }
    }
    
    //TODO: finish this
    var type: FirebaseEndpointType? {
        switch self {
        case .updateProgram( _, _):
            return FirebaseEndpointType.storeObject
            
        case .getLessonContent(_ ), .getAvailableProgram, .getSubPrograms:
            return FirebaseEndpointType.querySingleObject
        }
        
    }
}
