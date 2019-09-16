//
//  CustomProgressIndicator.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/1/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit


class CustomProgressIndicator: UIProgressView {
    init(colorTheme: ThemeColorStylable) {
        super.init(frame: CGRect.zero)
        self.configure(colorTheme: colorTheme)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(colorTheme: ThemeColorStylable){
        self.progressTintColor = colorTheme.getMainColor()
        self.trackTintColor = colorTheme.getSecondaryColor()
        
        self.layer.cornerRadius = 8.5
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach { subview in
            subview.layer.masksToBounds = true
            subview.layer.cornerRadius = 8.5
        }
    }
}

