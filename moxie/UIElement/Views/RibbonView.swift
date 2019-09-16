//
//  RibbonView.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit



enum RibbonDirection {
    case vertical
    case horizontal
}

class RibbonView: UIView {
    init(font: UIFont, direction: RibbonDirection, text: String? = nil){
        super.init(frame: CGRect.zero)
        self.configure(font: font, direction: direction, text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(font: UIFont, direction: RibbonDirection, text: String? = nil){
        if let text = text, direction == .horizontal {
            let ribbonText = TileLabel(text: text, style: TileLabelStyling(font: font, color: UIColor.white))
            ribbonText.textAlignment = .right
            self.addSubview(ribbonText)
            
            ribbonText.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            ribbonText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -23.5).isActive = true
            ribbonText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        let ribbonImage = UIImageView()
        ribbonImage.translatesAutoresizingMaskIntoConstraints = false
        
        if direction == .horizontal {
            //MustDo: setImage, and add
        }else{
            //MustDo: setImage
        }
    }
}



