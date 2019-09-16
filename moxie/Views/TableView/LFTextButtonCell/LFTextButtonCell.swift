//
//  LFTextButtonCell.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/10/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class LFTextButtonCell: UITableViewCell {
    
    static var identifier = "LFTextButtonCell"
    static var normalHeight: CGFloat = 52.0
    
    @IBOutlet weak var button: UIButton!
    
    var callback: (()->())?
    
    @IBAction func buttonTapped(_ sender: Any) {
        callback?()
    }
    
}
