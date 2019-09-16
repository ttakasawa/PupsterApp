//
//  ProgramSelectable.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/23/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation


//Program related
protocol ProgramSelectable {
    //for any trophy actions
    func getAvailableProgram(completion: @escaping (_ availablePrograms: [AvailableProgram]) -> Void)
    func enrollInProgram(programId: String, completion: @escaping (_ program: Program) -> Void)
    func populateUserLesson(program: Program, completion: @escaping(_ program: Program) -> Void)
}

extension ProgramSelectable {
    //TODO: Check line 26
    func populateUserLesson(program: Program) -> Program{
        var userProgram: Program = program
        for i in 0..<userProgram.subPrograms.count {
            for j in 0..<userProgram.subPrograms[i].globalLessonIds.count {
//                userProgram.subPrograms[i].lessons?.append(UserLesson(globalLessonId: program.subPrograms[i].globalLessonIds[j], isCompleted: false))
            }
        }
        return userProgram
    }
}


//TODO: think through Program instatiation process when enrolling
extension ProgramSelectable where Self:FirebaseQueryProtocol {
    func getAvailableProgram(completion: @escaping (_ availablePrograms: [AvailableProgram]) -> Void){
//        self.fetchFirebase(endpoint: .getAvailableProgram) { (programs: [AvailableProgram]?, error: Error?) in
//            if (error != nil) { return }
//            guard let programs = programs else { return }
//            completion(programs)
//        }
    }
    func enrollInProgram(programId: String, completion: @escaping (_ program: Program) -> Void){
//        self.fetchFirebase(endpoint: .enrollInProgram(programId: programId, user: user)) { (program: Program?, error: Error?) in
//            if (error != nil) { return }
//            guard let program = program else { return }
//            completion(self.populateUserLesson(program: program))
//        }
    }
    
    
}
