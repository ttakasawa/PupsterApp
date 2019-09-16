//
//  TileStylable.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit





protocol Stylable: TileFontsStylable, ColorStylable, RoundViewStylable {
}

extension Stylable {
    
    func getCornerRadius() -> CGFloat {
        return 8
    }
    
    func getShadowOffset() -> CGSize {
        return CGSize(width: 0, height: 1)
    }
    
    func getShadowColor() -> CGColor {
        return UIColor(red:0, green:0, blue:0, alpha:0.3).cgColor
    }
    
    func getShadowOpacity() -> Float {
        return 1
    }
    
    func getShadowRadius() -> CGFloat {
        return 2
    }
}

//extension Stylable where Self:
