//
//  ReminderDateButton.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit


class ReminderDateButton: UIButton, Stylable {
    
    var selectedColor: UIColor!
    var dayLabel: TileLabel!
    
    init() {
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(dayOfWeek: DayOfWeek, radius: CGFloat){
        
        
        self.selectedColor = self.getMainColor()
        
        dayLabel = TileLabel(text: "", style: TileLabelStyling(font: self.getSmallFont(), color: self.getTextColor()))
        if (dayOfWeek == .Sun) || (dayOfWeek == .Sat) {
            dayLabel.text = "S"
        }else if (dayOfWeek == .Mon) {
            dayLabel.text = "M"
        }else if (dayOfWeek == .Tue) || (dayOfWeek == .Thu) {
            dayLabel.text = "T"
        }else if (dayOfWeek == .Wed) {
            dayLabel.text = "W"
        }else{
            dayLabel.text = "F"
        }
        
        self.addSubview(dayLabel)
        dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.layer.borderColor = self.getMainColor().cgColor
        self.layer.borderWidth = 1
        
        self.layer.cornerRadius = radius
    }
    
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if self.isSelected {
            self.backgroundColor = self.selectedColor
            self.dayLabel.textColor = self.getWhiteColor()
        } else {
            self.backgroundColor = self.getWhiteColor()
            self.dayLabel.textColor = self.getTextColor()
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
