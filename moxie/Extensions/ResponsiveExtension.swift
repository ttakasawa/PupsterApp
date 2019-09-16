//
//  ResponsiveExtension.swift
//  BikeNav
//
//  Created by Tymofii Dolenko on 6/8/18.
//  Copyright © 2018 BikeNav. All rights reserved.
//

import Foundation
import UIKit

typealias BNDimension = CGFloat

enum ScrenDimension: CGFloat {
    case xHeight = 812
    case eightHeight = 667
    case plusHeight = 736
    case seHeight = 568
    case xWidth = 375
    case plusWidth = 414
    case seWidth = 320
}

extension BNDimension {
    func isLessThan(_ dimension: ScrenDimension) -> Bool {
        return self < dimension.rawValue
    }
    
    func isGreaterThan(_ dimension: ScrenDimension) -> Bool {
        return self > dimension.rawValue
    }
    
    func isEqual(_ dimension: ScrenDimension) -> Bool {
        return self == dimension.rawValue
    }
}

extension UIViewController {
    
    var height: BNDimension {
        get {
            return UIScreen.main.bounds.height
        }
    }
    
    var width: BNDimension {
        get {
            return UIScreen.main.bounds.width
        }
    }
    
}

