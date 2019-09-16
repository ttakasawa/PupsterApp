//
//  Styling.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/27/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

//TODO: get rid of it
protocol Styling {
    func getMainColor() -> UIColor
    func getSecondaryColor() -> UIColor
    func getFont() -> UIFont
}



//Style for round view
protocol RoundViewStylable {
    func getCornerRadius() -> CGFloat
    func getShadowOffset() -> CGSize
    func getShadowColor() -> CGColor
    func getShadowOpacity() -> Float
    func getShadowRadius() -> CGFloat
}

