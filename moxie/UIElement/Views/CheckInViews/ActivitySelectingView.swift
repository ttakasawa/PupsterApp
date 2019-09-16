//
//  ActivitySelectingView.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/2/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit



class ActivitySelectingView: UIView, Stylable {
    
    var titleLabel: UILabel!
    
    var walkButton: CheckInActivityButton!
    var playButton: CheckInActivityButton!
    var trainButton: CheckInActivityButton!
    var parkButton: CheckInActivityButton!
    var feedButton: CheckInActivityButton!
    var waterButton: CheckInActivityButton!
    var cuddleButton: CheckInActivityButton!
    var adventureButton: CheckInActivityButton!
    var socializeButton: CheckInActivityButton!
    
    var nextButton = AnimatedButton()
    
    init(){
        super.init(frame: CGRect.zero)
        self.isUserInteractionEnabled = true
        
        self.backgroundColor = self.getMainColor()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        walkButton = CheckInActivityButton()
        walkButton.configure(type: .walk)
        
        playButton = CheckInActivityButton()
        playButton.configure(type: .play)
        
        trainButton = CheckInActivityButton()
        trainButton.configure(type: .train)
        
        parkButton = CheckInActivityButton()
        parkButton.configure(type: .park)
        
        feedButton = CheckInActivityButton()
        feedButton.configure(type: .feed)
        
        waterButton = CheckInActivityButton()
        waterButton.configure(type: .water)
        
        cuddleButton = CheckInActivityButton()
        cuddleButton.configure(type: .cuddle)
        
        adventureButton = CheckInActivityButton()
        adventureButton.configure(type: .adventure)
        
        socializeButton = CheckInActivityButton()
        socializeButton.configure(type: .socialize)
        
        walkButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        trainButton.translatesAutoresizingMaskIntoConstraints = false
        parkButton.translatesAutoresizingMaskIntoConstraints = false
        feedButton.translatesAutoresizingMaskIntoConstraints = false
        waterButton.translatesAutoresizingMaskIntoConstraints = false
        cuddleButton.translatesAutoresizingMaskIntoConstraints = false
        adventureButton.translatesAutoresizingMaskIntoConstraints = false
        socializeButton.translatesAutoresizingMaskIntoConstraints = false
        
        setActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(dog: Dog){
        
        
        let buttonWidth = (ScreenSize.SCREEN_WIDTH - 48 - 48 - 20 - 20) / 3.0
        //TODO: This can be represented better by using TileLabel
        titleLabel = UILabel()
        titleLabel.text = "What did you and \(dog.name) do today?"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = self.getWhiteColor()
        titleLabel.numberOfLines = 2
        titleLabel.font = self.getTitleFont()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        
        //TODO: This can be represented better by using DashboardButton
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = self.getWhiteColor()
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.setTitleColor(self.getMainColor(), for: .normal)
        nextButton.layer.cornerRadius = self.getCornerRadius()
        nextButton.titleLabel?.font = self.getButtonTitleFont()
        
        
        
        self.addSubview(titleLabel)
        
        self.addSubview(walkButton)
        self.addSubview(playButton)
        self.addSubview(trainButton)
        self.addSubview(parkButton)
        self.addSubview(feedButton)
        self.addSubview(waterButton)
        self.addSubview(cuddleButton)
        self.addSubview(adventureButton)
        self.addSubview(socializeButton)
        
        self.addSubview(nextButton)
        
        self.constrain(buttonWidth: buttonWidth)
        
    }
    
    func constrain(buttonWidth: CGFloat){
        walkButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        walkButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        playButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        trainButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        trainButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        parkButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        parkButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        feedButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        feedButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        waterButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        waterButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        cuddleButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        cuddleButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        adventureButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        adventureButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        socializeButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        socializeButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        
        
        
        
        feedButton.bottomAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        feedButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        
        //top
        playButton.bottomAnchor.constraint(equalTo: feedButton.topAnchor, constant: -20).isActive = true
        playButton.centerXAnchor.constraint(equalTo: feedButton.centerXAnchor).isActive = true
        
        walkButton.rightAnchor.constraint(equalTo: playButton.leftAnchor, constant: -20).isActive = true
        walkButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
        
        trainButton.leftAnchor.constraint(equalTo: playButton.rightAnchor, constant: 20).isActive = true
        trainButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
        
        
        
        //middle
        parkButton.rightAnchor.constraint(equalTo: feedButton.leftAnchor, constant: -20).isActive = true
        parkButton.centerYAnchor.constraint(equalTo: feedButton.centerYAnchor).isActive = true
        
        waterButton.leftAnchor.constraint(equalTo: feedButton.rightAnchor, constant: 20).isActive = true
        waterButton.centerYAnchor.constraint(equalTo: feedButton.centerYAnchor).isActive = true
        
        
        
        //bottom
        adventureButton.topAnchor.constraint(equalTo: feedButton.bottomAnchor, constant: 20).isActive = true
        adventureButton.centerXAnchor.constraint(equalTo: feedButton.centerXAnchor).isActive = true
        
        cuddleButton.rightAnchor.constraint(equalTo: adventureButton.leftAnchor, constant: -20).isActive = true
        cuddleButton.centerYAnchor.constraint(equalTo: adventureButton.centerYAnchor).isActive = true
        
        socializeButton.leftAnchor.constraint(equalTo: adventureButton.rightAnchor, constant: 20).isActive = true
        socializeButton.centerYAnchor.constraint(equalTo: adventureButton.centerYAnchor).isActive = true
        
        
        
        titleLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -26).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 54).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        nextButton.topAnchor.constraint(equalTo: adventureButton.bottomAnchor, constant: 29).isActive = true
        nextButton.leftAnchor.constraint(equalTo: cuddleButton.leftAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        nextButton.rightAnchor.constraint(equalTo: adventureButton.rightAnchor, constant: 20).isActive = true
    }
    
