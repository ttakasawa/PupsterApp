//
//  DashBoardObject.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/30/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

enum DashboardActions {
    case completeLesson //(lesson: UserLesson)
    case playVideo  //(videoUrl: String)
    case viewProgram
    case openArticle
    
    case trackActivity
    case changeProfileImage
    case notificationToggle //(isOn: Bool)
    case setNotificationDay //(day: DayOfWeek)
    case subscribePupster
    case openSetting
}

enum DashBoardKind {
    case activity
    case tracking
}

protocol DashboardType {
    var dashboardKind: DashBoardKind { get }
    func performAction(action: DashboardActions)    //Why would I need to call this function to perform action? Why not on VC?
    
}


class ActivityTrackingDashBoardType: DashboardType {
    
    var dashboardKind: DashBoardKind {
        return .activity
    }
    func performAction(action: DashboardActions) {
        print(action)
    }
}


class TrackingDashBoardType: DashboardType {
    
    var dashboardKind: DashBoardKind {
        return .tracking
    }
    func performAction(action: DashboardActions) {
        print("action")
    }
}

