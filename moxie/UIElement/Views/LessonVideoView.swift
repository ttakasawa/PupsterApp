//
//  LessonVideoView.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit


class LessonVideoView: UIScrollView, ImageProtocol {
    
    var imageViews: [UIImageView] = []
    var playButtons: [PlayVideoButton] = []
    
    var pButton1 = PlayVideoButton()
    var pButton2 = PlayVideoButton()
    var pButton3 = PlayVideoButton()
    var pButton4 = PlayVideoButton()
    var pButton5 = PlayVideoButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = true
        
        pButton1.addTarget(self.superview?.superview, action: #selector(NewDashboardViewController.videoPlayPressed), for: .touchUpInside)
        pButton2.addTarget(self.superview?.superview, action: #selector(NewDashboardViewController.videoPlayPressed), for: .touchUpInside)
        pButton3.addTarget(self.superview?.superview, action: #selector(NewDashboardViewController.videoPlayPressed), for: .touchUpInside)
        pButton4.addTarget(self.superview?.superview, action: #selector(NewDashboardViewController.videoPlayPressed), for: .touchUpInside)
        pButton5.addTarget(self.superview?.superview, action: #selector(NewDashboardViewController.videoPlayPressed), for: .touchUpInside)
        
        playButtons.append(pButton1)
        playButtons.append(pButton2)
        playButtons.append(pButton3)
        playButtons.append(pButton4)
        playButtons.append(pButton5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateVideoView(videos: [Video]){
        for view in self.subviews {
            view.removeFromSuperview()
        }
        imageViews = []
        //playButtons = []
        
        self.configure(videos: videos)
    }
    
    
    
    
    func configure(videos: [Video]){
        let baseViewWidth = ScreenSize.SCREEN_WIDTH - 48    //TODO: This needs to be changed
        let baseWidthHeight = baseViewWidth * 183 / 326
        self.contentSize.width = baseViewWidth * CGFloat(videos.count)
        
        for i in 0..<videos.count {
            let newImageView = UIImageView()    //TODO: Placeholder image here ??
            newImageView.contentMode = .scaleAspectFill
            newImageView.clipsToBounds = true
            imageViews.append(newImageView)
            self.addSubview(newImageView)
            
            newImageView.frame = CGRect(x: baseViewWidth * CGFloat(i), y: 0, width: baseViewWidth, height: baseWidthHeight)
            
            
            self.downloadImage(stringUrl: videos[i].thumbnailUrl) { (thumbnail) in
                self.imageViews[i].image = thumbnail
            }
            
            //let playButton = self.getPlayButton(urlString: videos[i].videoUrl)
            self.addSubview(playButtons[i])
            playButtons[i].translatesAutoresizingMaskIntoConstraints = false
            playButtons[i].attachUrl(urlString: videos[i].videoUrl)
            playButtons[i].centerXAnchor.constraint(equalTo: newImageView.centerXAnchor).isActive = true
            playButtons[i].centerYAnchor.constraint(equalTo: newImageView.centerYAnchor).isActive = true
            playButtons[i].heightAnchor.constraint(equalToConstant: 77).isActive = true
            playButtons[i].widthAnchor.constraint(equalToConstant: 95).isActive = true
            
            
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func getPlayButton(urlString: String) -> PlayVideoButton {
        let playButton = PlayVideoButton()
        playButton.addTarget(self.superview?.superview, action: #selector(NewDashboardViewController.videoPlayPressed), for: .touchUpInside)
        playButton.attachUrl(urlString: urlString)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        return playButton
    }
    
}


