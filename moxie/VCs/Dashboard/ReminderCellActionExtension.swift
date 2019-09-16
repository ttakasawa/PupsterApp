//
//  ReminderCellActionExtension.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/27/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

extension NewDashboardViewController {
    
    // reminder cell actions
    
    func addNotificationDate(dow: DayOfWeek){
        guard let user = self.network.user else { return }
        var newDates:[DayOfWeek] = []
        var newStatus: UserNotificationStatus!
        if var currentStatus = user.notificationStatus {
            if let currentDates = currentStatus.notificationDates {
                newDates = currentDates
            }
            newDates.append(dow)
            newStatus = UserNotificationStatus(notificationTime: currentStatus.notificationTime, isNotificationOn: true, notificationDates: newDates)
            currentStatus.notificationDates = newDates
        }else{
            newStatus = UserNotificationStatus(notificationTime: 19, isNotificationOn: true, notificationDates: [dow])
            
        }
        user.notificationStatus = newStatus
        self.network.setNotification(user: user, actionType: NotificationActionType.activateIndividualNotification, dowChanged: dow)
        self.turnOnToggle()
    }
    
    func removeNotificationDate(dow: DayOfWeek){
        guard let user = self.network.user else { return }
        var newDates:[DayOfWeek] = []
        var newStatus: UserNotificationStatus!
        
        if let currentStatus = user.notificationStatus {
            guard let statusArray = currentStatus.notificationDates else { return }
            for i in 0..<statusArray.count {
                if(statusArray[i] != dow){
                    newDates.append(statusArray[i])
                }
            }
            newStatus = UserNotificationStatus(notificationTime: currentStatus.notificationTime, isNotificationOn: currentStatus.isNotificationOn, notificationDates: newDates)
        }
        user.notificationStatus = newStatus
        
        self.network.setNotification(user: user, actionType: NotificationActionType.cancelIndividualNotification, dowChanged: dow)
    }
    
    func removeAllNotifications(){
        guard let user = self.network.user else { return }
        var newStatus: UserNotificationStatus!
        if let currentStatus = user.notificationStatus {
            newStatus = UserNotificationStatus(notificationTime: currentStatus.notificationTime, isNotificationOn: false, notificationDates: [])
        }else{
            newStatus = UserNotificationStatus(notificationTime: 19, isNotificationOn: false, notificationDates: [])
        }
        
        user.notificationStatus = newStatus
        
        self.network.setNotification(user: user, actionType: .cancelAllNotification)
        self.resetAllButton()
    }
    
    func setTime(timeInt: Int){
        print(timeInt)
        guard let user = self.network.user else { return }
        var newStatus: UserNotificationStatus!
        if var currentStatus = user.notificationStatus {
            newStatus = UserNotificationStatus(notificationTime: timeInt, isNotificationOn: currentStatus.isNotificationOn, notificationDates: currentStatus.notificationDates)
            currentStatus = newStatus
        }else{
            newStatus = UserNotificationStatus(notificationTime: timeInt, isNotificationOn: false, notificationDates: [])
        }
        
        user.notificationStatus = newStatus
        
        self.network.setNotification(user: user, actionType: .updateTime)
        if let reminderCell = self.middleTile as? ReminderCell {
            reminderCell.changeTimeValue(timeInt: timeInt)
        }
    }
    func turnOnToggle(){
        if let reminderCell = self.middleTile as? ReminderCell {
            reminderCell.notificationSwitch.setOn(true, animated: true)
        }
    }
    
    func resetAllButton(){
        if let reminderCell = self.middleTile as? ReminderCell {
            reminderCell.initializeAllButton()
        }
    }
}


//MARK: button actions
@objc extension NewDashboardViewController {
    
    func sunPressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Sun) : removeNotificationDate(dow: .Sun)
    }
    
    func monPressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Mon) : removeNotificationDate(dow: .Mon)
    }
    
    func tuePressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Tue) : removeNotificationDate(dow: .Tue)
    }
    func wedPressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Wed) : removeNotificationDate(dow: .Wed)
    }
    
    func thuPressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Thu) : removeNotificationDate(dow: .Thu)
    }
    
    func friPressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Fri) : removeNotificationDate(dow: .Fri)
    }
    
    func satPressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Sat) : removeNotificationDate(dow: .Sat)
    }
    
    func notificationToggled(sender: UISwitch){
        if (sender.isOn == false){
            removeAllNotifications()
        }
    }
    
    func timeSelectionPressed(sender: UIButton){
        let alert = UIAlertController(title: "Set Reminder Time", message: nil, preferredStyle: .actionSheet)
        for i in 0..<24 {
            var stringVal: String = ""
            if i < 12 {
                stringVal = String(describing: i) + ":00 AM"
            }else if (i == 12) {
                stringVal = String(describing: i) + ":00 PM"
            }else{
                stringVal = String(describing: i - 12) + ":00 PM"
            }
            alert.addAction(UIAlertAction(title: stringVal, style: .default, handler: { _ in
                self.setTime(timeInt: i)
            }))
        }
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
