//
//  MediaBehaviors.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/21/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Foundation
import Alamofire
import AlamofireImage
import SCLAlertView

enum VideoDataSource{
    case firebase
    case wistia
}

protocol VideoProtocol {
    func playVideo(with source: VideoDataSource, url: String?, token: String?)
    func processVideo(urlString: String) -> AVPlayer
    func presentAVViewController(player: AVPlayer)
}

extension VideoProtocol {
    func playVideo(with source: VideoDataSource, url: String? = nil, token: String? = nil){
        if let token = token, source == .wistia{
            self.presentAVViewController(player: self.processVideo(urlString: "https://thepupster.wistia.com/embed/medias/\(token).m3u8"))
        }
        
        if let url = url, source == .firebase {
            self.presentAVViewController(player: self.processVideo(urlString: url))
        }
    }
    
    func processVideo(urlString: String) -> AVPlayer {
        if let url = URL(string: urlString){
            return AVPlayer(url: url)
        }else{
            return AVPlayer()
        }
    }
}

extension VideoProtocol where Self: UIViewController {
    func presentAVViewController(player: AVPlayer){
        let vc = LandscapeAVPlayerController()
        vc.player = player
        self.present(vc, animated: true, completion: {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            }
            catch {
            }
            
            vc.player?.play()
        })
    }
}

class LandscapeAVPlayerController: AVPlayerViewController {
    //Matt: Uncomment here if he really wants to default AV View to horizontal
    
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //        return .landscapeRight
    //    }
}

protocol ImageProtocol {
    func downloadImage(stringUrl: String, completion: @escaping (_ image: UIImage) -> Void)
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage) -> Void)
}

extension ImageProtocol{
    func downloadImage(stringUrl: String, completion: @escaping (_ image: UIImage) -> Void) {
        
        if let url = URL(string: stringUrl){
            self.downloadImage(url: url) { (imageData) in
                completion(imageData)
            }
        }else{
            completion(UIImage())
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage) -> Void) {
        Alamofire.request(url).responseImage { (response) in
            if let image = response.result.value {
                completion(image)
            }else{
                completion(UIImage())
            }
        }
    }
}

