//
//  UserProfileCell.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class UserProfileCell: DashBoardCell, ImageProtocol {
    
    let checkInButton = DashBoardButton(title: "TRACK YOUR ACTIVITY")
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "defaultProfile"))
    let profileBaseView = UIButton()
    let ribbon = UIImageView()
    
    var currentScoreLabel: TileLabel!
    var maxScoreLabel: TileLabel!
    var restScoreLabel: TileLabel!
    var trophyIndicator: CustomProgressIndicator!
    var scoreToPresent: Int = 0
    var activeView = ProfileView()
    
    override init(){
        super.init()
        
        currentScoreLabel = TileLabel(text: "", style: TileLabelStyling(font: self.getLargeScoreFont() , color: self.getTextColor()))
        maxScoreLabel = TileLabel(text: "", style: TileLabelStyling(font: self.getMediumScoreFont() , color: self.getSecondaryColor()))
        restScoreLabel = TileLabel(text: "", style: TileLabelStyling(font: self.getSmallScoreFont() , color: self.getTextColor()))
        
        trophyIndicator = CustomProgressIndicator(colorTheme: ThemeColorStyling(mainColor: self.getSecondaryColor(), secondaryColor: UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)))
        
        
        checkInButton.addTarget(self.superview, action: #selector(NewDashboardViewController.toCheckIn), for: .touchUpInside)
        profileBaseView.addTarget(self.superview, action: #selector(NewDashboardViewController.changeProfileImage), for: .touchUpInside)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(data: UserProfileDisplayable, isOnDashBoard: Bool){
        
        super.configureTileStyle()
        print("updateProfile configure")
        
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        
        ribbon.image = data.isActivated ? #imageLiteral(resourceName: "ribbonActivated") : #imageLiteral(resourceName: "ribbonDeactivated")
        ribbon.translatesAutoresizingMaskIntoConstraints = false
        checkInButton.setIsActivated(isActivated: true)
        
        let title = TileLabel(text: "Reward Progress", style: TileLabelStyling(font: self.getTitleFont(), color: self.getTextColor()))
        currentScoreLabel = TileLabel(text: String(describing: data.currentScoreInt) + "/", style: TileLabelStyling(font: self.getLargeScoreFont() , color: self.getTextColor()))
        maxScoreLabel = TileLabel(text: String(describing: data.maxScoreInt), style: TileLabelStyling(font: self.getMediumScoreFont() , color: self.getSecondaryColor()))
        restScoreLabel = TileLabel(text: String(describing: data.restScoreInt), style: TileLabelStyling(font: self.getSmallScoreFont() , color: self.getTextColor()))
        let rewardTextLabel = TileLabel(text: "to your first Reward", style: TileLabelStyling(font: self.getUserProfileNormalFont() , color: self.getSecondaryColor()))
        
        currentScoreLabel.numberOfLines = 0
        maxScoreLabel.numberOfLines = 0
        restScoreLabel.numberOfLines = 0
        
        currentScoreLabel.sizeToFit()
        maxScoreLabel.sizeToFit()
        restScoreLabel.sizeToFit()
        
        let trophyLogo = UIImageView(image: #imageLiteral(resourceName: "trophyIcon"))
        trophyLogo.translatesAutoresizingMaskIntoConstraints = false
        
        let smallTrophyLogo = UIImageView(image: #imageLiteral(resourceName: "trophyIcon"))
        smallTrophyLogo.translatesAutoresizingMaskIntoConstraints = false
        smallTrophyLogo.contentMode = .scaleAspectFit
        smallTrophyLogo.clipsToBounds = true
        
        
        
        trophyIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        //data.activePercentage = 0.8
        trophyIndicator.progress = Float(data.currentScoreInt) / Float(data.maxScoreInt)
        
//        let checkInButton = DashBoardButton(title: "TRACK YOUR ACTIVITY")
        if isOnDashBoard == true {
            checkInButton.configureStyle(style: DashBoardMainButtonStyle(themeColor: UIColor(red:1.00, green:0.20, blue:0.40, alpha:1.0)))
            checkInButton.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //toCheckIn
        
        profileBaseView.backgroundColor = self.getMainColor()
        profileBaseView.translatesAutoresizingMaskIntoConstraints = false
        profileBaseView.layer.cornerRadius = 54.5
        
        
        //TODO: change this image view to ProfileImageView class
        if let img = Global.network.userProfileImage {
            
            self.profileImageView.image = img
            
        }else if let imageUrl = data.profileImageUrl {
            
            self.downloadImage(stringUrl: imageUrl) { (userImage) in
                self.profileImageView.image = userImage
            }
        }
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.cornerRadius = 52.5
        profileImageView.isUserInteractionEnabled = false
        
        
        let streakView = ProfileView()
        streakView.configure(upperLabelText: "", score: String(describing: data.dailyLogInStreak), description: "DAY STREAK")
        streakView.translatesAutoresizingMaskIntoConstraints = false
        streakView.layer.borderWidth = 1
        streakView.layer.borderColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1).cgColor
        
        let percentageData = Global.network.calculatePercentile(percentileArr: Global.network.perentileScoreArray!, user: Global.network.user!)
        Global.network.user?.percentMostActive = percentageData
        
        var isTopStr: String =  ""
        
        if percentageData >= 50  {
            scoreToPresent = 100 - percentageData
            isTopStr = "TOP"
        }else{
            scoreToPresent = percentageData
            isTopStr = "BOTTOM"
        }
        
        activeView.configure(upperLabelText: isTopStr, score: String(describing: scoreToPresent) + "%", description: isTopStr == "TOP" ? "MOST ACTIVE" : "LEAST ACTIVE")//TODO
        activeView.translatesAutoresizingMaskIntoConstraints = false
        activeView.layer.borderWidth = 1
        activeView.layer.borderColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1).cgColor
        
        streakView.clipsToBounds = true
        activeView.clipsToBounds = true
        
        self.addSubview(ribbon)
        self.addSubview(title)
        
        self.addSubview(profileBaseView)
        profileBaseView.addSubview(profileImageView)
        
        self.addSubview(currentScoreLabel)
        self.addSubview(maxScoreLabel)
        self.addSubview(restScoreLabel)
        self.addSubview(rewardTextLabel)
        self.addSubview(trophyIndicator)
        
        self.addSubview(trophyLogo)
        
        if (DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5){
            //nothing
        }else{
            self.addSubview(smallTrophyLogo)
        }
        
        
        
        if isOnDashBoard == true {
            self.addSubview(checkInButton)
        }
        
        
        self.addSubview(streakView)
        self.addSubview(activeView)
        
        ribbon.topAnchor.constraint(equalTo: self.topAnchor, constant: 11).isActive = true
        ribbon.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        ribbon.widthAnchor.constraint(equalToConstant: 211.5).isActive = true
        ribbon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 44).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        
        currentScoreLabel.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        currentScoreLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        
        
        maxScoreLabel.bottomAnchor.constraint(equalTo: currentScoreLabel.bottomAnchor, constant: -4).isActive = true
        maxScoreLabel.leftAnchor.constraint(equalTo: currentScoreLabel.rightAnchor).isActive = true
        
        trophyLogo.leftAnchor.constraint(equalTo: maxScoreLabel.rightAnchor, constant: 5).isActive = true
        trophyLogo.bottomAnchor.constraint(equalTo: maxScoreLabel.bottomAnchor, constant: -6).isActive = true
        trophyLogo.topAnchor.constraint(equalTo: maxScoreLabel.topAnchor, constant: 4).isActive = true
        trophyLogo.widthAnchor.constraint(equalTo: trophyLogo.heightAnchor).isActive = true
        trophyLogo.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        restScoreLabel.topAnchor.constraint(equalTo: currentScoreLabel.bottomAnchor, constant: 6).isActive = true
        restScoreLabel.leftAnchor.constraint(equalTo: currentScoreLabel.leftAnchor).isActive = true
        
        if (DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5){
            rewardTextLabel.leftAnchor.constraint(equalTo: restScoreLabel.rightAnchor, constant: 5).isActive = true
        }else{
            smallTrophyLogo.topAnchor.constraint(equalTo: rewardTextLabel.topAnchor, constant: 4).isActive = true
            smallTrophyLogo.bottomAnchor.constraint(equalTo: rewardTextLabel.bottomAnchor,constant: -4).isActive = true
            smallTrophyLogo.leftAnchor.constraint(equalTo: restScoreLabel.rightAnchor, constant: 5).isActive = true
            smallTrophyLogo.widthAnchor.constraint(equalTo: smallTrophyLogo.heightAnchor).isActive = true
            smallTrophyLogo.widthAnchor.constraint(equalToConstant: 12).isActive = true
            
            rewardTextLabel.leftAnchor.constraint(equalTo: smallTrophyLogo.rightAnchor, constant: 5).isActive = true
        }
        
        
        
        rewardTextLabel.bottomAnchor.constraint(equalTo: restScoreLabel.bottomAnchor).isActive = true
        
        
        
        profileBaseView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        profileBaseView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -19).isActive = true
        profileBaseView.heightAnchor.constraint(equalToConstant: 109).isActive = true
        profileBaseView.widthAnchor.constraint(equalToConstant: 109).isActive = true
        
        profileImageView.centerXAnchor.constraint(equalTo: profileBaseView.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: profileBaseView.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 105).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 105).isActive = true
        
        
        
        trophyIndicator.topAnchor.constraint(equalTo: rewardTextLabel.bottomAnchor, constant: 14).isActive = true
        trophyIndicator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 17).isActive = true
        trophyIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        trophyIndicator.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        
        if isOnDashBoard == true {
            checkInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            checkInButton.topAnchor.constraint(equalTo: trophyIndicator.bottomAnchor, constant: 25).isActive = true
            checkInButton.widthAnchor.constraint(equalToConstant: 230).isActive = true
            checkInButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
            
            streakView.topAnchor.constraint(equalTo: checkInButton.bottomAnchor, constant: 20).isActive = true
            activeView.topAnchor.constraint(equalTo: checkInButton.bottomAnchor, constant: 20).isActive = true
        }else{
            streakView.topAnchor.constraint(equalTo: trophyIndicator.bottomAnchor, constant: 10).isActive = true
            activeView.topAnchor.constraint(equalTo: trophyIndicator.bottomAnchor, constant: 10).isActive = true
        }
        
        
        
        streakView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        streakView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        streakView.heightAnchor.constraint(equalTo: activeView.widthAnchor, multiplier: 145.0/179.0).isActive = true
        
        
        activeView.leftAnchor.constraint(equalTo: streakView.rightAnchor).isActive = true
        activeView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        activeView.widthAnchor.constraint(equalTo: streakView.widthAnchor, multiplier: 1).isActive = true
        activeView.heightAnchor.constraint(equalTo: activeView.widthAnchor, multiplier: 145.0/179.0).isActive = true
        
        activeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
    }
    
    func insertImage(image: UIImage){
        self.profileImageView.image = image
    }
    
    func updateProfile(data: UserProfileDisplayable){
        print("updateProfile update")
        ribbon.image = data.isActivated ? #imageLiteral(resourceName: "ribbonActivated") : #imageLiteral(resourceName: "ribbonDeactivated")
        checkInButton.setIsActivated(isActivated: true)
        self.currentScoreLabel.text = String(describing: data.currentScoreInt) + "/"
        self.maxScoreLabel.text = String(describing: data.maxScoreInt)
        self.restScoreLabel.text = String(describing: data.restScoreInt)
        self.trophyIndicator.progress = Float(data.currentScoreInt) / Float(data.maxScoreInt)
        //self.scoreToPresent: Int = 0
        var isOnTop: Bool = false
        var upperText: String = ""
        
        if let percentileArr = Global.network.perentileScoreArray, let user = Global.network.user {
            let percentageData = Global.network.calculatePercentile(percentileArr: percentileArr, user: user)
            Global.network.user?.percentMostActive = percentageData
            
            if percentageData >= 50  {
                scoreToPresent = 100 - data.activePercentage
                upperText = "TOP"
                isOnTop = true
            }else{
                scoreToPresent = data.activePercentage
                upperText = "BOTTOM"
                isOnTop = false
            }
            
            activeView.update(upperLabelText: upperText, score: String(describing: scoreToPresent) + "%", description: upperText == "TOP" ? "MOST ACTIVE": "LEAST ACTIVE")
        }
        
        
    }
    
    
}
