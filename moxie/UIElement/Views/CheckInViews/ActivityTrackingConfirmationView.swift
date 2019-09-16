//
//  ActivityTrackingConfirmationView.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/2/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit


class ActivityTrackingConfirmationView: UIView, Stylable {
    let nextButton = AnimatedButton()
    init (){
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.backgroundColor = self.getMainColor()
        let baseView = UIView()
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = "Got it. Don’t forget you can message us for help and advice. \n\nLet’s see how many trophies you earned today."
        label.font = self.getTitleFont()
        label.numberOfLines = 0
        label.textColor = UIColor.white
        
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = self.getWhiteColor()
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.setTitleColor(self.getMainColor(), for: .normal)
        nextButton.layer.cornerRadius = self.getCornerRadius()
        nextButton.titleLabel?.font = self.getButtonTitleFont()
        
        //nextButton.addTarget(self.superview, action: #selector(CheckInViewController.CompleteCheckIn), for: .touchUpInside)
        
        self.addSubview(baseView)
        baseView.addSubview(label)
        baseView.addSubview(nextButton)
        
        label.topAnchor.constraint(equalTo: baseView.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: baseView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: baseView.rightAnchor).isActive = true
        
        nextButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 36).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: baseView.bottomAnchor).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 207).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        baseView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        baseView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30).isActive = true
        //baseView.centerYAnchor.constrain
        baseView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 21).isActive = true
        baseView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
    }
}
