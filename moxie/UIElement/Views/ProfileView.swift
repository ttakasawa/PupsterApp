//
//  ProfileView.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class ProfileView: UIView, Stylable {
    
    var upperLabel: TileLabel!
    var scoreLabel: TileLabel!
    var descriptionLabel: TileLabel!
    
    init(){
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(upperLabelText: String, score: String, description: String) {
        
        upperLabel = TileLabel(text: upperLabelText, style: TileLabelStyling(font: self.getSubTitleFont(), color: self.getTextColor()))
        scoreLabel = TileLabel(text: score, style: TileLabelStyling(font: self.getUserStatFont(), color: self.getMainColor()))
        descriptionLabel = TileLabel(text: description, style: TileLabelStyling(font: self.getSubTitleFont(), color: self.getTextColor()))
        descriptionLabel.textAlignment = .center
        
        self.addSubview(upperLabel)
        self.addSubview(scoreLabel)
        self.addSubview(descriptionLabel)
        
        upperLabel.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor).isActive = true
        upperLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        scoreLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -7).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 2).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.update(upperLabelText: upperLabelText, score: score, description: description)
    }
    
    func update(upperLabelText: String, score: String, description: String) {
        upperLabel.text = upperLabelText
        scoreLabel.text = score
        descriptionLabel.text = description
    }
}

