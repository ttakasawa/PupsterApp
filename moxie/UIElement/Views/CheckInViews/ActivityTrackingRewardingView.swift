//
//  ActivityTrackingRewardingView.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/2/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit


class ActivityTrackingRewardingView: UIView, Stylable {
    
    
    var baseView: UserProfileCell!
    var trophyAddedView: UIView!
    let nextButton = AnimatedButton()
    var numberOfTrophyAdded: TileLabel!
    
    var user: UserProfileDisplayable!
    
    init (){
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self.superview, action: #selector(CheckInViewController.showRedeemingView), for: .touchUpInside)
        numberOfTrophyAdded = TileLabel(text: "", style: TileLabelStyling(font: UIFont(name: "SFProText-Heavy", size: 44)!, color: .white))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTrophyAdded(numberOfTrophies: Int){
        numberOfTrophyAdded.text = "+" + String(describing: numberOfTrophies)
    }
    
    func configure(data: UserProfileDisplayable){
        self.user = data
        
        baseView = UserProfileCell()
        
        
        baseView.configure(data: data, isOnDashBoard: false)
        trophyAddedView = UIView()
        
        let trophyLogo = UIImageView(image: #imageLiteral(resourceName: "trophyIcon"))
        trophyLogo.translatesAutoresizingMaskIntoConstraints = false
        
        
        numberOfTrophyAdded.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = self.getMainColor()
        
        baseView.backgroundColor = self.getWhiteColor()
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        
        trophyAddedView.backgroundColor = .clear
        trophyAddedView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.trophyAddedView)
        if (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS){
            //potentially alternative
        }else{
            self.addSubview(self.baseView)
        }
        
        self.trophyAddedView.addSubview(trophyLogo)
        self.trophyAddedView.addSubview(numberOfTrophyAdded)
        
        self.addSubview(nextButton)
        
        
        
        
        self.trophyAddedView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.trophyAddedView.heightAnchor.constraint(equalToConstant: 67).isActive = true
        
        
        
        
        if (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS){
            //alt?
            
            self.trophyAddedView.bottomAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            nextButton.topAnchor.constraint(equalTo: trophyAddedView.bottomAnchor, constant: 40).isActive = true
        }else{
            
            self.trophyAddedView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60).isActive = true
            
            self.baseView.topAnchor.constraint(equalTo: self.trophyAddedView.bottomAnchor, constant: 50).isActive = true
            self.baseView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.baseView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
            
            
            self.baseView.alpha = 0
            
            nextButton.topAnchor.constraint(equalTo: self.baseView.bottomAnchor, constant: 40).isActive = true
        }
        
        
        trophyLogo.leftAnchor.constraint(equalTo: trophyAddedView.leftAnchor).isActive = true
        trophyLogo.topAnchor.constraint(equalTo: trophyAddedView.topAnchor).isActive = true
        trophyLogo.bottomAnchor.constraint(equalTo: trophyAddedView.bottomAnchor).isActive = true
        trophyLogo.widthAnchor.constraint(equalTo: trophyLogo.heightAnchor).isActive = true
        
        numberOfTrophyAdded.leftAnchor.constraint(equalTo: trophyLogo.rightAnchor, constant: 12).isActive = true
        numberOfTrophyAdded.centerYAnchor.constraint(equalTo: trophyLogo.centerYAnchor).isActive = true
        trophyAddedView.rightAnchor.constraint(equalTo: numberOfTrophyAdded.rightAnchor).isActive = true
        
        
        self.trophyAddedView.alpha = 0
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = self.getWhiteColor()
        nextButton.setTitle("GET REWARD", for: .normal)
        nextButton.setTitleColor(self.getMainColor(), for: .normal)
        nextButton.layer.cornerRadius = self.getCornerRadius()
        nextButton.titleLabel?.font = self.getButtonTitleFont()
        self.nextButton.alpha = 0
        
        
        nextButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 230).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    func startAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.animationOne()
        }
        
    }
    
    func animationOne(){
        UIView.animate(withDuration: 1.0, animations: {
            self.trophyAddedView.alpha = 1
        }) { (_) in
            self.secondAnimation()
            
        }
    }
    
    func secondAnimation(){
        UIView.animate(withDuration: 1.0, animations: {
            if (DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 ){
                self.nextButton.alpha = 1
            }else{
                self.baseView.alpha = 1
                self.nextButton.alpha = 1
            }
            
        }, completion: nil)
    }
}



