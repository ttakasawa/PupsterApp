//
//  TrophyRedeemingView.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/2/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit


class TrophyRedeemingView: UIView, Stylable {
    
    var redeemView = RedeemingView()
    var donationButton: DashBoardButton!
    var discountButton: DashBoardButton!
    
    init(){
        super.init(frame: CGRect.zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        donationButton = DashBoardButton(title: "SELECT")
        discountButton = DashBoardButton(title: "SELECT")
        
        donationButton.addTarget(self.superview, action: #selector(CheckInViewController.donationPressed), for: .touchUpInside)
        discountButton.addTarget(self.superview, action: #selector(CheckInViewController.discountPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        redeemView.backgroundColor = .clear
        
        donationButton.configureStyle(style: DashBoardMainButtonStyle(themeColor: self.getWhiteColor()))
        donationButton.setTitleColor(self.getMainColor(), for: .normal)
        
        
        discountButton.configureStyle(style: DashBoardMainButtonStyle(themeColor: self.getWhiteColor()))
        discountButton.setTitleColor(self.getMainColor(), for: .normal)
        
        redeemView.translatesAutoresizingMaskIntoConstraints = false
        donationButton.translatesAutoresizingMaskIntoConstraints = false
        discountButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(redeemView)
        self.addSubview(donationButton)
        self.addSubview(discountButton)
        
        redeemView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        redeemView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        redeemView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        redeemView.heightAnchor.constraint(equalTo: redeemView.widthAnchor, multiplier: 506.0 / 334.0).isActive = true
        
        donationButton.centerYAnchor.constraint(equalTo: redeemView.centerYAnchor).isActive = true
        donationButton.centerXAnchor.constraint(equalTo: redeemView.centerXAnchor).isActive = true
        donationButton.widthAnchor.constraint(equalToConstant: 207).isActive = true
        donationButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        discountButton.bottomAnchor.constraint(equalTo: redeemView.bottomAnchor, constant: -20).isActive = true
        discountButton.centerXAnchor.constraint(equalTo: redeemView.centerXAnchor).isActive = true
        discountButton.widthAnchor.constraint(equalToConstant: 207).isActive = true
        discountButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
}

