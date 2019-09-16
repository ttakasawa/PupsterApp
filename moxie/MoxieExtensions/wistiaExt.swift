//
//  wistiaExt.swift
//  moxie
//
//  Created by Tomoki Takasawa on 6/13/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import SCLAlertView
import UIKit
import AVKit



protocol wistiaExtension {
    func HandleUnauthorizedError()
    func HandleServerError()
    func playWistia(videoURLString: String)
}
extension wistiaExtension where Self:UIViewController {
    func playWistia(videoURLString: String){
        
        let vc = LandscapeAVPlayerController()
        let videoURL = URL(string: "https://thepupster.wistia.com/embed/medias/\(videoURLString).m3u8")!
        let avPlayer = AVPlayer(url: videoURL)
        vc.player = avPlayer
        self.present(vc, animated: true, completion: {
            //Matt: Uncomment here if he really wants to default AV View to horizontal
//            do {
//                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            }
//            catch {
//            }
            vc.player?.play()
        })
    }
    
    func HandleUnauthorizedError(){
        SCLAlertView().showWarning("Unauthorized", subTitle: "Please make sure that you have been logged in to view this video")
    }
    
    func HandleServerError(){
        SCLAlertView().showWarning("Whoops!", subTitle: "Sorry, this video may be temporarily unavailable. Please come back later on!")
    }
    
}
