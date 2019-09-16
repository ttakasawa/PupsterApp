//
//  ActivityTrackable.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/22/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

//check in process
protocol ActivityTrackable {
    
    func createActivity(activitiesDone: [ActivityType], dogActivity: [DogActivity]) -> [Activity]
    func createCheckIn(user: UserData, activities: [Activity])
}

extension ActivityTrackable {
    
    func createActivity(activitiesDone: [ActivityType], dogActivity: [DogActivity]) -> [Activity] {
        var activityList: [Activity] = []
        
        for i in 0..<activitiesDone.count {
            var dogList: [DogActivity] = []
            for j in 0..<dogActivity.count {
                if activitiesDone[i] == .train{
                    dogList.append(dogActivity[j])
                }else{
                    dogList.append(DogActivity(dogId: dogActivity[j].dogId, rating: nil, globalLessonId: nil))
                }
            }
            activityList.append(Activity(id: NSUUID().uuidString, type: activitiesDone[i], dogs: dogList))
        }
        return activityList
    }
}

extension ActivityTrackable where Self: FirebaseQueryProtocol {
    func createCheckIn(user: UserData, activities: [Activity]) {
        
        let todayCheckIn = CheckIn(id: NSUUID().uuidString, activity: activities, date: Date())
        var checkIns: [CheckIn] = []
        
        if let currentCheckIns = user.activityCheckIns {
            checkIns.append(contentsOf: currentCheckIns)
        }
        
        checkIns.append(todayCheckIn)
        
        user.activityCheckIns = checkIns
        
        self.fetchFirebase(endpoint: UserEndpoints.createCheckIn(user: user, checkIn: checkIns)) { (checkInArray: [CheckIn]?, error: Error?) in
            if error != nil {
                return
            }
        }
    }
}

