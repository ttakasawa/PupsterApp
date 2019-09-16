//
//  DashBoardButton.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/27/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

struct DashBoardMainButtonStyle: ButtonStylable {
    var themeColor: UIColor!
    func getCornerRadius() -> CGFloat {
        return 24
    }
    init(themeColor: UIColor) {
        self.themeColor = themeColor
    }
}

struct DashBoardSecondaryButtonStyle: ButtonStylable {
    var themeColor: UIColor!
    func getCornerRadius() -> CGFloat {
        return 16
    }
    init(themeColor: UIColor) {
        self.themeColor = themeColor
    }
}




class DashBoardButton: AnimatedButton {
    
    var actionKey: String?
    var style: ButtonStylable?
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        self.setTitle(title, for: .normal)
        self.isSelected = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureStyle(style: ButtonStylable){
        self.style = style
        self.backgroundColor = style.getBackgroundColor()
        
        self.setTitleColor(style.getTitleColor(), for: .normal)
        self.titleLabel?.font = style.getTitleFont()
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.textAlignment = .center
        
        self.layer.cornerRadius = style.getCornerRadius()
        
        self.layer.shadowColor = style.getShadowColor()
        self.layer.shadowOffset = style.getShadowOffset()
        self.layer.shadowRadius = style.getShadowRadius()
        self.layer.shadowOpacity = style.getShadowOpacity()
        
    }
    
    func attachActionKey(key: String){
        self.actionKey = key
    }
    
    func setIsActivated(isActivated: Bool){
        self.isSelected = isActivated
        if (isActivated == false) {
            self.backgroundColor = .gray
        }else{
            self.backgroundColor = self.style?.getBackgroundColor()
        }
    }
}

