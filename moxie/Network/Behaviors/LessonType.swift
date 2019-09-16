//
//  LessonType.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/23/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

//rename Lesson network
protocol LessonNetwork {
    func getCurrentLessonIds(program: Program) -> String
    func getNextLesson(program: Program, currentLessonId: String) -> String
    
    //model w/ firebase
    func getLessonContent(lessonId: String, completion: @escaping (_ lessonContent: GlobalLesson) -> Void)
    func markComplete(user: UserData, lesson: UserLesson)
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
//        self.fetchFirebase(endpoint: .getLessonContent(lessonId: lessonId)) { (content: GlobalLesson? , error: Error?) in
//            if let content = content {
//                completion(content)
//            }
//        }
        
        //MustDo: Uncomment this and work with firebase
        
        let tempGlobalLesson = GlobalLesson(id: "sitLesson", name: "Sit", videoUrls: ["8n64erk559", "413oxzmsow", "o17muj90om", "2awo9uy7xb", "g77j1xem1t"], thumbnailUrls: ["https://cdn.shopify.com/s/files/1/0090/0841/4778/files/Bringing_a_new_dog_home.png?v=1529955241", "https://cdn.shopify.com/s/files/1/0090/0841/4778/files/Bringing_a_new_dog_home.png?v=1529955241", "https://cdn.shopify.com/s/files/1/0090/0841/4778/files/Bringing_a_new_dog_home.png?v=1529955241", "https://cdn.shopify.com/s/files/1/0090/0841/4778/files/Bringing_a_new_dog_home.png?v=1529955241", "https://cdn.shopify.com/s/files/1/0090/0841/4778/files/Bringing_a_new_dog_home.png?v=1529955241"])
        
        
        completion(tempGlobalLesson)
    }
    
    func markComplete(user: UserData, lesson: UserLesson){
        //change userLesson part, and update User???
        self.fetchFirebase(endpoint: .markComplete(user: user, lesson: lesson)) { (user: UserLesson? , error: Error?) in
        }
    }
}









