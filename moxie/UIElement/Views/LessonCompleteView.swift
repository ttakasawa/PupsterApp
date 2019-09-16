//
//  LessonCompleteView.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/13/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import Cheers
import StoreKit

class LessonCompleteView: UIView , Stylable{
    let cheerView = CheerView()
    var profileImage: ProfileImageView!
    var doneButton = DashBoardButton(title: "CONTINUE")
    var textLabel: TileLabel!
    let successImageView = UIImageView(image: #imageLiteral(resourceName: "labelSuccess"))
    let nicelyDoneImageView = UIImageView(image: #imageLiteral(resourceName: "labelNicelyDone"))
    
    init(name: String, image: UIImage?, imageUrl: String?){
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .white
        
        let labelText = "You’ve mastered this activity,\n now keep going!"
        self.textLabel = TileLabel(text: labelText, style: TileLabelStyling(font: self.getNormalTextFont(), color: self.getMainColor()))
        self.textLabel.numberOfLines = 2
        self.textLabel.textAlignment = .center
        
        doneButton.configureStyle(style: DashBoardMainButtonStyle(themeColor: self.getMainColor()))
        
        self.profileImage = ProfileImageView(image: image, imageUrl: imageUrl)
        self.configure()
        self.setActions()
        
        doneButton.isUserInteractionEnabled = false
        // Configure
        cheerView.config.particle = .confetti(allowedShapes: Particle.ConfettiShape.all)
        
        // Start
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // change 2 to desired number of seconds
            self.cheerView.start()
            self.doneButton.isUserInteractionEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.cheerView.stop()
            }
        }
        
    }
    
    func configure(){
        
        self.addSubview(cheerView)
        self.addSubview(successImageView)
        self.addSubview(profileImage)
        self.addSubview(nicelyDoneImageView)
        self.addSubview(textLabel)
        self.addSubview(doneButton)
        
        successImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        nicelyDoneImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.constrain()
    }
    
    func setActions(){
        doneButton.addTarget(self, action: #selector(self.removeThisView), for: .touchUpInside)
    }
    
    func constrain(){
        
        let profileWidth = ScreenSize.SCREEN_WIDTH * 148 / 375
        self.profileImage.configure(radius: profileWidth / 2.0)
        
        cheerView.frame = CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT)
        //cheerView.config.customize
        
        profileImage.bottomAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: profileWidth).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
        
        successImageView.bottomAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        successImageView.leftAnchor.constraint(equalTo: profileImage.leftAnchor, constant: -43).isActive = true
        successImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 12).isActive = true
        successImageView.heightAnchor.constraint(equalTo: successImageView.widthAnchor, multiplier: 80.0 / 264.0).isActive = true
        
        successImageView.contentMode = .scaleAspectFit
        
        nicelyDoneImageView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 14).isActive = true
        nicelyDoneImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 95).isActive = true
        nicelyDoneImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nicelyDoneImageView.heightAnchor.constraint(equalTo: nicelyDoneImageView.widthAnchor, multiplier: 63.0 / 183.0).isActive = true
        
        textLabel.topAnchor.constraint(equalTo: nicelyDoneImageView.bottomAnchor, constant: 6).isActive = true
        textLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 60).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        doneButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        doneButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    @objc func removeThisView(){
        
        
        UIView.animate(withDuration: 0.6, animations: {
            self.alpha = 0.0
        }, completion: { (value: Bool) in
            self.removeFromSuperview()
            guard let user = Global.network.user else { return }
            guard let programs = user.programs else { return }
            let program = programs[0]
            
            if program.completedLessons == 1 {
                if #available( iOS 10.3,*){
                    SKStoreReviewController.requestReview()
                }
            }
            
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Stylable where Self: LessonCompleteView {
    func getNormalTextFont() -> UIFont {
        return UIFont(name: "SFProText-Bold", size: 17)!
    }
}


class ProfileImageView: UIView, Stylable, ImageProtocol {
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "defaultProfile"))
    init(image: UIImage?, imageUrl: String?){
        super.init(frame: CGRect.zero)
        
        if let image = image{
            self.updateWithImage(image: image)
            
        }
        else if let imageUrl = imageUrl{
            self.updateWithUrl(imageUrl: imageUrl)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithUrl(imageUrl: String){
        self.downloadImage(stringUrl: imageUrl) { (userImage) in
            self.profileImageView.image = userImage
        }
    }
    
    func updateWithImage(image: UIImage){
        profileImageView.image = image
    }
    
    func configure(radius: CGFloat){
        let imageViewHeight = radius * 2 - 8
        
        self.backgroundColor = self.getMainColor()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = radius
        
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.cornerRadius = radius - 4
        profileImageView.isUserInteractionEnabled = false
        
        //self.addSubview(profileBaseView)
        self.addSubview(profileImageView)
        
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
    }
}
