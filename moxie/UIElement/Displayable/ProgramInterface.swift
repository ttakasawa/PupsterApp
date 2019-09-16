//
//  ProgramInterface.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

class ProgramInterface: ProgramDisplayable {
    var program: Program
    var globalLesson: GlobalLesson
    
    var subProgramName: String {
        return self.program.getSubProgramName(lessonId: self.globalLesson.id)
    }
    
    var title: String {
        return "Mission #" + String(self.program.getLessonIndex(lessonId: self.globalLesson.id))
    }
    
    init(program: Program, lesson: GlobalLesson){
        self.program = program
        self.globalLesson = lesson
    }
}



