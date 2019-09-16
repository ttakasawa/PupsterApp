////
////  RateSettingView.swift
////  moxie
////
////  Created by Tomoki Takasawa on 10/2/18.
////  Copyright © 2018 Tomoki Takasawa. All rights reserved.
////

import UIKit


class RateSettingView: UIView, Stylable {
    var progressBar = CustomSlider()
    var titleLabel = UILabel()
    var statusLabel = UILabel()
    var rateLabel = UILabel()
    //var nextButton: AnimatedButton!
    
    init(){
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.backgroundColor = self.getMainColor()
        titleLabel.text = "Wonderful—How did training go?"
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.font = self.getTitleFont()
        titleLabel.textColor = self.getWhiteColor()
        
        statusLabel.text = "COMPLETELY OKAY"
        statusLabel.numberOfLines = 1
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.textAlignment = .center
        statusLabel.font = self.getSubTitleFont()
        statusLabel.textColor = self.getWhiteColor()
        
        rateLabel.text = "RATE YOUR PROGRESS"
        rateLabel.numberOfLines = 1
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.adjustsFontSizeToFitWidth = true
        rateLabel.textAlignment = .center
        rateLabel.font = self.getNormalTextFont()
        rateLabel.textColor = self.getWhiteColor()
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(titleLabel)
        self.addSubview(statusLabel)
        self.addSubview(progressBar)
        self.addSubview(rateLabel)
        //self.addSubview(nextButton)
        
        self.constrain()
    }
    
    func constrain(){
        statusLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        statusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 45).isActive = true
        
        progressBar.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 23).isActive = true
        progressBar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        progressBar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 28).isActive = true
        //progressBar.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        rateLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 25).isActive = true
        rateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 21).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -30).isActive = true
        //MustDo: change this for different type of iphone
        
        progressBar.setValue(0.5, animated: false)
        progressBar.addTarget(self, action: #selector(self.ratingChanged), for: .valueChanged)
        
        
        progressBar.addTarget(self.superview, action: #selector(CheckInViewController.ratingChangedFinished), for: .valueChanged)
        
    }
    
    func switchRateType(type: ActivityType){
        if type == .walk {
            titleLabel.text = "Wonderful—How did walking go?"
        }else if type == .train{
            titleLabel.text = "Wonderful—How did training go?"
        }else{
            titleLabel.text = "Wonderful—How did the day go?"
        }
    }
    
    @objc func ratingChanged(slider: CustomSlider){
        if slider.value < 0.2 {
            statusLabel.text = "REALLY TERRIBLE"
        }else if slider.value < 0.4 {
            statusLabel.text = "SOMEWHAT BAD"
        }else if slider.value < 0.6 {
            statusLabel.text = "COMPLETELY OKAY"
        }else if slider.value < 0.8 {
            statusLabel.text = "PRETTY GOOD"
        }else{
            statusLabel.text = "SUPER AWESOME"
        }
    }
}


class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customWidth = ScreenSize.SCREEN_WIDTH - 56
        let rect:CGRect = CGRect(x: 0, y: 0, width: customWidth, height: 8)
        
        return rect
    }
}
