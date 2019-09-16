//
//  SubscriptionButton.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

enum SubscriptionButtonType {
    case basic
    case plus
    case premium
    
    case sixMonth
    case oneYear
}

class SubscriptionButton: UIButton {
    
    var isDiscounted: Bool!
    var subscriptionButtonType: SubscriptionButtonType
    
    init(subscriptionButtonType: SubscriptionButtonType) {
        self.subscriptionButtonType = subscriptionButtonType
        super.init(frame: CGRect.zero)
        self.isDiscounted = false
        self.configure(subscriptionButtonType: subscriptionButtonType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure(subscriptionButtonType: SubscriptionButtonType){
        //self.back
        
        if self.subscriptionButtonType == .basic {
            let buttonDesignView = BasicUpgrade()
            self.placeOverLay(with: buttonDesignView)
        }else if self.subscriptionButtonType == .sixMonth {
            let buttonDesignView = SixMonthsPremium()
            self.placeOverLay(with: buttonDesignView)
        }else{
            let buttonDesignView = OneYearPremium()
            self.placeOverLay(with: buttonDesignView)
        }
        
    }
    
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if self.isSelected == true {
            if ((self.subviews.count > 1) && (self.isDiscounted == false)) {
                return
            }
            if ((self.subviews.count > 3) && (self.isDiscounted == true)){
                return
            }
            if self.subscriptionButtonType == .basic{
                
                let checkedDiscountedView = BasicUpgradeCheck()
                self.placeOverLay(with: checkedDiscountedView)
                
            }else if self.subscriptionButtonType == .sixMonth{
                
                let checkedDiscountedView = SixMonthsPremiumCheck()
                self.placeOverLay(with: checkedDiscountedView)
                
            }else{
                
                let checkedDiscountedView = OneYearPremiumCheck()
                self.placeOverLay(with: checkedDiscountedView)
                
            }
        } else {
            //remove top view
            
//            if isDiscounted == false{
//                if self.subviews.count == 2 {
//                    let lastView = self.subviews.last
//                    lastView?.removeFromSuperview()
//                }
//            }else{
//                if self.subviews.count == 4 {
//                    let lastView = self.subviews.last
//                    lastView?.removeFromSuperview()
//                }
//            }
            
            if self.subviews.count == 2 {
                let lastView = self.subviews.last
                lastView?.removeFromSuperview()
            }
            
        }
    }
    
    func placeOverLay(with view: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        view.isUserInteractionEnabled = false
        
    }
}

//extension SubscriptionButton {
//    func discountActivate(){
//        self.isDiscounted = true
//        let buttonDesignView = BasicUpgradeDiscounted()
//        self.placeOverLay(with: buttonDesignView)
//
//        if self.subscriptionButtonType == .basic {
//            let buttonDesignView = BasicUpgradeDiscounted()
//            self.placeOverLay(with: buttonDesignView)
//        }else if self.subscriptionButtonType == .plus {
//            let buttonDesignView = PlusUpgradeDiscounted()
//            self.placeOverLay(with: buttonDesignView)
//        }else{
//            let buttonDesignView = PremiumUpgradeDiscounted()
//            self.placeOverLay(with: buttonDesignView)
//        }
//    }
//}
