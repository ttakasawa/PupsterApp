//
//  LessonCellActionExtension.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/27/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

extension NewDashboardViewController {
    func updateLessonView(program: Program){
        
        let currentLessonId = program.currentLessonId
        let secondLessonId = program.nextLessonId
        
        self.globalLessons = []
        
        self.network.getLessonContent(lessonId: currentLessonId, completion: { (lesson) in
            self.globalLessons?.append(lesson)
            let programInterface = ProgramInterface(program: program, lesson: lesson)
            
            if let top = self.topTile as? LessonCell {
                top.update(data: programInterface)
            }
        })
        
        if (program.completedLessons > 1) && (self.user?.isOnSubscription == false){
            self.setUpPayWall()
        }else{
            self.network.getLessonContent(lessonId: secondLessonId, completion: { (lesson) in
                self.globalLessons?.append(lesson)
                let programInterface = ProgramInterface(program: program, lesson: lesson)
                if let middle = self.middleTile as? LessonCell {
                    middle.update(data: programInterface)
                }
            })
        }
        
        
        
        if let bottom = self.footerTile as? ProgressCell {
            guard let user = self.user else { return }
            bottom.update(data: user)
        }
    }
    
    func setUpPayWall(){
        if let middle = self.middleTile as? LessonCell {
            middle.hitPayWall()
        }
    }
}

@objc
extension NewDashboardViewController {
    
    func videoPlayPressed(sender: PlayVideoButton){
        self.playLesson(token: sender.videoUrl!)
        self.network.logFirebaseEvents(logEventsName: "Wistia" + sender.videoUrl! + "VideoPlayed", parameterd: ["name" : sender.videoUrl!])
    }
    
    
    func completeLesson(sender: DashBoardButton){
        
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: true
        )
        let lessonCompletePopUp = SCLAlertView(appearance: appearance)
        let alertViewIcon = #imageLiteral(resourceName: "alertIcon_LessonComplete")
        
        lessonCompletePopUp.addButton("MASTERED") {
            
            if let userProgram = self.network.user?.programs![0] {
                
                if (userProgram.completedLessons > 1) && (self.network.user?.isOnSubscription == false){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.subscribeNowPopUp()
                    }
                } else {
                    self.placeCongratsView()
                    self.network.markComplete(lessonId: sender.actionKey!, user: self.network.user!, userProgram: userProgram) { isReady in
                        self.updateLessonView(program: userProgram)
                    }
                }
            }
        }
        
        lessonCompletePopUp.showWarning("Ready to move on to your next mission?", subTitle: "", closeButtonTitle: "NOT YET", circleIconImage: alertViewIcon)
        
    }
    
    
    func subscribeNowPopUp(){
        let subscriptionPopUp = SCLAlertView()
        
        subscriptionPopUp.addButton("Learn More") {
            self.subscriptionPressed()
        }
        
        subscriptionPopUp.showInfo("Pupster Membership", subTitle: "Become a Pupster Member today to unlock the entire program.", closeButtonTitle: "Not Now")
    }
    
    
    func placeCongratsView(){
        let congratsView = LessonCompleteView(name: "", image: Global.network.userProfileImage, imageUrl: self.network.user?.userProfileImageUrl)
        congratsView.translatesAutoresizingMaskIntoConstraints = false
        //self.view.addSubview(congratsView)
        guard let baseVC = self.pupserBase else { return }
        baseVC.view.addSubview(congratsView)
        
        congratsView.topAnchor.constraint(equalTo: baseVC.view.topAnchor).isActive = true
        congratsView.bottomAnchor.constraint(equalTo: baseVC.view.bottomAnchor).isActive = true
        congratsView.leftAnchor.constraint(equalTo: baseVC.view.leftAnchor).isActive = true
        congratsView.rightAnchor.constraint(equalTo: baseVC.view.rightAnchor).isActive = true
        
    }
    
}


extension NewDashboardViewController: VideoProtocol {
    func playLesson(token: String){
        self.playVideo(with: VideoDataSource.wistia, token: token)
    }
}
