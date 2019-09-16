//
//  scrollButton.swift
//  moxie
//
//  Created by Tomoki Takasawa on 7/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class scrollButton: UIButton {
    
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
        let scrollIcon = #imageLiteral(resourceName: "scrollBlackButton")
        let iconImageView = UIImageView(image: scrollIcon)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconImageView)
        iconImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        iconImageView.contentMode = .scaleAspectFit
    }
}
