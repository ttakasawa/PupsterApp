//
//  LFTitleCell.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/8/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class LFTitleCell: UITableViewCell {
    
    static let identifier = "LFTitleCell"
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightMarginConstraint: NSLayoutConstraint!
    
//    func height(width: CGFloat) -> CGFloat {
//        guard let text = titleLbl.text else { return 0 }
//        return topMarginConstraint.constant + bottomMarginConstraint.constant + text.height(withConstrainedWidth: width - leftMarginConstraint.constant - rightMarginConstraint.constant, font: titleLbl.font)
//    }
    
    func configure(title: String, font: UIFont) {
        titleLbl.text = title
        titleLbl.font = font
    }
    
}
