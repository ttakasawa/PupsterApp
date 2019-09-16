//
//  PlayVideoButton.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class PlayVideoButton: UIButton {
    var videoUrl: String?
    var videoName: String?
    init(){
        super.init(frame: CGRect.zero)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.setBackgroundImage(#imageLiteral(resourceName: "playButton"), for: .normal)
    }
    
    func attachUrl(urlString: String){
        self.videoUrl = urlString
    }
    
    func attachVideoName(name: String){
        self.videoName = name
    }
}

