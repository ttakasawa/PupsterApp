//
//  ProgressCell.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class ProgressCell: DashBoardCell {
    
    let viewProgramButton = DashBoardButton(title: "VIEW YOUR PROGRAM")
    var progressBar: CustomProgressIndicator!
    var progressLabel: TileLabel!
    
    override init(){
        super.init()
        progressLabel = TileLabel(text: "", style: TileLabelStyling(font: self.getNormalTextFont(), color: self.getTextColor()))
        
        viewProgramButton.addTarget(self.superview, action: #selector(NewDashboardViewController.viewProgramPressed), for: .touchUpInside)
        progressBar = CustomProgressIndicator(colorTheme: ThemeColorStyling(mainColor: self.getMainColor(), secondaryColor: UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(data: DefaultTileDisplayable){
        progressBar.progress = data.progressValue
        progressLabel.text = data.progressLabel
    }
    
    func configure(data: DefaultTileDisplayable){
        super.configureTileStyle()
        
        
        let title = TileLabel(text: "Pupster Program", style: TileLabelStyling(font: self.getTitleFont(), color: self.getTextColor()))
        progressLabel.text = data.progressLabel
        progressLabel.numberOfLines = 1
        
        progressBar.progress = data.progressValue
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        viewProgramButton.translatesAutoresizingMaskIntoConstraints = false
        viewProgramButton.configureStyle(style: DashBoardMainButtonStyle(themeColor: self.getMainColor()))
        
        self.addSubview(title)
        self.addSubview(progressLabel)
        self.addSubview(progressBar)
        self.addSubview(viewProgramButton)
        
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        
        progressLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 11).isActive = true
        progressLabel.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        progressLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        progressBar.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 16).isActive = true
        progressBar.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        progressBar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        viewProgramButton.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 17).isActive = true
        viewProgramButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        viewProgramButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        viewProgramButton.widthAnchor.constraint(equalToConstant: 260).isActive = true
        
        self.bottomAnchor.constraint(equalTo: viewProgramButton.bottomAnchor, constant: 24).isActive = true
        
        //MustDo: article press
    }
    
}
