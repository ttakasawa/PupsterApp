//
//  DropDownMenu.swift
//  moxie
//
//  Created by Tomoki Takasawa on 5/22/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

protocol dropdownSelected: class {
    func dropdownUpdated()
}

class DropDownMenu: UIButton {
    
    var actionview: UIAlertController?
    weak var delegate: dropdownSelected!
    
    let dropdownLabel: UILabel = {
        let d = UILabel()
        d.translatesAutoresizingMaskIntoConstraints = false
        d.text = "\u{276F}"
        d.font = UIFont.init(name: "AvenirNext-Medium", size: 15)
        d.textColor = UIColor.black
        d.textAlignment = .right
        d.adjustsFontSizeToFitWidth = true
        
        return d
    }()
    
    let colorLabel: UILabel = {
        let n = UILabel()
        n.translatesAutoresizingMaskIntoConstraints = false
        n.text = "Select your preference"
        n.font = UIFont.init(name: "AvenirNext-Medium", size: 15)
        n.textColor = UIColor.black
        n.textAlignment = .left
        n.adjustsFontSizeToFitWidth = true
        
        return n
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.configureButton()
    }
    
    func configureButton() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 8
        
        self.addSubview(dropdownLabel)
        self.addSubview(colorLabel)
        
        dropdownLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        dropdownLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        colorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        colorLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
    }
    
    func setLabelColor(newColor: String){
        self.colorLabel.text = newColor
    }
    
    
    func setSelectables(arrayOfSelectables: [String]){
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let numOfContents = arrayOfSelectables.count - 1
        for i in 0...numOfContents {
            let selectableAction: UIAlertAction = UIAlertAction(title: arrayOfSelectables[i], style: .default) { action -> Void in
                self.setLabelColor(newColor: arrayOfSelectables[i])
                self.delegate.dropdownUpdated()
            }
            actionSheetController.addAction(selectableAction)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("cancel")
        }
        actionSheetController.addAction(cancelAction)
        self.actionview = actionSheetController
    }
}
