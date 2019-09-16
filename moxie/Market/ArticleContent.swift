//
//  ArticleContent.swift
//  Testing
//
//  Created by Tomoki Takasawa on 6/8/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

//
//  MarketTiles.swift
//  moxie
//
//  Created by Tomoki Takasawa on 5/23/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol PlayVideoCellProtocol: class {
    func playVideoButtonDidSelect(imageV: UIImageView, vc: AVPlayerViewController)
}


class ArticleContent: UITableViewCell {
    
    var content: String?
    weak var delegate: PlayVideoCellProtocol!
    
    let activityLoading: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        //aiv.startAnimating()
        return aiv
    }()
    
    
    let videoButton: UIButton = {
        let v = UIButton()
        v.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        
        return v
    }()
    
    let background: UIView = {
        let b = UIView()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor.white
        
        return b
    }()
    
    let contentImage: UIImageView = {
        let c = UIImageView()
        c.contentMode = .scaleAspectFit
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()
    
    let contents: UITextView = {
        let t = UITextView()
        //c.translatesAutoresizingMaskIntoConstraints = false
        //t.numberOfLines = 0
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = UIFont.init(name: "AvenirNext-Medium", size: 16)
        t.textColor = UIColor.black
        t.textAlignment = .left
        t.isScrollEnabled = false
        t.isEditable = false
        
        return t
    }()
    
    var videoRef: String = "none"
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 0.39)
        
        
        self.addSubview(background)
        self.background.addSubview(contentImage)
        self.background.addSubview(contents)
        
        
        self.background.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.background.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.background.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        self.contentImage.topAnchor.constraint(equalTo: self.background.topAnchor, constant: 15).isActive = true
        self.contentImage.leftAnchor.constraint(equalTo: self.background.leftAnchor, constant: 15).isActive = true
        self.contentImage.rightAnchor.constraint(equalTo: self.background.rightAnchor, constant: -15).isActive = true
        self.contentImage.heightAnchor.constraint(equalTo: self.contentImage.widthAnchor, multiplier: 0.75).isActive = true
        
        self.contents.topAnchor.constraint(equalTo: self.contentImage.bottomAnchor, constant: 10).isActive = true
        self.contents.leftAnchor.constraint(equalTo: self.background.leftAnchor, constant: 15).isActive = true
        self.contents.rightAnchor.constraint(equalTo: self.background.rightAnchor, constant: -15).isActive = true
        self.contents.bottomAnchor.constraint(equalTo: self.background.bottomAnchor, constant: -15).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let articlContent = content {
            contents.text = articlContent
        }
        
    }
    
    func setImageForCell(url: String, completion: @escaping (_ success: Bool) -> Void){
        if let urlImage = URL(string: url){
            contentImage.af_setImage(withURL: urlImage, placeholderImage: #imageLiteral(resourceName: "marketLoadingPlace"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: true){
                complete in
                if(!complete.result.isSuccess){
                    print("failed")
                }
            }
        }
        
        completion(true)
    }
    
    func placeButtonOnTableCell(videoRef: String){
        self.videoRef = videoRef
        contentImage.addSubview(videoButton)
        
        videoButton.centerXAnchor.constraint(equalTo: contentImage.centerXAnchor).isActive = true
        videoButton.centerYAnchor.constraint(equalTo: contentImage.centerYAnchor).isActive = true
        videoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        videoButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        contentImage.addSubview(activityLoading)
        
        activityLoading.centerXAnchor.constraint(equalTo: contentImage.centerXAnchor).isActive = true
        activityLoading.centerYAnchor.constraint(equalTo: contentImage.centerYAnchor).isActive = true
        activityLoading.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityLoading.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        contentImage.isUserInteractionEnabled = true
        self.videoButton.addTarget(self, action: #selector(self.playPressed), for: .touchUpInside)
        self.videoButton.isUserInteractionEnabled = true
        
    }
    
    @objc func playPressed(){
        self.activityLoading.startAnimating()
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
            self.activityLoading.stopAnimating()
            self.delegate.playVideoButtonDidSelect(imageV: contentImage, vc: vc)
        }else{
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        
        //print("selected")
        
        // Configure the view for the selected state
    }
    
    
    
}