    func setActions(){
        walkButton.addTarget(self.superview, action: #selector(CheckInViewController.walkActivityPressed), for: .touchUpInside)
        playButton.addTarget(self.superview, action: #selector(CheckInViewController.playActivityPressed), for: .touchUpInside)
        trainButton.addTarget(self.superview, action: #selector(CheckInViewController.trainActivityPressed), for: .touchUpInside)
        
        parkButton.addTarget(self.superview, action: #selector(CheckInViewController.parkActivityPressed), for: .touchUpInside)
        feedButton.addTarget(self.superview, action: #selector(CheckInViewController.feedActivityPressed), for: .touchUpInside)
        waterButton.addTarget(self.superview, action: #selector(CheckInViewController.waterActivityPressed), for: .touchUpInside)
        
        cuddleButton.addTarget(self.superview, action: #selector(CheckInViewController.cuddleActivityPressed), for: .touchUpInside)
        adventureButton.addTarget(self.superview, action: #selector(CheckInViewController.adventureActivityPressed), for: .touchUpInside)
        socializeButton.addTarget(self.superview, action: #selector(CheckInViewController.socializeActivityPressed), for: .touchUpInside)
        
        nextButton.addTarget(self.superview, action: #selector(CheckInViewController.completeActivitySelection), for: .touchUpInside)
    }
    
    
}







class CheckInActivityButton: UIButton, Stylable {
    
    var selectedColor: UIColor!
    var defaultColor: UIColor!
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setAction()
        //self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setAction()
        //self.configure()
    }
    
    
    func configure(type: ActivityType){
        self.selectedColor = self.getMainColor()
        self.defaultColor = self.getSecondaryColor()
        
        self.backgroundColor = self.defaultColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = self.getCornerRadius()
        
        if type == .adventure {
            self.setBackgroundImage(#imageLiteral(resourceName: "activityButtonAdventure"), for: .normal)
            //TODO: adventure
        }else if type == .cuddle {
            self.setBackgroundImage(#imageLiteral(resourceName: "activityButtonCuddle"), for: .normal)
        }else if type == .feed {
            self.setBackgroundImage(#imageLiteral(resourceName: "activityButtonFeed"), for: .normal)
        }else if type == .park {
            self.setBackgroundImage(#imageLiteral(resourceName: "activityButtonPark"), for: .normal)
        }else if type == .play {
            self.setBackgroundImage(#imageLiteral(resourceName: "activityButtonPlay"), for: .normal)
        }else if type == .socialize {
            self.setBackgroundImage(#imageLiteral(resourceName: "activityButtonSocialize"), for: .normal)
        }else if type == .train {
            self.setBackgroundImage(#imageLiteral(resourceName: "activityButtonTrain"), for: .normal)
        }else if type == .walk {
            self.setBackgroundImage(#imageLiteral(resourceName: "activityButtonWalk"), for: .normal)
        }else if type == .water {
            self.setBackgroundImage(#imageLiteral(resourceName: "activityButtonWater"), for: .normal)
        }
    }
    
    
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if self.isSelected {
            self.backgroundColor = self.selectedColor
        } else {
            self.backgroundColor = self.defaultColor
        }
    }
    
    func getSelected() -> Bool{
        return self.isSelected
    }
    
    func setAction() {
        self.addTarget(self, action: #selector(self.changeColor), for: .touchUpInside)
    }
    
    @objc func changeColor(){
        //self.setSelected(selected: true)
        if self.isSelected {
            self.setSelected(selected: false)
        }else{
            self.setSelected(selected: true)
        }
    }
    
}
