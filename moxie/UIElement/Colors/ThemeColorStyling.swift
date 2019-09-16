//
//  ThemeColorStyling.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/28/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

protocol ThemeColorStylable {
    var mainColor: UIColor! { get }
    var secondaryColor: UIColor! { get }    //TODO: should be removed
    func getMainColor() -> UIColor
    func getSecondaryColor() -> UIColor
    func getPinkColor() -> UIColor
    func getTextColor() -> UIColor
    func getLightTextColor() -> UIColor
    func getWhiteColor() -> UIColor
}

extension ThemeColorStylable {
    
    func getMainColor() -> UIColor {
        return self.mainColor
    }
    
    func getSecondaryColor() -> UIColor {
        return self.secondaryColor
    }
    
    func getPinkColor() -> UIColor {
        return UIColor(red:1, green:0.2, blue:0.4, alpha:1)
    }
    
    func getTextColor() -> UIColor {
        return UIColor.darkGray
    }
    
    func getLightTextColor() -> UIColor {
        return UIColor(red:0.39, green:0.38, blue:0.44, alpha:1)
    }
    
    func getWhiteColor() -> UIColor {
        return UIColor.white
    }
}


struct ThemeColorStyling: ThemeColorStylable {
    var mainColor: UIColor!
    var secondaryColor: UIColor!
    
    init(mainColor: UIColor, secondaryColor: UIColor) {
        self.mainColor = mainColor
        self.secondaryColor = secondaryColor
    }
}














protocol ColorStylable {
    func getMainColor() -> UIColor
    func getSecondaryColor() -> UIColor
    func getPinkColor() -> UIColor
    func getTextColor() -> UIColor
    func getLightTextColor() -> UIColor
    func getWhiteColor() -> UIColor
    //func getDarkWhite()-> UIColor
}

extension ColorStylable {
    
    func getMainColor() -> UIColor {
        return UIColor(red:0.09, green:0.75, blue:0.93, alpha:1)
        //return UIColor(red:1, green:0.2, blue:0.4, alpha:1)
    }
    
    func getSecondaryColor() -> UIColor {
        return UIColor(red:1, green:0.69, blue:0.13, alpha:1)
    }
    
    func getPinkColor() -> UIColor {
        return UIColor(red:1, green:0.2, blue:0.4, alpha:1)
    }
    
    func getTextColor() -> UIColor {
        return UIColor.darkGray
    }
    
    func getLightTextColor() -> UIColor {
        return UIColor(red:0.39, green:0.38, blue:0.44, alpha:1)
    }
    
    func getWhiteColor() -> UIColor {
        return UIColor.white
    }
    
//    func getDarkWhite()-> UIColor {
//
//    }
}
