//
//  NotificationSetable.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/23/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import NotificationCenter
import UserNotifications


protocol NotificationSetable {
    
    func setNotification(user: UserData, actionType: NotificationActionType, dowChanged: DayOfWeek?)
    
    func scheduleNotification(dow: DayOfWeek, timeInt: Int)
    func changeNotificationTime(status: UserNotificationStatus)
    func cancelIndividualNotification(dow: DayOfWeek)
    func cancelAllNotification()
    
    func updateRegistrationToken(id: String, token: String)
}


extension NotificationSetable {
    
    func scheduleNotification(dow: DayOfWeek, timeInt: Int){
        
        
        let id = dow.notificationId
        let notificationTitle = "How did today go?"
        let notificationBody = "Don't forget to track your pup's activity."
        
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = NotificationCategory.lesson
        content.title = notificationTitle
        content.body = notificationBody
        
        let date = Date(timeIntervalSinceNow: 3600)
        
        var triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
        triggerWeekly.weekday = dow.intVal
        triggerWeekly.hour = timeInt
        triggerWeekly.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        let center =  UNUserNotificationCenter.current()
        
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func cancelAllNotification(){
        let center =  UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func cancelIndividualNotification(dow: DayOfWeek){
        let center =  UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [dow.notificationId])
        
    }
    
    func changeNotificationTime(status: UserNotificationStatus){
        guard let dows = status.notificationDates else { return }
        let timeInt = status.notificationTime
        for i in 0..<dows.count {
            scheduleNotification(dow: dows[i], timeInt: timeInt)
        }
    }
    
    func activateNotification(status: UserNotificationStatus, dow: DayOfWeek){
        scheduleNotification(dow: dow, timeInt: status.notificationTime)
    }
}


extension NotificationSetable where Self: FirebaseQueryProtocol {
    func setNotification(user: UserData, actionType: NotificationActionType, dowChanged: DayOfWeek? = nil){
        //TODO: This whole process needs to be optimized.
        
        guard let status = user.notificationStatus else { return }
        self.fetchFirebase(endpoint: UserEndpoints.updateNotificationStatus(user: user, status: status)) { (returnedStatus: UserNotificationStatus?, error: Error?) in
            if actionType == .activateIndividualNotification {
                guard let dow = dowChanged else {
                    print("set dow")
                    return
                }
                self.activateNotification(status: status, dow: dow)
            }else if actionType == .cancelIndividualNotification {
                guard let dow = dowChanged else {
                    print("set dow")
                    return
                }
                self.cancelIndividualNotification(dow: dow)
            }else if actionType == .cancelAllNotification {
                self.cancelAllNotification()
            }else{
                self.changeNotificationTime(status: status)
            }
        }
    }
    
    func updateRegistrationToken(id: String, token: String){
        self.fetchFirebase(endpoint: UserEndpoints.updateRegistrationToken(id: id, token: token)) { (user: UserData?, error: Error?) in
            //print(error)
        }
    }
}


enum NotificationActionType {
    case activateIndividualNotification
    case cancelIndividualNotification
    case cancelAllNotification
    case updateTime
}






