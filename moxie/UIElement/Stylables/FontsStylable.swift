//
//  FontsStylable.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

protocol TileFontsStylable {
    func getTitleFont() -> UIFont
    func getSubTitleFont() -> UIFont
    
    func getLargeScoreFont() -> UIFont
    func getMediumScoreFont() -> UIFont
    func getSmallScoreFont() -> UIFont
    
    func getUserStatFont() -> UIFont
    
    func getNormalTextFont() -> UIFont
    
    func getButtonTitleFont() -> UIFont
    
    func getSmallFont() -> UIFont
    
    func getArticleTitleFont() -> UIFont
    func getUserProfileNormalFont() -> UIFont
    func getDogNameFont() -> UIFont
}

extension TileFontsStylable {
    func getTitleFont() -> UIFont {
        return UIFont(name: "SFProDisplay-Medium", size: 23)!
    }
    
    func getSubTitleFont() -> UIFont {
        return UIFont(name: "SFProDisplay-Medium", size: 23)!
    }
    
    func getNormalTextFont() -> UIFont {
        return UIFont(name: "SFProText-Regular", size: 17)!
    }
    
    func getLargeScoreFont() -> UIFont {
        return UIFont(name: "SFProDisplay-Medium", size: 44)!
    }
    
    func getMediumScoreFont() -> UIFont {
        return UIFont(name: "SFProDisplay-Semibold", size: 21)!
    }
    
    func getSmallScoreFont() -> UIFont {
        return UIFont(name: "SFProText-Medium", size: 19)!
    }
    
    func getUserStatFont() -> UIFont {
        return UIFont(name: "SFProDisplay-Light", size: 44)!
    }
    
    func getButtonTitleFont() -> UIFont {
        return UIFont(name: "SFProText-Bold", size: 15)!
    }
    func getSmallFont() -> UIFont {
        return UIFont(name: "SFProText-Regular", size: 11)!
    }
    
    func getArticleTitleFont() -> UIFont {
        return UIFont(name: "SFProText-Semibold", size: 15)!
    }
    
    func getUserProfileNormalFont() -> UIFont {
        return UIFont(name: "SFProText-Regular", size: 15)!
    }
    
    func getDogNameFont() -> UIFont {
        return UIFont(name: "SFProDisplay-Medium", size: 44)!
    }
}
