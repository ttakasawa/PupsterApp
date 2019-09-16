//
//  Program.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/22/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

class Program: Codable {
    var id: String
    var name: String
    var subPrograms: [SubProgram] = []
    var subProgramIds: [String]
    var userSelectedLessonId: [String]?
    
    init(id: String, name: String, subPrograms: [SubProgram], subProgramIds: [String]){
        self.id = id
        self.name = name
        self.subPrograms = subPrograms
        self.subProgramIds = subProgramIds
    }
    
    var totalLessons: Int {
        var lessons: Int = 0
        for i in 0..<subPrograms.count{
            lessons = lessons + subPrograms[i].totalLessonCount
        }
        
        return lessons
    }
    
    var completedLessons: Int {
        var lessons: Int = 0
        for i in 0..<subPrograms.count{
            lessons = lessons + subPrograms[i].completedLessonCount
        }
        
        return lessons
    }
    
    var progress: Double {
        return Double(self.completedLessons) / Double(self.totalLessons)
    }
    
    var currentLessonId: String {
        if let selectedLessons = userSelectedLessonId {
            if selectedLessons.count > 0 {
                return selectedLessons[0]
            }
        }
        for i in 0..<subPrograms.count{
            let subProgram = subPrograms[i]
            for j in 0..<subProgram.globalLessonIds.count {
                if (subProgram.areCompleted[j] == false) {
                    
                    if(i == subPrograms.count - 1 && j == subProgram.globalLessonIds.count - 1){
                        break
                    }else{
                        return subProgram.globalLessonIds[j]
                    }
                }
            }
        }
        
        let lastSubProgram = subPrograms[subPrograms.count - 1]
        return lastSubProgram.globalLessonIds[lastSubProgram.globalLessonIds.count - 2]
    }
    
    var nextLessonId: String {
        if let selectedLessons = userSelectedLessonId {
            if selectedLessons.count > 1 {
                return selectedLessons[1]
            }
        }
        var isPassed: Int = 0
        for i in 0..<subPrograms.count{
            let subProgram = subPrograms[i]
            for j in 0..<subProgram.globalLessonIds.count {
                if (subProgram.areCompleted[j] == false) {
                    if (isPassed == 0){
                        isPassed = isPassed + 1
                    }else{
                        if let userSelection = self.userSelectedLessonId {
                            if userSelection.count > 0 {
                                if subProgram.globalLessonIds[j] == userSelection[0] {
                                    continue
                                }
                            }
                        }
                        
                        return subProgram.globalLessonIds[j]
                    }
                }
            }
        }
        
        let lastSubProgram = subPrograms[subPrograms.count - 1]
        return lastSubProgram.globalLessonIds[lastSubProgram.globalLessonIds.count - 1]
    }

    func getLessonIndex(lessonId: String) -> Int {
        var index: Int = 1
        for i in 0..<subPrograms.count{
            let subProgram = subPrograms[i]
            for j in 0..<subProgram.globalLessonIds.count {
                if (lessonId == subProgram.globalLessonIds[j]){
                    return index
                }
                index = index + 1
            }
        }
        return 0
    }
    
    func getSubProgramName(lessonId: String) -> String {
        if let currentSubProgram = self.searchCurrentSubProgram(lessonId: lessonId) {
            return currentSubProgram.name
        }else{
            return "The Basics"
        }
    }
    
    func searchCurrentSubProgram(lessonId: String) -> SubProgram? {
        for i in 0..<subPrograms.count{
            let subProgram = subPrograms[i]
            for j in 0..<subProgram.globalLessonIds.count {
                if (lessonId == subProgram.globalLessonIds[j]){
                    return subProgram
                }
            }
        }
        return nil
    }
    
    func getSubProgramArticleIds(lessonId: String) -> [String] {
        if let currentSubProgram = self.searchCurrentSubProgram(lessonId: lessonId) {
            guard let articleIds = currentSubProgram.recommendedArticleIds else {
                return []
            }
            return articleIds
        }else{
            return []
        }
    }
    
}

class SubProgram: Codable {
    var id: String
    var name: String
    var globalLessonIds: [String]
    var areCompleted: [Bool]
    var recommendedArticleIds: [String]?
    
    var totalLessonCount: Int {
        return globalLessonIds.count
    }
    
    var completedLessonCount: Int {
        var count: Int = 0
        for i in 0..<self.areCompleted.count {
            if (self.areCompleted[i]){
                count = count + 1
            }
        }
        return count
    }
    
    var isComplete: Bool {
        return totalLessonCount == completedLessonCount
    }
    
    func initializeCompletionStatus(){
        for _ in 0..<self.globalLessonIds.count {
            self.areCompleted.append(false)
        }
    }
    
    init(id: String, name: String, globalLessonIds: [String], recommendedArticleIds: [String]){
        self.id = id
        self.name = name
        self.globalLessonIds = globalLessonIds
        self.areCompleted = []
        self.recommendedArticleIds = recommendedArticleIds
        
        self.initializeCompletionStatus()
    }
}

struct UserLesson: Codable {
    //TODO: delete it
    var globalLessonId: String
    var isCompleted: Bool = false
}

struct LessonInfo {
    //for table view use
    var id: String
    var name: String
    var completionStatus: Bool
}

class GlobalLesson: Codable {
    var id: String
    var name: String
    var videos: [Video]
    var articleIds: [String]? = []
    init (id: String, name: String, videoUrls: [String], thumbnailUrls: [String]){
        self.id = id
        self.name = name
        self.videos = []
        for i in 0..<videoUrls.count {
            let video = Video(videoUrl: videoUrls[i], thumbnailUrl: thumbnailUrls[i])
            self.videos.append(video)
        }
    }
    
}


struct Video: Codable {
    var videoUrl: String
    var thumbnailUrl: String
}





struct AvailableProgram: Codable {
    var id: String
    var title: String
    var programDescription: String
    // might contain trailer video??
}



