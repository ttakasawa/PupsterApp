//
//  UserEndpoints.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/27/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

enum UserEndpoints: FirebaseEndpoints {
    
    case login(email: String, password: String)
    case createUser(email: String, password: String)
    case queryUser(userId: String)
    case updateUserInfo(user: UserData)
    case uploadProfileToStorage(image: UIImage, user: UserData)
    case updateProfileImageUrl(url: String, user: UserData)
    case storeUserSession(user: UserData, session: [Session])
    case updateSubscription(user: UserData, subscription: UserSubscription)
    case updateVIewIntroStatus(user: UserData, newStatus: ViewControllerIntro)
    case updateDogInfo(user: UserData, dogArr: [Dog])
    
    case uploadStripeId(user: UserData, id: String)
    
    //trophy related
    case storeTrophyTransaction(user: UserData, trophy: Trophy)
    case storeUserTrophyTransaction(user: UserData, userTrophy: [UserTrophy])
    
    //activity related
    case createCheckIn(user: UserData, checkIn: [CheckIn])
    
    
    // for notification
    case updateNotificationStatus(user: UserData, status: UserNotificationStatus)
    case updateRegistrationToken(id: String, token: String)
    
    //for ranking
    case getRanking()
    
    
    var path: String? {
        switch self {
        case .login( let email, _):
            return email
        case .createUser(email: _, password: _):
            return nil //TODO: get user url for login
        case .queryUser(let userId):
            return "users/" + userId
        case .updateUserInfo(let user):
            return "users/" + user.id
        case .updateProfileImageUrl( _, let user):
            return "users/\(user.id)/userProfileImageUrl"
        case .storeUserSession(let user, _):
            return "users/\(user.id)/sessions"
        case .updateSubscription(let user, _):
            return "users/\(user.id)/subscription"
        case .updateVIewIntroStatus(let user, _):
            return "users/\(user.id)/viewIntroduction"
        case .updateDogInfo(let user, _):
            return "users/\(user.id)/dogs"
        case .uploadProfileToStorage( _, let user):
            let userId = user.id
            return "profileImages/\(userId)/profile"
            
        case .storeTrophyTransaction(let user, let trophy):
            return "TrophyTransactions/\(user.id)/\(trophy.id)"
        case .storeUserTrophyTransaction(let user, _):
            return "users/\(user.id)/trophyTransactions"
        case .createCheckIn(let user, _):
            return "users/\(user.id)/activityCheckIns"
        case .updateNotificationStatus(let user, _):
            return "users/\(user.id)/notificationStatus"
        case .updateRegistrationToken(let id, _):
            return "users/\(id)/firMessagingRegistrationToken"
        
        case .getRanking():
            return "Ranking"
        
        case .uploadStripeId(let user, _):
            return "users/\(user.id)/stripeId"
        }
    }
    
    
    //TODO: make all cases that uses firebase encoder into one case
    var body: Any? {
        switch self {
        case .login(let email, let password), .createUser(let email, let password):
            return signInUser(email: email, password: password)
            
        case .queryUser( _), .getRanking():
            return nil
            
        case .updateUserInfo(let user):
            return self.toData(object: user)
        case .updateDogInfo( _, let dogArr):
            return self.toData(object: dogArr)
        case .updateProfileImageUrl(let url, _):
            return self.toData(object: url)
        case .storeUserSession( _, let sessions):
            return self.toData(object: sessions)
        case .updateVIewIntroStatus( _, let newStatus):
            return self.toData(object: newStatus)
        case .updateSubscription( _, let subscription):
            return self.toData(object: subscription)
        
        case .uploadProfileToStorage(let image, _):
            return mediaComponent(image: image)
            
        case .storeTrophyTransaction( _, let trophy):
            return self.toData(object: trophy)
        case .storeUserTrophyTransaction( _, let userTrophy):
            return self.toData(object: userTrophy)
        
        case .createCheckIn( _, let checkIn):
            return self.toData(object: checkIn)
            
        case .updateNotificationStatus( _, let notificationStatus):
            return self.toData(object: notificationStatus)
        
        case .updateRegistrationToken( _, let token):
            return self.toData(object: token)
        case .uploadStripeId( _, let id):
            return self.toData(object: id)
        }
    }
    
    //TODO: finish this
    var type: FirebaseEndpointType? {
        switch self {
            
        case .login( _), .updateUserInfo( _), .updateProfileImageUrl( _, _), .storeUserSession( _, _), .updateSubscription( _, _),  .updateVIewIntroStatus( _, _), .updateDogInfo( _, _), .storeTrophyTransaction( _, _), .storeUserTrophyTransaction( _, _), .createCheckIn( _, _), .updateNotificationStatus( _, _), .updateRegistrationToken( _, _), .uploadStripeId( _, _):
            return FirebaseEndpointType.storeObject
            
        case .queryUser( _), .getRanking():
            return FirebaseEndpointType.querySingleObject
            
        case .createUser( _, _), .uploadProfileToStorage( _, _):
            return nil
        }
    }
}

