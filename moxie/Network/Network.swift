//
//  Network.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/20/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

protocol TypeNetwork: FirebaseQueryProtocol, UserType, LessonNetwork, ArticleType, ActivityTrackable, MessageProtocol, NotificationSetable, UserTrophyUpdatable, AnalyticsUpdatable, PupsterAPIRequest {
}


struct Global {
    class Network: TypeNetwork {
        
        var baseURLString: String = "https://us-central1-moxie1-7fca0.cloudfunctions.net/app"
        
        var adminId: String = "9pXwaz1BtmbCxtxRTq7T8hyWNJG3"
        
        var perentileScoreArray: [Int]?
        
        
        var currentSender: Sender? {
            if let user = self.user {
                return Sender(id: (user.id), displayName: (user.firstName))
            }else{
                //TODO: swap this to real one
                return Sender(id: "test", displayName: "user")
            }
        }
        
        var userProfileImage: UIImage?
        
        var firebaseDBConnection: DatabaseReference
        var user: UserData?
        var now: Date?
        var session: Session?
        var initialMessages: [Message]?
        
        init() {
            self.firebaseDBConnection = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        }
        
        func getRecentMessages(){
            if let user = self.user {
                self.getMessages(user: user, count: 15) { messages in
                    self.initialMessages = messages
                }
            }
        }
        
    }
    class DemoNetwork: TypeNetwork {
        var baseURLString: String = "https://us-central1-moxie1-7fca0.cloudfunctions.net/app"
        var adminId: String = "9pXwaz1BtmbCxtxRTq7T8hyWNJG3"
        var perentileScoreArray: [Int]?
        var firebaseDBConnection: DatabaseReference
        
        var userProfileImage: UIImage?
        
        var currentSender: Sender? {
            if let user = self.user {
                return Sender(id: (user.id), displayName: (user.firstName))
            }else{
                return Sender(id: "test", displayName: "user")
            }
        }
        
        var user: UserData?
        var now: Date?
        var session: Session?
        var initialMessages: [Message]?
        
        init() {
            self.firebaseDBConnection = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        }
        
        func getRecentMessages(){ }
    }
    
    
    static var network: Network = Network()
}

