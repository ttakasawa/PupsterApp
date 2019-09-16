//
//  UpgradeCell.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class UpgradeCell: DashBoardCell {
    var button = UIButton()
    override init(){
        super.init()
        self.button.addTarget(self.superview, action: #selector(NewDashboardViewController.subscriptionPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(data: DogNameDisplayable){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.adjustsImageWhenHighlighted = false
        
        let dogNameLabel = TileLabel(text: data.name, style: TileLabelStyling(font: self.getDogNameFont(), color: self.getWhiteColor()))
        
        self.addSubview(button)
        button.addSubview(dogNameLabel)
        
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 189.0/360.0)
        
        button.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        dogNameLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        dogNameLabel.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 13).isActive = true
        
        self.updateView(data: data)
    }
    
    func updateView(data: DogNameDisplayable){
        if data.currentSubscription {
            button.setBackgroundImage(#imageLiteral(resourceName: "dashboardCellForPremium"), for: .normal)
        }else{
            button.setBackgroundImage(#imageLiteral(resourceName: "dashboardCellUpgrade"), for: .normal)
        }
        //button.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControlState#>)
        //button.imageView?.contentMode = .scaleAspectFill
        //button.imageView.
    }
    
}

protocol DogNameDisplayable {
    var name: String { get }
    var currentSubscription: Bool { get }
}

extension UserData: DogNameDisplayable {
    var name: String {
        return self.dogs![0].name
    }
    var currentSubscription: Bool {
        return self.isOnSubscription
    }
}
