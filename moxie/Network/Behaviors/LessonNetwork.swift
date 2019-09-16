//
//  LessonType.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/23/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation


protocol LessonNetwork {
    func getCurrentLessonIds(program: Program) -> String
    func getNextLesson(program: Program, currentLessonId: String) -> String
    
    //model w/ firebase
    func getLessonContent(lessonId: String, completion: @escaping (_ lessonContent: GlobalLesson) -> Void)
    func markComplete(lessonId: String, user: UserData, userProgram: Program, completion: @escaping (_ isReady: Bool) -> Void)
    
    func updateUserPickedLessons(lessonId: String, program: Program, user: UserData, completion: @escaping (_ success: Bool) -> Void)
}

extension LessonNetwork {
    func getCurrentLessonIds(program: Program) -> String{
        return program.currentLessonId
    }
    
    func getNextLesson(program: Program, currentLessonId: String) -> String {
        for i in 0..<program.subPrograms.count {
            let subProgram = program.subPrograms[i]
            if currentLessonId == subProgram.globalLessonIds.last {
                return "none"
            }
            for j in 0..<subProgram.globalLessonIds.count{
                if currentLessonId == subProgram.globalLessonIds[j] {
                    return subProgram.globalLessonIds[j + 1]
                }
            }
        }
        return "none"
    }
}

extension LessonNetwork where Self: FirebaseQueryProtocol {
    func getLessonContent(lessonId: String, completion: @escaping (_ lessonContent: GlobalLesson) -> Void){
        self.fetchFirebase(endpoint: LessonEndpoints.getLessonContent(lessonId: lessonId)) { (content: GlobalLesson? , error: Error?) in
            if let content = content {
                completion(content)
            }
        }
    }
    
    func markComplete(lessonId: String, user: UserData, userProgram: Program, completion: @escaping (_ isReady: Bool) -> Void){
        
        var currentIndex = 0
        var didRemoved: Bool = false
        
        for i in 0..<userProgram.subPrograms.count{
            let subProgram = userProgram.subPrograms[i]
            for j in 0..<subProgram.globalLessonIds.count {
                if (subProgram.globalLessonIds[j] == lessonId){
                    subProgram.areCompleted[currentIndex] = true
                }
                currentIndex = currentIndex + 1
            }
            currentIndex = 0
        }
        
        if var userSelections = userProgram.userSelectedLessonId {
            for i in 0..<userSelections.count {
                if userSelections[i] == lessonId {
                    userSelections.remove(at: i)
                    didRemoved = true
                    break
                }
            }
            userProgram.userSelectedLessonId = userSelections
        }
        
        completion(true)
        
        self.fetchFirebase(endpoint: LessonEndpoints.updateProgram(user: user, program: [userProgram])) { (program: [Program]?, error: Error?) in
            
            if didRemoved {
                print("item removed from selection")
            }
        }
    }
    
    
    func updateUserPickedLessons(lessonId: String, program: Program, user: UserData, completion: @escaping (_ success: Bool) -> Void) {
        if lessonId == program.currentLessonId || lessonId == program.nextLessonId {
            completion(false)
            return
        }
        
        if var usersSelections = program.userSelectedLessonId {
            
            if usersSelections.count < 1 {
                usersSelections.append(lessonId)
            }else if usersSelections.count < 2 {
                
                if lessonId != usersSelections[0] {
                    usersSelections.append(lessonId)
                }else{
                    completion(false)
                    return
                }
                
            }else{
                usersSelections = [usersSelections[1], lessonId]
            }
            program.userSelectedLessonId = usersSelections
        }else{
            program.userSelectedLessonId = [lessonId]
        }
        
        self.fetchFirebase(endpoint: LessonEndpoints.updateProgram(user: user, program: [program])) { (program: [Program]?, error: Error?) in
            completion(true)
        }
    }
}










