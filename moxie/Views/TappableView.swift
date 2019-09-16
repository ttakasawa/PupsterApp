//
//  TappableView.swift
//  BikeNav
//
//  Created by Tymofii Dolenko on 7/19/18.
//  Copyright © 2018 BikeNav. All rights reserved.
//

import UIKit

class TappableView: UIView {
    
    var tappedCallback: (()->Void)?

    func setHighlighted(_ highlighted: Bool) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setHighlighted(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setHighlighted(false)
        guard let touch = touches.first else {return}
        if self.bounds.contains(touch.location(in: self)) {
            tappedCallback?()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        setHighlighted(false)
    }

}
