//
//  CheckInStylables.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/4/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit



extension Stylable where Self: CheckInActivityButton {
    func getMainColor() -> UIColor{
        return UIColor(red:0.21, green:0.22, blue:0.6, alpha:0.4)
    }
    func getSecondaryColor() -> UIColor{
        return UIColor(red:0.21, green:0.22, blue:0.6, alpha:0.06)
    }
    
}

extension Stylable where Self: ActivitySelectingView {
    func getTitleFont() -> UIFont{
        return UIFont(name: "SFProDisplay-Semibold", size: 26)!
    }
    func getButtonTitleFont() -> UIFont{
        return UIFont(name: "SFProText-Bold", size: 15)!
    }
    func getCornerRadius() -> CGFloat {
        return 22
    }
}

extension Stylable where Self: RateSettingView {
    func getTitleFont() -> UIFont{
        return UIFont(name: "SFProDisplay-Semibold", size: 34)!
    }
    func getSubTitleFont() -> UIFont {
        return UIFont(name: "SFProDisplay-Light", size: 33)!
    }
    func getNormalTextFont() -> UIFont {
        return UIFont(name: "SFProText-Semibold", size: 14)!
    }
    func getButtonTitleFont() -> UIFont{
        return UIFont(name: "SFProText-Bold", size: 15)!
    }
}

extension Stylable where Self: ActivityTrackingConfirmationView {
    func getTitleFont() -> UIFont{
        return UIFont(name: "SFProDisplay-Semibold", size: 34)!
    }
    func getButtonTitleFont() -> UIFont{
        return UIFont(name: "SFProText-Bold", size: 15)!
    }
    func getCornerRadius() -> CGFloat {
        return 22
    }
}

extension Stylable where Self: ActivityTrackingRewardingView {
    func getButtonTitleFont() -> UIFont{
        return UIFont(name: "SFProText-Bold", size: 15)!
    }
    func getCornerRadius() -> CGFloat {
        return 22
    }
}
