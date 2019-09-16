//
//  UserProfileDisplayable.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

protocol UserProfileDisplayable {
    //var profileImage
    var currentScoreInt: Int { get }
    var maxScoreInt: Int { get }
    var restScoreInt: Int { get }
    var dailyLogInStreak: Int { get }
    var activePercentage: Int { get }
    var profileImageUrl: String? { get }
    var profileImage: UIImage? { get set }
    
    var isActivated: Bool { get }
}

extension UserData: UserProfileDisplayable {
    
    var maxScoreInt: Int {
        return 125
    }
    var currentScoreInt: Int {
        if self.maxScoreInt < self.currentTrophyQuantity {
            return self.maxScoreInt
        }
        return self.currentTrophyQuantity
    }
    var restScoreInt: Int {
        if self.maxScoreInt == self.currentScoreInt {
            return 0
        }
        return self.maxScoreInt - self.currentScoreInt
    }
    var dailyLogInStreak: Int {
        print("streaak")
        print(self.dailyStreak)
        return self.dailyStreak
    }
    var activePercentage: Int {
        return self.percentMostActive ?? 50
    }
    var profileImageUrl: String? {
        return self.userProfileImageUrl
    }
    var profileImage: UIImage? {
        get{
            return self.profileImage
        }
        set{
            self.profileImage = newValue
        }
        
    }
    
    var isActivated: Bool {
        if let latestCheckInDate = self.activityCheckIns?.last?.date {
            if (latestCheckInDate.isInToday) {
                //MustDo:newdas chang this to false
                return false
            }
        }
        return true
    }
}
