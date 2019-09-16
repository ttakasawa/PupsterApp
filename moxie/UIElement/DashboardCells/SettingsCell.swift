//
//  SettingsCell.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/21/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

class SettingsCell: DashBoardCell {
    var button = UIButton()
    
    override init(){
        super.init()
        self.button.addTarget(self.superview, action: #selector(NewDashboardViewController.settingCellPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(){
        super.configureTileStyle()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(button)
        
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 70.0/360.0).isActive = true
        
        button.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let title = TileLabel(text: "Settings", style: TileLabelStyling(font: self.getSubTitleFont(), color: self.getTextColor()))
        button.addSubview(title)
        
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14).isActive = true
        
        let gearIcon = UIImageView()
        gearIcon.image = #imageLiteral(resourceName: "settingsIcon")
        gearIcon.translatesAutoresizingMaskIntoConstraints = false
        gearIcon.contentMode = .scaleAspectFit
        
        button.addSubview(gearIcon)
        
        gearIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        gearIcon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        gearIcon.widthAnchor.constraint(equalToConstant: 22).isActive = true
        gearIcon.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    
}
