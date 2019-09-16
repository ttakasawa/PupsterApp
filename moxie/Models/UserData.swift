//
//  UserData.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/19/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

struct UserNotificationStatus: Codable {
    var notificationTime: Int
    var isNotificationOn: Bool
    var notificationDates: [DayOfWeek]? = []
}

class UserData: Codable {
    
    init (id: String, email: String, firstName: String, lastName: String, dogs: Dog){
        self.id = id
        self.email = email
        self.dogs?.append(dogs)
        self.firstName = firstName
        self.lastName = lastName
        
        self.trophyTransactions = []
        self.programs = []
        self.sessions = []
        self.donations = []
        self.readArticleIds = []
        self.activityCheckIns = []
        self.notificationStatus = UserNotificationStatus(notificationTime: 19, isNotificationOn: false, notificationDates: [])
        self.version = 4
        self.isUnreadMessage = true
//        self.notificationTime = 19
//        self.isNotificationOn = false
//        self.notificationDates = []
    }
    
    var id: String
    var email: String
    var firstName: String
    var lastName: String
    var dogs: [Dog]? = []
    var trophyTransactions: [UserTrophy]? = []
    var programs: [Program]? = []
    var sessions: [Session]? = []
    var donations: [Donation]? = []
    var readArticleIds: [String]? = []
    var notificationStatus: UserNotificationStatus?
    
    var activityCheckIns: [CheckIn]? = []
    var percentMostActive: Int?
    var firMessagingRegistrationToken: String?
    var subscription: UserSubscription?
    
    var userProfileImageUrl: String?
    var isUnreadMessage: Bool?
    
    var version: Int?
    
    var viewIntroduction: ViewControllerIntro?
    
    var stripeId: String?
    
    var isFirstTime: Bool {
        if let sessions = sessions{
            return sessions.isEmpty
        }else{
            return true
        }
    }
    
    var dailyStreak: Int {
        var streak: Int = 0
        guard let sessions = sessions else { return 1 }
        for i in 0..<sessions.count {
            let index = sessions.count - i - 1
            if (index == 0){ break }

            if (sessions[index].startTimeDateSinceEpoch - sessions[index - 1].endTimeDateSinceEpoch == 1){
                streak = streak + 1
            }else if (sessions[index].startTimeDateSinceEpoch - sessions[index - 1].endTimeDateSinceEpoch == 0){
                //streak = streak
            }else{
                break
            }
            
        }
        return streak + 1
    }
    
    var currentTrophyQuantity: Int {
        var currentTrophies: Int = 0
        guard let trophyTransactions = trophyTransactions else { return 0 }
        for i in 0..<trophyTransactions.count {
            currentTrophies = currentTrophies + trophyTransactions[i].quantity
        }
        return currentTrophies
    }
    
    var weeklyEarnedTrophyQuantity: Int {
        var currentTrophies: Double = 0
        let firstLogin = self.sessions?[0].startTime ?? Date()//Int(startTime.timeIntervalSince1970) / 86400
        var numberOfDays = Double((Date().timeIntervalSince1970 - firstLogin.timeIntervalSince1970 ) / 86400)
        guard let trophyTransactions = trophyTransactions else { return 0 }
        for i in 0..<trophyTransactions.count {
            
            if (trophyTransactions[i].quantity > 0) && (Date().isInSameWeek(date: trophyTransactions[i].date)){
                currentTrophies = currentTrophies + Double(trophyTransactions[i].quantity)
            }
        }
        if numberOfDays > 6 {
            return Int(currentTrophies)
        }else{
            if numberOfDays == 0 {
                numberOfDays = 1
            }
            return Int(currentTrophies / numberOfDays) * 7
        }
        //return currentTrophies

    }
    
    var isOnSubscription: Bool {
        guard let currentSubscription = self.subscription else { return false }
        if currentSubscription.subscriptionType == RegisteredPurchase.trial {
            if currentSubscription.startDate.pastTwoWeeks() {
                return true
            }else{
                return false
            }
            
        }else{
            return true
        }
    }

}

struct Session: Codable {
    var startTime: Date
    var endTime: Date
    
    var startTimeDateSinceEpoch: Int {
        return Int(startTime.timeIntervalSince1970) / 86400
    }
    var endTimeDateSinceEpoch: Int {
        return Int(endTime.timeIntervalSince1970) / 86400
    }
    //var purchases: [Purchase]
}


class UserSubscription: Codable {
    var startDate: Date
    var subscriptionType: RegisteredPurchase
    init(startDate: Date, subscriptionType: RegisteredPurchase){
        self.startDate = startDate
        self.subscriptionType = subscriptionType
    }
}


struct ViewControllerIntro: Codable {
    var activity: Bool?
    var tracking: Bool?
    var market: Bool?
}




