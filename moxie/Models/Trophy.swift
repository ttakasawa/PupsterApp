//
//  Trophy.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/22/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

struct TrophyRedeemingOptions: Codable {
    var queriedType: String
    var cost: Int   //number of trophies needed
    var reward: Int     //either $ or pounds, depending on the type
    var title: String
    var alertMessage: String
    
    var type: TrophyRedeemingType {
        var optionType: TrophyRedeemingType
        if queriedType == "discount" {
            optionType = TrophyRedeemingType.discount
        }else{
            optionType = TrophyRedeemingType.donation
        }
        return optionType
    }
    
}

enum TrophyRedeemingType {
    case donation
    case discount
}

struct Trophy: Codable {
    var id: String
    var date: Date
    var quantity: Int
    var userId: String
    var type: TrophyType
    //var typeId: String
}

struct UserTrophy: Codable {
    var trophyId: String  //This will map to whole Trophy object stored in another db
    var quantity: Int //and yet you would get all you need to calculate total for user
    var date: Date
}


struct Donation: Codable {
    var id: String
    var unit: String
    var value: Int
}


enum TrophyType: String, Codable {
    case donation
    case discount
    
    case activity
}


