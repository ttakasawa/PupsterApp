//
//  DashboardCell.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit


class DashBoardCell: UIView, Stylable {
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureTileStyle() {
        self.layer.cornerRadius = self.getCornerRadius()
        self.backgroundColor = UIColor.white
        self.layer.shadowOffset = self.getShadowOffset()
        self.layer.shadowColor = self.getShadowColor()
        self.layer.shadowOpacity = self.getShadowOpacity()
        self.layer.shadowRadius = self.getShadowRadius()
    }
}

extension RoundViewStylable where Self: DashBoardCell{
    func getCornerRadius() -> CGFloat {
        return 8
    }
    
    func getShadowOffset() -> CGSize {
        return CGSize(width: 0, height: 1)
    }
    
    func getShadowColor() -> CGColor {
        return UIColor(red:0, green:0, blue:0, alpha:0.3).cgColor
    }
    
    func getShadowOpacity() -> Float {
        return 1
    }
    
    func getShadowRadius() -> CGFloat {
        return 2
    }
}
