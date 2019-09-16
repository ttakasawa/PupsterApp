//
//  CollectionVideoTableViewCell.swift
//  moxie
//
//  Created by Tomoki Takasawa on 6/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class CollectionVideoTableViewCell: tableCellWithVideoExt {
    
    var title: String?
    
    let videoTitle: UITextView = {
        let t = UITextView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = UIFont.init(name: "AvenirNext-Medium", size: 16)
        t.textColor = UIColor.black
        t.textAlignment = .left
        t.isScrollEnabled = false
        t.isEditable = false
        
        return t
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 0.39)
        self.addSubview(background)
        self.background.addSubview(videoTitle)
        self.background.addSubview(contentImage)
        
        self.setBackground()
        self.setPosition()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setPosition(){
        self.videoTitle.topAnchor.constraint(equalTo: self.background.topAnchor, constant: 15).isActive = true
        self.videoTitle.leftAnchor.constraint(equalTo: self.background.leftAnchor, constant: 15).isActive = true
        self.videoTitle.rightAnchor.constraint(equalTo: self.background.rightAnchor, constant: -15).isActive = true
        //self.videoTitle.heightAnchor.constraint(equalTo: self.contentImage.widthAnchor, multiplier: 0.75).isActive = true
        
        self.contentImage.topAnchor.constraint(equalTo: self.videoTitle.bottomAnchor, constant: 3).isActive = true
        self.contentImage.leftAnchor.constraint(equalTo: self.background.leftAnchor).isActive = true
        self.contentImage.rightAnchor.constraint(equalTo: self.background.rightAnchor).isActive = true
        self.contentImage.heightAnchor.constraint(equalTo: self.contentImage.widthAnchor, multiplier: 0.5625).isActive = true
        
        self.background.bottomAnchor.constraint(equalTo: self.contentImage.bottomAnchor, constant: 18).isActive = true
        //self.background.bottomAnchor.constraint(equalTo: self.contentImage.bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let titleFromFB = title {
            videoTitle.text = titleFromFB
        }
    }
    
}
