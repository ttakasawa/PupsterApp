//
//  LessonContentsTableViewCell.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/11/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit


class LessonsContentsTableViewCell: UITableViewCell, Stylable {
    
    var videoView = ArticleHeadingView(forCell: true)
    var title: String?
    var thumbnailUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(videoView)
        
        videoView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        videoView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        videoView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        self.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 10).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let title = self.title else { return }
        guard let thumbnailUrl = self.thumbnailUrl else { return }
        
        self.videoView.configureForLessonCell(title: title, imageUrl: thumbnailUrl)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

