//
//  DrawViews.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit


@IBDesignable
class BasicUpgrade : UIView {
    override func draw(_ rect: CGRect) {
        //StyleKit.drawBasicStandardNotSelected(frame: rect)
        StyleKit.draw_1MonthNotSelected(frame: rect)
    }
}
@IBDesignable
class BasicUpgradeCheck : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.draw_1MonthSelected(frame: rect)
        //StyleKit.drawBasicStandardNotSelected(frame: rect)
    }
}
@IBDesignable
class BasicUpgradeDiscounted : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.drawBasicDiscountNotSelected(frame: rect)
    }
}
@IBDesignable
class BasicUpgradeDiscountedChecked : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.drawBasicSelectedDiscount(frame: rect)
    }
}



@IBDesignable
class SixMonthsPremium : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.draw_6monthnotselected(frame: rect)
    }
}
@IBDesignable
class SixMonthsPremiumCheck : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.draw_6monthSelected(frame: rect)
    }
}
@IBDesignable
class PlusUpgradeDiscounted : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.drawPlusDiscountNotSelected(frame: rect)
    }
}
@IBDesignable
class PlusUpgradeDiscountedChecked : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.drawPlusSelectedDiscount(frame: rect)
    }
}



@IBDesignable
class OneYearPremium : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.draw_12MonthsNotSelected(frame: rect)
    }
}
@IBDesignable
class OneYearPremiumCheck : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.draw_12MonthsSelected(frame: rect)
    }
}
@IBDesignable
class PremiumUpgradeDiscounted : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.drawPremiumDiscountNotSelected(frame: rect)
    }
}
@IBDesignable
class PremiumUpgradeDiscountedChecked : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.drawPremiumSelectedDiscount(frame: rect)
    }
}


//Redeeming trophy view
@IBDesignable
class RedeemingView : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.drawRedeemScreen(frame: rect)
    }
}

@IBDesignable
class GwenDetail : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.drawConciergeDetails(frame: rect)
    }
}

@IBDesignable
class BillDetail : UIView {
    override func draw(_ rect: CGRect) {
        StyleKit.drawBillTile(frame: rect)
    }
}

@IBDesignable
class SettingsButton : UIButton {
    override func draw(_ rect: CGRect) {
        StyleKit.drawSettings(frame: rect)
    }
}
