//
//  LessonCell.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class LessonCell: DashBoardCell {
    
    var pageControl: PageControl
    let videoView = LessonVideoView()
    let button = DashBoardButton(title: "MASTERED?")
    let subscriptionIntroImageButton = UIButton()
    
    var title: TileLabel!
    var subTitle: TileLabel!
    var SubCourseTitle: TileLabel!
    
    override init(){
        self.pageControl = PageControl()
        super.init()
        
        title = TileLabel(text: "", style: TileLabelStyling(font: self.getTitleFont(), color: self.getTextColor()))
        subTitle = TileLabel(text: "", style: TileLabelStyling(font: self.getSubTitleFont(), color: self.getMainColor()))
        SubCourseTitle = TileLabel(text: "", style: TileLabelStyling(font: self.getNormalTextFont(), color: self.getLightTextColor()))
        
        self.button.addTarget(self.superview, action: #selector(NewDashboardViewController.completeLesson), for: .touchUpInside)
        self.subscriptionIntroImageButton.addTarget(self.superview, action: #selector(NewDashboardViewController.subscriptionPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hitPayWall(){
        title.text = "Join Pupster Now"
        subTitle.text = "Complete the program"
        SubCourseTitle.text = "Join Pupster"
        
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        subscriptionIntroImageButton.setBackgroundImage(#imageLiteral(resourceName: "lessonTileUpgrade"), for: .normal)
        subscriptionIntroImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.videoView.addSubview(subscriptionIntroImageButton)
        subscriptionIntroImageButton.topAnchor.constraint(equalTo: videoView.topAnchor).isActive = true
        subscriptionIntroImageButton.bottomAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
        subscriptionIntroImageButton.leftAnchor.constraint(equalTo: videoView.leftAnchor).isActive = true
        subscriptionIntroImageButton.rightAnchor.constraint(equalTo: videoView.rightAnchor).isActive = true
        subscriptionIntroImageButton.widthAnchor.constraint(equalTo: videoView.widthAnchor).isActive = true
        subscriptionIntroImageButton.heightAnchor.constraint(equalTo: videoView.heightAnchor).isActive = true
        
        pageControl.numberOfPages = 1
    }
    
    func update(data: ProgramInterface){
        title.text = data.title
        subTitle.text = data.globalLesson.lessonName
        SubCourseTitle.text = data.subProgramName
        
        button.isUserInteractionEnabled = true
        button.alpha = 1
        
        self.videoView.updateVideoView(videos: data.globalLesson.viewableVideos)
        self.pageControl.numberOfPages = data.globalLesson.viewableVideos.count
        
        button.attachActionKey(key: data.globalLesson.id)
        
    }
    
    //var title: TileLabel!
    
    //TODO: change to configure
    func configure(data: ProgramInterface){
        
        super.configureTileStyle()
        title.text = data.title
        subTitle.text = data.globalLesson.lessonName
        SubCourseTitle.text = data.subProgramName
        
        
        button.configureStyle(style: DashBoardSecondaryButtonStyle(themeColor: self.getMainColor()))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.attachActionKey(key: data.globalLesson.id)
        
        
        self.videoView.configure(videos: data.globalLesson.viewableVideos)
        self.pageControl.numberOfPages = data.globalLesson.viewableVideos.count
        
        
        
        self.addSubview(title)
        self.addSubview(subTitle)
        self.addSubview(SubCourseTitle)
        self.addSubview(button)
        self.addSubview(videoView)
        
        button.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        button.widthAnchor.constraint(equalToConstant: 122).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        title.rightAnchor.constraint(equalTo: button.leftAnchor).isActive = true
        
        subTitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        subTitle.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        subTitle.rightAnchor.constraint(equalTo: title.rightAnchor).isActive = true
        
        videoView.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 17).isActive = true
        videoView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 17).isActive = true
        videoView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        videoView.heightAnchor.constraint(equalTo: videoView.widthAnchor, multiplier: 183/326).isActive = true
        
        
        SubCourseTitle.topAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
        SubCourseTitle.rightAnchor.constraint(equalTo: videoView.rightAnchor).isActive = true
        
        self.bottomAnchor.constraint(equalTo: SubCourseTitle.bottomAnchor, constant: 15).isActive = true
        
        self.addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pageControl.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 2).isActive = true
        
        videoView.delegate = self
        
        
    }
}


extension LessonCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.videoView.imageViews.count > 0{
            self.pageControl.currentPage = Int(self.videoView.contentOffset.x / (self.videoView.imageViews[0].frame.width))
        }else{
            self.pageControl.currentPage = 0
        }
    }
}
