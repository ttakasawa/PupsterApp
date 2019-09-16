//
//  TileLabel.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/1/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

//move to other file below func
struct TileLabelStyling {
    var font: UIFont
    var color: UIColor
}

class TileLabel: UILabel {
    init(text: String, style: TileLabelStyling){
        super.init(frame: CGRect.zero)
        self.text = text
        self.configureTileLabel(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureTileLabel(style: TileLabelStyling){
        self.font = style.font
        self.textColor = style.color
        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

