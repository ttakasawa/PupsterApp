//
//  AnalyticsUpdatable.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/26/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import Firebase

protocol AnalyticsUpdatable {
    func logFirebaseEvents(logEventsName: String, parameterd: [String : Any]?)
    
}


extension AnalyticsUpdatable where Self: FirebaseQueryProtocol {
    func logFirebaseEvents(logEventsName: String, parameterd: [String : Any]?) {
        Firebase.Analytics.logEvent(logEventsName, parameters: parameterd)
    }
}
