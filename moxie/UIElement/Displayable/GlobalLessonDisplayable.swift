//
//  GLobalLessonDisplayable.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

protocol GlobalLessonDisplayable {
    var globalLessonId: String { get }
    var lessonName: String { get }
    var viewableVideos: [Video] { get }
}


extension GlobalLesson: GlobalLessonDisplayable {
    var viewableVideos: [Video] {
        return self.videos
    }
    
    var globalLessonId: String {
        return self.id
    }
    
    var lessonName: String {
        return self.name
    }
}
