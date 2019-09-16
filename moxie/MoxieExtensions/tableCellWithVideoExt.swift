//
//  tableCellWithVideoExt.swift
//  moxie
//
//  Created by Tomoki Takasawa on 6/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class tableCellWithVideoExt: UITableViewCell {
    
    var videoRef: String = "none"
    weak var delegate: PlayVideoCellProtocol!
    
    let background: UIView = {
        let b = UIView()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor.white
        
        return b
    }()
    
    let videoButton: UIButton = {
        let v = UIButton()
        //MustDo: provide playButton
        v.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        
        return v
    }()
    let contentImage: UIImageView = {
        let c = UIImageView()
        c.contentMode = .scaleAspectFit
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func placeButtonOnTableCell(videoRef: String){
        self.videoRef = videoRef
        contentImage.addSubview(videoButton)
        
        videoButton.centerXAnchor.constraint(equalTo: contentImage.centerXAnchor).isActive = true
        videoButton.centerYAnchor.constraint(equalTo: contentImage.centerYAnchor).isActive = true
        videoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        videoButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        
        contentImage.isUserInteractionEnabled = true
        self.videoButton.addTarget(self, action: #selector(self.playPressed), for: .touchUpInside)
        self.videoButton.isUserInteractionEnabled = true
        
    }
    
    @objc func playPressed(){
        let vc = AVPlayerViewController()
        
        vc.view.frame = (contentImage.bounds)
        
        if let videoURL = URL(string: "https://thepupster.wistia.com/embed/medias/\(self.videoRef).m3u8"){
            let avPlayer = AVPlayer(url: videoURL)
            vc.player = avPlayer
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            }
            catch {
                // report for an error
            }
            
            self.delegate.playVideoButtonDidSelect(imageV: contentImage, vc: vc)
//            self.delegate?.playVideoButtonDidSelect(imageV: contentImage, vc: vc?)
        }else{
            
        }
    }
    
    func setBackground(){
        self.background.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.background.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.background.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
    }
    
    func setImageForCell(url: String, completion: @escaping (_ success: Bool) -> Void){
        
        if let urlImage = URL(string: url){
            contentImage.af_setImage(withURL: urlImage, placeholderImage: #imageLiteral(resourceName: "marketLoadingPlace"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: true){
                complete in
                
                if(complete.result.isSuccess){
                    //print("success")
                }else{
                    //print("failed")
                    print(complete.error.debugDescription)
                    print(urlImage)
                }
            }
        }
        
        completion(true)
    }
    
    func getHeight() -> CGFloat {
        return self.frame.height
    }
    
}
