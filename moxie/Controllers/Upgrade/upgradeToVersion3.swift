//
//  upgradeToVersion3.swift
//  moxie
//
//  Created by Tomoki Takasawa on 6/16/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Alamofire

extension UserManager{
    func versionUpdate2to3(completion: () -> Void){
        //change version to 3
        
        print("create shopify here for existing user")
        MyAPIClient.sharedClient.baseURLString = "https://us-central1-moxie1-7fca0.cloudfunctions.net/app"
//        self.getUserBasics(){ userID, userEmail, userPass, userFirst, userLast in
//
//            if ((userID == "none") || (userEmail == "none") || (userPass == "none") || (userFirst == "none") || (userLast == "none")){
//                print("initialization did not go well")
//
//                self.newproblemReport(subject: "shopify account create failed", report: "@UserManager.versionUpdate2to3) for update user: " + userID + " -no userID, userEmail, userPass, or firstname")
//            }else{
//                MyAPIClient.sharedClient.createShopifyAccount(userID: userID, email: userEmail, password: userPass, firstName: userFirst, lastName: userLast){ success in
//
//                    if (success){
//                        print("successfully created an account")
//                    }
//
//                }
//            }
//        }
        //MustDo
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        if let userID = currentUser?.uid {
            let UserReference = ref.child("users").child(userID)
            UserReference.updateChildValues([Data2.Fields.versionNumber: 3, "isNewToVer3": true])
        }
        
        completion()
    }
}



