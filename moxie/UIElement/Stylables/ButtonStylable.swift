//
//  ButtonStylable.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

//style for button
protocol ButtonStylable: RoundViewStylable {
    var themeColor: UIColor! { get }
    func getTitleFont() -> UIFont
    func getBackgroundColor() -> UIColor
    func getTitleColor() -> UIColor
}

extension ButtonStylable {
    
    func getBackgroundColor() -> UIColor {
        return self.themeColor
    }
    
    func getTitleColor() -> UIColor {
        return UIColor.white
    }
    
    func getTitleFont() -> UIFont {
        return UIFont(name: "SFProText-Bold", size: 13)!
    }
    
    func getShadowRadius() -> CGFloat {
        return 3
    }
    
    func getShadowOffset() -> CGSize {
        return CGSize(width: 0, height: 3)
    }
    
    func getShadowColor() -> CGColor {
        return UIColor.clear.cgColor
    }
    
    func getShadowOpacity() -> Float {
        return 0
    }
}

