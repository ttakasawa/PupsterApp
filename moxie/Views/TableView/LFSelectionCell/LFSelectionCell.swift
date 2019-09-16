//
//  LFSelectionCell.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/9/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class LFSelectionCell: UITableViewCell, LFFillable {
    
    static let identifier = "LFSelectionCell"
    static let normalHeight: CGFloat = 99
    
    @IBOutlet weak var fieldNameLbl: UILabel!
    @IBOutlet weak var girlBtn: PLFButton!
    @IBOutlet weak var boyBtn: PLFButton!
    
    var selectionChangedCallback: ((DogGender)->())?
    
    var currentSelection: DogGender?
    
    var isFilled: Bool {
        return currentSelection != nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        girlBtn.layer.cornerRadius = 27
        boyBtn.layer.cornerRadius = 27
    }
    
    func select(gender: DogGender) {
        self.currentSelection = gender
        selectionChangedCallback?(gender)
        girlBtn.set(enabled: gender == .girl)
        boyBtn.set(enabled: gender == .boy)
    }
    
    @IBAction func girlTapped(_ sender: Any) {
        select(gender: .girl)
    }
    
    @IBAction func boyTapped(_ sender: Any) {
        select(gender: .boy)
    }
    
}
