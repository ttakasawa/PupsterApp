//
//  UserType.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/23/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

protocol UserType {
    var user: UserData? { get set }
    var session: Session? { get set }
    func login(email: String, password: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    func createUser(user: signInUser, completion: @escaping (_ userId: String?, _ error: Error?) -> Void)
    func logout(completion: @escaping (_ error: Error?) -> Void)
    
    func updateUserInfo(user: UserData, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    func queryUser(completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    
    
    func storeUserProfileImage(image: UIImage, user: UserData)
    func storeUserSession(user: UserData, sessions: [Session])
    
    func updateUserSubscription(user: UserData, subscriptionType: RegisteredPurchase, completion: @escaping ( _ success: Error?) -> Void)
    func updateDogInfo(user: UserData, dog: Dog, completion: @escaping (_ success: Bool) -> Void)
    
    func updateVIewIntroStatus(user: UserData, type: ViewControllerKind)
}

extension UserType where Self: FirebaseQueryProtocol {
    func login(email: String, password: String, completion: @escaping (_ user: UserData? , _ error: Error?) -> Void) {
        
        self.fetchAuth(endpoint: UserEndpoints.login(email: email, password: password)){ (returnUserId: String?, error: Error?) in
            self.queryUser(completion: { (user: UserData?, error: Error?) in
                completion(user, error)
            })
        }
    }
    
    func logout(completion: @escaping (_ error: Error?) -> Void) {
        try! Auth.auth().signOut()
        completion(nil)
        //TODO: implement this
    }
    
    func createUser(user: signInUser, completion: @escaping (_ userId: String?, _ error: Error?) -> Void) {
        
        self.fetchAuth(endpoint: UserEndpoints.createUser(email: user.email, password: user.password)) { (newUserId: String?, error: Error?) in
            guard let uid = newUserId else { return }
            completion(uid, nil)
        }
        
    }
    
    func updateUserInfo(user: UserData, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void) {
        
        fetchFirebase(endpoint: UserEndpoints.updateUserInfo(user: user)) { (user: UserData?, error: Error?) in
            completion(user, error)
        }
    }
    
    func queryUser(completion: @escaping (_ userData: UserData?, _ error: Error?) -> Void){
        
        if let userId = Auth.auth().currentUser?.uid {
            self.fetchFirebase(endpoint: UserEndpoints.queryUser(userId: userId)) { (userData: UserData?, error: Error?) in
                if error != nil {
                    completion(nil, error)
                }else{
                    
                    completion(userData, nil)
                }
            }
        }else{
            completion(nil, nil)
        }
        
    }

    func storeUserProfileImage(image: UIImage, user: UserData){
        self.fetchFirebaseStorage(endpoint: UserEndpoints.uploadProfileToStorage(image: image, user: user)) { (media) in
            guard let url = media?.imageUrl else { return }
            self.fetchFirebase(endpoint: UserEndpoints.updateProfileImageUrl(url: url, user: user), completion: { (user: UserData?, error: Error?) in
                //complete
            })
        }
    }
    
    func storeUserSession(user: UserData, sessions: [Session]){
        self.fetchFirebase(endpoint: UserEndpoints.storeUserSession(user: user, session: sessions), completion: { (sessions: [Session]?, error: Error?) in
            //complete
        })
    }
    
    func updateUserSubscription(user: UserData, subscriptionType: RegisteredPurchase, completion: @escaping ( _ success: Error?) -> Void){
        let subscription = UserSubscription(startDate: Date(), subscriptionType: subscriptionType)
        user.subscription = subscription
        
        Global.network.user = user
        
        self.fetchFirebase(endpoint: UserEndpoints.updateSubscription(user: user, subscription: subscription)) { (subscription: UserSubscription?, error: Error?) in
            completion(error)
        }
    }
    
    func updateDogInfo(user: UserData, dog: Dog, completion: @escaping (_ success: Bool) -> Void){
        var dogArr: [Dog] = []
        dogArr.append(dog)
        user.dogs = dogArr
        
        self.fetchFirebase(endpoint: UserEndpoints.updateDogInfo(user: user, dogArr: dogArr)) { (dogArr: [Dog]?, error: Error?) in
            if error != nil {
                completion(false)
            }else{
                completion(true)
            }
            
        }
    }
    
    func updateStripeUserId(id: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let user = self.user else { return }
        user.stripeId = id
        
        self.fetchFirebase(endpoint: UserEndpoints.uploadStripeId(user: user, id: id)) { (id: String?, error: Error?) in
            if error != nil {
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    func updateVIewIntroStatus(user: UserData, type: ViewControllerKind){
        //FIX
        var newStatus: ViewControllerIntro!
        if let introStatus = user.viewIntroduction{
            print(introStatus)
            if (type == .activity) {
                newStatus = ViewControllerIntro(activity: true, tracking: introStatus.tracking, market: introStatus.market)
            }else if (type == .tracking) {
                newStatus = ViewControllerIntro(activity: introStatus.activity, tracking: true, market: introStatus.market)
            }else if (type == .market) {
                newStatus = ViewControllerIntro(activity: introStatus.activity, tracking: introStatus.tracking, market: true)
            }else{
                return
            }

        }else{
            if (type == .activity) {
                newStatus = ViewControllerIntro(activity: true, tracking: false, market: false)
            }else if (type == .tracking) {
                newStatus = ViewControllerIntro(activity: false, tracking: true, market: false)
            }else if (type == .market) {
                newStatus = ViewControllerIntro(activity: false, tracking: false, market: true)
            }else{
                return
            }
        }
        
        user.viewIntroduction = newStatus
        
        self.fetchFirebase(endpoint: UserEndpoints.updateVIewIntroStatus(user: user, newStatus: newStatus)) { (user: UserData?, error: Error?) in
            
        }
    }
}
