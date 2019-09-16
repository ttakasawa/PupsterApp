//
//  UIColor+Extension.swift
//  HAY
//
//  Created by Tymofii Dolenko on 2/23/18.
//  Copyright © 2018 Timofey Dolenko. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(_ hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
