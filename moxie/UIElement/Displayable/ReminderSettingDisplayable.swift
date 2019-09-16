//
//  ReminderSettingDisplayable.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation


protocol ReminderSettingDisplayable {
    var defaultReminderTime: String { get }         //This is 0 - 23
    var reminderDates: [DayOfWeek] { get }
    var isReminderOn: Bool { get }
}

extension UserData: ReminderSettingDisplayable{
    
    var defaultReminderTime: String {
        guard let notificationTime = self.notificationStatus?.notificationTime else { return "7:00 PM"}
        if notificationTime < 10 {
            return String(notificationTime) + ":00 AM"
        }else if notificationTime < 13 {
            return String(notificationTime) + ":00 AM"
        }else{
            return String(notificationTime - 12) + ":00 PM"
        }
    }
    
    var reminderDates: [DayOfWeek] {
        guard let dates = self.notificationStatus?.notificationDates else { return [] }
        return dates
    }
    
    var isReminderOn: Bool {
        return self.notificationStatus?.isNotificationOn ?? false
    }
}
