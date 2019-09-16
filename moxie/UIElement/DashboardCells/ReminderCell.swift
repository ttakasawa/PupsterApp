//
//  ReminderCell.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit


class ReminderCell: DashBoardCell {
    let notificationSwitch = UISwitch()
    let setTimeButton = UIButton()
    let timeValueBackgroundButton = UIButton()
    
    let sunButton = ReminderDateButton()
    let monButton = ReminderDateButton()
    let tueButton = ReminderDateButton()
    let wedButton = ReminderDateButton()
    let thuButton = ReminderDateButton()
    let friButton = ReminderDateButton()
    let satButton = ReminderDateButton()
    
    var timeValueLabel: TileLabel!
    
    var data: ReminderSettingDisplayable?

    override init(){
        super.init()
        self.setAction()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAction(){
        notificationSwitch.addTarget(self.superview, action: #selector(NewDashboardViewController.notificationToggled), for: .touchUpInside)
        
        setTimeButton.addTarget(self.superview, action: #selector(NewDashboardViewController.timeSelectionPressed), for: .touchUpInside)//timeValueBackgroundButton
        timeValueBackgroundButton.addTarget(self.superview, action: #selector(NewDashboardViewController.timeSelectionPressed), for: .touchUpInside)
        
        sunButton.addTarget(self.superview, action: #selector(NewDashboardViewController.sunPressed), for: .touchUpInside)
        monButton.addTarget(self.superview, action: #selector(NewDashboardViewController.monPressed), for: .touchUpInside)
        tueButton.addTarget(self.superview, action: #selector(NewDashboardViewController.tuePressed), for: .touchUpInside)
        wedButton.addTarget(self.superview, action: #selector(NewDashboardViewController.wedPressed), for: .touchUpInside)
        thuButton.addTarget(self.superview, action: #selector(NewDashboardViewController.thuPressed), for: .touchUpInside)
        friButton.addTarget(self.superview, action: #selector(NewDashboardViewController.friPressed), for: .touchUpInside)
        satButton.addTarget(self.superview, action: #selector(NewDashboardViewController.satPressed), for: .touchUpInside)
    }
    
    func configure(data: ReminderSettingDisplayable){
        self.data = data
        super.configureTileStyle()
        
        let spacing = ScreenSize.SCREEN_WIDTH / 22
        
        
        notificationSwitch.translatesAutoresizingMaskIntoConstraints = false
        notificationSwitch.onTintColor = self.getMainColor()
        //notificationSwitch.tintColor = self.getWhiteColor()
        notificationSwitch.setOn(data.isReminderOn, animated: false)
        
        let title = TileLabel(text: "Daily Reminder", style: TileLabelStyling(font: self.getTitleFont(), color: self.getTextColor()))
        
        sunButton.configure(dayOfWeek: .Sun, radius: spacing)
        monButton.configure(dayOfWeek: .Mon, radius: spacing)
        tueButton.configure(dayOfWeek: .Tue, radius: spacing)
        wedButton.configure(dayOfWeek: .Wed, radius: spacing)
        thuButton.configure(dayOfWeek: .Thu, radius: spacing)
        friButton.configure(dayOfWeek: .Fri, radius: spacing)
        satButton.configure(dayOfWeek: .Sat, radius: spacing)
        
        for i in 0..<data.reminderDates.count {
            if (data.reminderDates[i] == .Sun){
                sunButton.setSelected(selected: true)
            }else if (data.reminderDates[i] == .Mon){
                monButton.setSelected(selected: true)
            }else if (data.reminderDates[i] == .Tue){
                tueButton.setSelected(selected: true)
            }else if (data.reminderDates[i] == .Wed){
                wedButton.setSelected(selected: true)
            }else if (data.reminderDates[i] == .Thu){
                thuButton.setSelected(selected: true)
            }else if (data.reminderDates[i] == .Fri){
                friButton.setSelected(selected: true)
            }else if (data.reminderDates[i] == .Sat){
                satButton.setSelected(selected: true)
            }
        }
        
        
        let timeLabel = TileLabel(text: "Time", style: TileLabelStyling(font: self.getNormalTextFont(), color: self.getLightTextColor()))
        
        
        timeValueBackgroundButton.backgroundColor = .clear
        timeValueBackgroundButton.translatesAutoresizingMaskIntoConstraints = false
        timeValueLabel = TileLabel(text: data.defaultReminderTime, style: TileLabelStyling(font: self.getNormalTextFont(), color: self.getLightTextColor()))
        
        setTimeButton.translatesAutoresizingMaskIntoConstraints = false
        //setTimeButton.backgroundColor = self.getMainColor()
        setTimeButton.setImage(#imageLiteral(resourceName: "scrollBlackButton"), for: .normal)
        
        
        
        
        
        
        self.addSubview(title)
        self.addSubview(notificationSwitch)
        self.addSubview(sunButton)
        self.addSubview(monButton)
        self.addSubview(tueButton)
        self.addSubview(wedButton)
        self.addSubview(thuButton)
        self.addSubview(friButton)
        self.addSubview(satButton)
        
        self.addSubview(timeLabel)
        self.addSubview(timeValueBackgroundButton)
        self.addSubview(timeValueLabel)
        self.addSubview(setTimeButton)
        
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 19).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 17).isActive = true
        
        notificationSwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        notificationSwitch.centerYAnchor.constraint(equalTo: title.centerYAnchor).isActive = true
        
        sunButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0/11.0).isActive = true
        sunButton.heightAnchor.constraint(equalTo: sunButton.widthAnchor).isActive = true
        
        monButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0/11.0).isActive = true
        monButton.heightAnchor.constraint(equalTo: monButton.widthAnchor).isActive = true
        
        tueButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0/11.0).isActive = true
        tueButton.heightAnchor.constraint(equalTo: tueButton.widthAnchor).isActive = true
        
        wedButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0/11.0).isActive = true
        wedButton.heightAnchor.constraint(equalTo: wedButton.widthAnchor).isActive = true
        
        thuButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0/11.0).isActive = true
        thuButton.heightAnchor.constraint(equalTo: thuButton.widthAnchor).isActive = true
        
        friButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0/11.0).isActive = true
        friButton.heightAnchor.constraint(equalTo: friButton.widthAnchor).isActive = true
        
        satButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0/11.0).isActive = true
        satButton.heightAnchor.constraint(equalTo: satButton.widthAnchor).isActive = true
        
        
        sunButton.rightAnchor.constraint(equalTo: monButton.leftAnchor, constant: -spacing).isActive = true
        monButton.rightAnchor.constraint(equalTo: tueButton.leftAnchor, constant: -spacing).isActive = true
        tueButton.rightAnchor.constraint(equalTo: wedButton.leftAnchor, constant: -spacing).isActive = true
        wedButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        thuButton.leftAnchor.constraint(equalTo: wedButton.rightAnchor, constant: spacing).isActive = true
        friButton.leftAnchor.constraint(equalTo: thuButton.rightAnchor, constant: spacing).isActive = true
        satButton.leftAnchor.constraint(equalTo: friButton.rightAnchor, constant: spacing).isActive = true
        
        sunButton.topAnchor.constraint(equalTo: wedButton.topAnchor).isActive = true
        monButton.topAnchor.constraint(equalTo: wedButton.topAnchor).isActive = true
        tueButton.topAnchor.constraint(equalTo: wedButton.topAnchor).isActive = true
        wedButton.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 21.5).isActive = true
        thuButton.topAnchor.constraint(equalTo: wedButton.topAnchor).isActive = true
        friButton.topAnchor.constraint(equalTo: wedButton.topAnchor).isActive = true
        satButton.topAnchor.constraint(equalTo: wedButton.topAnchor).isActive = true
        
        timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 17).isActive = true
        timeLabel.topAnchor.constraint(equalTo: wedButton.bottomAnchor, constant: 22.5).isActive = true
        
        setTimeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -17).isActive = true
        setTimeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        setTimeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        setTimeButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor).isActive = true
        
