//
//  UserTrophyUpdatable.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/23/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
//Trophy related
protocol UserTrophyUpdatable {
    var perentileScoreArray: [Int]? { get set }
    func createTrophyTransaction(quantity: Int, type: TrophyType, user: UserData) -> Trophy
    func storeTrophyTransaction(user: UserData, trophy: Trophy, completion: @escaping ( _ success: Bool) -> Void)
    func storeTrophyTransactionAtomically(user: UserData, trophy: Trophy, userTrophyTransactions: [UserTrophy], completion: @escaping ( _ success: Bool) -> Void)
    
    func queryRankingPercentile(completion: @escaping ( _ percentiles: [Int]) -> Void)
    
    func calculatePercentile(percentileArr: [Int], user: UserData) -> Int
}


extension UserTrophyUpdatable {
    func createTrophyTransaction(quantity: Int, type: TrophyType, user: UserData) -> Trophy {
        return Trophy(id: NSUUID().uuidString, date: Date(), quantity: quantity, userId: user.id, type: type)
    }
}

extension UserTrophyUpdatable where Self: FirebaseQueryProtocol {
    func storeTrophyTransaction(user: UserData, trophy: Trophy, completion: @escaping ( _ success: Bool) -> Void){

        var updatedTransactionRecord: [UserTrophy] = []
        if let transactionRecord = user.trophyTransactions {
            updatedTransactionRecord = transactionRecord
        }
        
        updatedTransactionRecord.append(UserTrophy(trophyId: trophy.id, quantity: trophy.quantity, date: trophy.date))
        user.trophyTransactions = updatedTransactionRecord
        Global.network.user = user
        
        self.storeTrophyTransactionAtomically(user: user, trophy: trophy, userTrophyTransactions: updatedTransactionRecord) { success in
            completion(success)
        }
    }
    
    
    func storeTrophyTransactionAtomically(user: UserData, trophy: Trophy, userTrophyTransactions: [UserTrophy], completion: @escaping ( _ success: Bool) -> Void) {
        self.firebaseAtomicStore(endpoints: [UserEndpoints.storeTrophyTransaction(user: user, trophy: trophy), UserEndpoints.storeUserTrophyTransaction(user: user, userTrophy: userTrophyTransactions)]) { (success) in
            completion(success)
        }
    }
    
    func queryRankingPercentile(completion: @escaping ( _ percentiles: [Int]) -> Void) {
        
        self.fetchFirebase(endpoint: UserEndpoints.getRanking()) { (percentiles: [Int]?, error: Error?) in
            guard let percentiles = percentiles else { return }
            completion(percentiles)
        }
        
    }
    
    
    func calculatePercentile(percentileArr: [Int], user: UserData) -> Int {
        var abovePercentileIndex: Int = 9
        let weeklyEarning = user.weeklyEarnedTrophyQuantity
        
        if let sessions = user.sessions {
            if sessions.isEmpty { return 50 }
            else{
                let firstElement = sessions[0]
                if (firstElement.startTime.isInToday){
                    print("start time is today")
                    return 50
                }
            }
        }else{
            return 50
        }
        
        for i in 0..<percentileArr.count {
            if weeklyEarning < percentileArr[i] {
                abovePercentileIndex = i
                break
            }else{
                
            }
        }
        
        var abovePercentile: Int = 0
        var belowPercentile: Int = 0
        var percentile: Int = 0
        
        if abovePercentileIndex == 9 {
            percentile = 90
        }else if abovePercentileIndex > 0 {
            abovePercentile = percentileArr[abovePercentileIndex]
            belowPercentile = percentileArr[abovePercentileIndex - 1]
            let lastDigit = Int((Double(weeklyEarning - belowPercentile) / Double(abovePercentile - belowPercentile)) * 10)
            percentile = (abovePercentileIndex - 1) * 10 + lastDigit
            
        }else{
            abovePercentile = percentileArr[abovePercentileIndex]
            belowPercentile = 0
            let lastDigit = Int((Double(weeklyEarning - belowPercentile) / Double(abovePercentile - belowPercentile)) * 10)
            
            percentile = lastDigit
        }
        
        if(percentile < 10){
            return 10
        }else{
            return percentile
        }
        
    }
}










