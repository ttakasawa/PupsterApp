
//
//  DogButton.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/9/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class DogButton: TappableView {
    @IBOutlet weak var upImageView: UIImageView!
    @IBOutlet weak var downImageView: UIImageView!
    override func setHighlighted(_ highlighted: Bool) {
        upImageView.isHidden = highlighted
        downImageView.isHidden = !highlighted
    }
}