        setTimeButton.leftAnchor.constraint(equalTo: timeValueLabel.rightAnchor, constant: 5).isActive = true
        timeValueLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor).isActive = true
        
        self.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8).isActive = true
        
        
        timeValueBackgroundButton.topAnchor.constraint(equalTo: timeValueLabel.topAnchor).isActive = true
        timeValueBackgroundButton.bottomAnchor.constraint(equalTo: timeValueLabel.bottomAnchor).isActive = true
        timeValueBackgroundButton.leftAnchor.constraint(equalTo: timeValueLabel.leftAnchor).isActive = true
        timeValueBackgroundButton.rightAnchor.constraint(equalTo: timeValueLabel.rightAnchor).isActive = true
        //MustDo: setTimeButton add target - timeValueBackgroundButton
        
    }
    
    func changeTimeValue(timeInt: Int){
        var displayTime: String = ""
        if timeInt < 10 {
            displayTime = String(timeInt) + ":00 AM"
        }else if timeInt == 12 {
            displayTime = "12:00 PM"
        }else if timeInt < 13 {
            displayTime =  String(timeInt) + ":00 AM"
        }else{
            displayTime = String(timeInt - 12) + ":00 PM"
        }
        timeValueLabel.text = displayTime
    }
    
    func initializeAllButton(){
        sunButton.setSelected(selected: false)
        monButton.setSelected(selected: false)
        tueButton.setSelected(selected: false)
        wedButton.setSelected(selected: false)
        thuButton.setSelected(selected: false)
        friButton.setSelected(selected: false)
        satButton.setSelected(selected: false)
    }
    
}
