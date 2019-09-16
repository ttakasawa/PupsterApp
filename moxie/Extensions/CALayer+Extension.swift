//
// Created by Joseph Daniels on 07/09/16.
// Copyright (c) 2016 Joseph Daniels. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
extension CALayer{
    var size:CGSize{
        get{ return self.bounds.size }
        set{ return self.bounds.size = newValue }
    }
    var occupation:(CGSize, CGPoint) {
        get{ return (size, self.center) }
        set{ size = newValue.0; position = newValue.1 }
    }
    var center:CGPoint{
        get{ return self.bounds.center }
    }
}
extension CGRect {
    var occupation:(CGSize, CGPoint) {
        get{ return (size, self.center) }
    }
}
