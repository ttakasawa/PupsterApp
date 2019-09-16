//
//  LabelButton.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class LabelButton: UIButton {
    
    init(title: String, labelColor: UIColor, font: UIFont){
        super.init(frame: CGRect.zero)
        self.configure(title: title, labelColor: labelColor, font: font)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, labelColor: UIColor, font: UIFont){
        self.backgroundColor = .clear
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(labelColor, for: .normal)
        
    }
}
