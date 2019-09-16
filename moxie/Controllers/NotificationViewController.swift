//
//  NotificationViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 2/7/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

//
//  AchievementsViews.swift
//  moxie
//
//  Created by Tomoki Takasawa on 1/12/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

//ProfileView.swift
import UIKit
//import PureLayout

class NotificationViewController: UIView {

    

    
    let emblem: UIImageView = {
        let EImage = #imageLiteral(resourceName: "bell")
        
        let E = UIImageView(image: EImage)
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 160).isActive = true
        E.heightAnchor.constraint(equalToConstant: 160).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        //E.isUserInteractionEnabled = true
        
        return E
    }()
    
    
    let title: UILabel = {
        let title = UILabel()
        title.text = "Allow Notifications"
        title.textColor = UIColor.white
        title.textAlignment = .center
        title.font = UIFont.init(name: "AvenirNext-DemiBold", size: 36)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.widthAnchor.constraint(equalToConstant: 320).isActive = true
        title.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        return title
    }()
    
    let NotificationExplanation: UILabel = {
        let AEL = UILabel()
        AEL.text = "Enable notifications so that Moxie/ncan send you timely training/n reminders and tips!"
        AEL.textColor = UIColor.white
        AEL.textAlignment = .center
        AEL.font = UIFont.init(name: "AvenirNext-Medium", size: 20)
        AEL.numberOfLines = 3
        AEL.translatesAutoresizingMaskIntoConstraints = false
        AEL.widthAnchor.constraint(equalToConstant: 330).isActive = true
        AEL.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        return AEL
    }()
    
    let EnableButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red:0.11, green:0.69, blue:0.96, alpha:1)
        button.layer.cornerRadius = 8
        button.setTitle("COLLECT YOUR REWARD", for: .normal)
        button.setTitleColor(UIColor.white, for:.normal)
        button.titleLabel?.font = UIFont(name:"AvenirNext-DemiBold", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 284).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button

    }()
    
    let NotNowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red:0.83, green:0.19, blue:0.19, alpha:1)
        button.layer.cornerRadius = 8
        button.setTitle("NOT NOW", for: .normal)
        button.setTitleColor(UIColor.white, for:.normal)
        button.titleLabel?.font = UIFont(name:"AvenirNext-DemiBold", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 155).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        //AwardNameLabel.text = text
        
        self.backgroundColor = UIColor(red:0.4, green:0.41, blue:0.43, alpha:1)
        
        
    }
    
    var TargetString: String = "Intro"
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        
        TargetString = text
        
        
        //if(text == "Sit"){
        self.backgroundColor = UIColor(red:0.4, green:0.41, blue:0.43, alpha:1)
        self.addSubview(title)
        self.addSubview(NotificationExplanation)
        self.addSubview(emblem)
        self.addSubview(EnableButton)
        self.addSubview(NotNowButton)
        
        self.bringSubview(toFront: self)
        
        setPosition()
        
        //EnableButton.addTarget(self, action: #selector(NotificationViewController.ToLesson), for: .touchUpInside)tmt@gmail.com
        
        EnableButton.addTarget(self, action: #selector(NotificationViewController.ToLesson), for: .touchUpInside)
        
        NotNowButton.addTarget(self, action: #selector(NotificationViewController.Notnow), for: .touchUpInside)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setPosition(){
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 82).isActive = true
        
        NotificationExplanation.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        NotificationExplanation.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        
        emblem.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        emblem.topAnchor.constraint(equalTo: NotificationExplanation.bottomAnchor, constant: 57).isActive = true
        
        EnableButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        EnableButton.topAnchor.constraint(equalTo: emblem.bottomAnchor, constant: 70).isActive = true
        
        NotNowButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        NotNowButton.topAnchor.constraint(equalTo: EnableButton.bottomAnchor, constant: 20).isActive = true
    }
    
    func removeView(){
        removeFromSuperview()
    }
    
    @objc func Notnow(){
        removeFromSuperview()
    }
    
    @objc func ToLesson(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let base = sb.instantiateViewController(withIdentifier: "story_basic") as! story_basic
        let vc = sb.instantiateViewController(withIdentifier: "IntroductionActivity") as! introduction_basics
        
        //vc.testingToIntro();
        //removeFromSuperview()
        
        //UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: false, completion: nil)
        //print(self.superview)
        
        //self.navigationController?.pushViewController(vc, animated: false)
        //base.present(vc, animated: false, completion: nil)
        
        
        base.present(vc, animated: true, completion: nil)

        
    }

}
