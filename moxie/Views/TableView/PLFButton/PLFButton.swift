//
//  PLFButton.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/9/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class PLFButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        layer.cornerRadius = 24
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3
    }
    
    func set(enabled: Bool) {
        backgroundColor = enabled ? .white : .clear
        setTitleColor(enabled ? UIColor(0x64626F) : .white, for: .normal)
    }

}
