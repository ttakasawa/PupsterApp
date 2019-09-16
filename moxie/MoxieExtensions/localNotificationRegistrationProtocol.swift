//
//  localNotificationRegistrationProtocol.swift
//  moxie
//
//  Created by Tomoki Takasawa on 7/25/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.


import Foundation
import UIKit
import NotificationCenter
import UserNotifications
import AlamofireImage

enum NotificationAction{
    enum dismiss {
        static let rawValue = "dismiss"
    }
    enum Lesson {
        static let rawValue = "Start"
        static let identifier = "toLesson"
    }
    enum Article {
        static let rawValue = "Open"
        static let identifier = "toArticle"
    }
    enum Shop {
        static let rawValue = "Open"
        static let identifier = "toShop"
    }
    enum CategoryIdentifiers {
        static let lesson = "lessonCategory"
        static let article = "articleCategory"
        static let shop = "shopCategory"
    }
}

enum NotificationCategory{
    static let lesson = "lessonCategory"
    static let article = "articleCategory"
    static let shop = "shopCategory"
}

protocol localNotificationRegistrationProtocol: class {
    func registeringNotification(request: UNNotificationRequest)
}

struct Pupster2NotificationCategory {
    static let training = "training"
}

func getDayOfWeek(_ today:String) -> Int? {
    let formatter  = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    guard let todayDate = formatter.date(from: today) else { return nil }
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: todayDate)
    return weekDay
}

extension localNotificationRegistrationProtocol {
    func activateNotification(dow: DayOfWeek, timeInt: Int){
        let content = UNMutableNotificationContent()
        
        //let notificationTitle = "Recommendation for you"
        let notificationBody = "This is a training reminder"
        
        //content.title = notificationTitle
        content.body = notificationBody
        
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = Pupster2NotificationCategory.training
        
        let date = Date(timeIntervalSinceNow: 86400)
        //var testCalender = Calendar.Component(.weekday, from: Date())
        
        var triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        var d = Calendar.current.dateComponents([.year, .month, .weekday, .hour], from: date)
        
        
        //triggerDate.we
        
        triggerDate.hour = timeInt
        triggerDate.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        //let interval = TimeInterval(5.0)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "article", content: content, trigger: trigger)
        self.registeringNotification(request: request)
    }
    
    func registeringNotification(request: UNNotificationRequest){
        let center =  UNUserNotificationCenter.current()
        
        let open = UNNotificationAction(identifier: NotificationAction.Lesson.identifier,
                                        title: NotificationAction.Lesson.rawValue, options: [.foreground])
        let lessonCategory = UNNotificationCategory(identifier: NotificationCategory.lesson,
                                                    actions: [open],
                                                    intentIdentifiers: [],
                                                    options: [.customDismissAction])
        
        center.setNotificationCategories([lessonCategory])
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
}

extension localNotificationRegistrationProtocol where Self:articleTableViewController {
    func activateNotificationForArticle(productName: String, articleName: String){
        
        UserManager.shared.getRecommendationCollection(name: articleName) { (body) in
            if (body != "none") {
                let content = UNMutableNotificationContent()
                //let notificationTitle = "Recommendation for you"
                let notificationBody = body
                
                //content.title = notificationTitle
                content.body = notificationBody
                content.sound = UNNotificationSound.default()
                content.categoryIdentifier = NotificationCategory.shop
                
                let date = Date(timeIntervalSinceNow: 86400)
                var triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                triggerDate.hour = 18
                triggerDate.minute = 0
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                //let interval = TimeInterval(5.0)
                //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
                let request = UNNotificationRequest(identifier: "article", content: content, trigger: trigger)
                self.registeringNotification(request: request)
            }
        }
        
        
    }
    
    
}

extension localNotificationRegistrationProtocol {
//    func prepareNotificationForLesson(isComplete: Bool){
//        if (self.lessonType != LessonTypes.noSpace.meetTrainer && self.lessonType != LessonTypes.noSpace.intro && self.lessonType != LessonTypes.noSpace.trickIntro){
//
//            if (self.lessonType == LessonTypes.noSpace.certification && isComplete == true){
//                //hold off for now....
//            }else{
//                for i in 1..<7{
//                    //1..<7
//                    let intervalInt = Double(i) * 86400
//                    //let intervalInt = Double(i) * 5
//                    let interval: TimeInterval = TimeInterval(intervalInt)
//                    let notificationId = "LessoNotification" + String(describing: i)
//                    self.createNotificationContent(isComplete: isComplete, id: notificationId, interval: interval)
//                }
//            }
//
//        }
//
//    }
    
    func createNotificationContent(isComplete: Bool, id: String, interval: TimeInterval){
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = NotificationCategory.lesson
        var shouldImageAttached: Bool = false
        var notificationTitle = "Train your dog today!"
        var notificationBody = "It's time for playing with your dog!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
//        UserManager.shared.queryTwoUserInfo(firstInfo: UserManager.Data2.Fields.profileImage, secondInfo: UserManager.Data2.Fields.dog.dogName){imageUrl, dogName in
//
//            if (dogName != "none"){
//                notificationTitle = "Message from \(dogName)"
//            }
//            let lessonName = self.getLessonName(name: self.lessonType)
//            if (isComplete){
//                shouldImageAttached = true
//                let nextLesson = self.getLessonName(name: self.getNext(current: self.lessonType))
//                notificationBody = "\"We did great with \(lessonName). Let’s try \(nextLesson) today!\""
//            }else{
//                if (id == "LessoNotification1" && self.recommendingCollectionText != "none"){
//                    content.categoryIdentifier = NotificationCategory.shop
//                    shouldImageAttached = false
//                    notificationTitle = "Message from Pupster"
//                    notificationBody = self.recommendingCollectionText
//                }else{
//                    shouldImageAttached = true
//                    notificationBody = "\"Let’s keep up the progress with \(lessonName)!\""
//                }
//            }
//
//            content.title = notificationTitle
//            content.body = notificationBody
//
//            if (shouldImageAttached != true){
//                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
//                self.registeringNotification(request: request)
//                return
//            }
//
//            let dummyImageView = UIImageView()
//            if (imageUrl != "none"){
//                if let url = URL(string: imageUrl){
//                    dummyImageView.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition , runImageTransitionIfCached: true){ complete in
//                        if let imageData: UIImage = complete.value{
//                            if let attachment = UNNotificationAttachment.create(identifier: "dogImage", image: imageData, options: nil) {
//                                content.attachments = [attachment]
//                                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
//                                self.registeringNotification(request: request)
//
//                                return
//                            }
//                        }
//                    }
//                }
//            }else{
//                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
//                self.registeringNotification(request: request)
//            }
//
////            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
////            self.registeringNotification(request: request)
//
//
//        }
    }
}

