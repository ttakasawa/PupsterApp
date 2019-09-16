//
//  achievementsViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 12/30/17.
//  Copyright © 2017 Tomoki Takasawa. All rights reserved.
//

import UIKit
import AlamofireImage

class achievementsViewController: UIViewController, LoginHandling, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var prevDog: String = "none"
    var nextDog: String = "none"
    
    var panel: UIView!
    var user: UserData?
    @IBOutlet weak var ScrollableView: UIView!
    
    struct LessonBadge {
        static var sit = "Sit"
        static var come = "Come"
        static var lay = "Lay"
        static var leash = "Leash Walking"
        static var crate = "Crate Training"
        static var touch = "Touch"
        static var shake = "Shake"
        static var jump = "Jump"
        static var footsies = "Footsies"
        static var circle = "Circle"
        static var final = "Pupster Certification"
        static var lock = "Locked"
    }
    
    
    
    let hideLeft: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red:0.35, green:0.38, blue:0.46, alpha:1)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    let hideRight: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red:0.35, green:0.38, blue:0.46, alpha:1)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    let prevDogButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isUserInteractionEnabled = true
        b.setBackgroundImage(#imageLiteral(resourceName: "prevDogButton"), for: .normal)
        b.addTarget(self, action: #selector(story_basic.toPrevDog), for: .touchUpInside)
        
        
        return b
    }()
    
    let nextDogButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isUserInteractionEnabled = true
        b.setBackgroundImage(#imageLiteral(resourceName: "nextDogButton"), for: .normal)
        b.addTarget(self, action: #selector(story_basic.toNextDog), for: .touchUpInside)
        
        
        return b
        
    }()
    
    
    let UserInfoContainer: UIView = {
        let UIC = UIView()
        UIC.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
        UIC.translatesAutoresizingMaskIntoConstraints = false
        
        return UIC
    }()
    
    /*let userImage: UIImage = {
        
    }()*/
    
    let UserName: UILabel = {
        let name = UILabel()
        //user.text = "Matt Saucedo"
        
        name.textColor = UIColor(red:0.4, green:0.41, blue:0.43, alpha:1)
        name.font = UIFont.init(name: "AvenirNext-DemiBold", size: 20)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textAlignment = .left
        
        return name
    }()
    
    let LineBreaker1: UIView = {
        let LB = UIView()
        LB.backgroundColor = UIColor(red:0.81, green:0.81, blue:0.81, alpha:1)
        LB.translatesAutoresizingMaskIntoConstraints = false
        
        return LB
    }()
    
    let LineBreaker2: UIView = {
        let LB2 = UIView()
        //LB2.backgroundColor = UIColor(red:0.81, green:0.81, blue:0.00, alpha:1)
        LB2.backgroundColor = UIColor(red:0.81, green:0.81, blue:0.81, alpha:1)

        LB2.translatesAutoresizingMaskIntoConstraints = false
        
        return LB2
    }()
    
    let LineBreaker3: UIView = {
        let LB3 = UIView()
        //LB2.backgroundColor = UIColor(red:0.81, green:0.81, blue:0.00, alpha:1)
        LB3.backgroundColor = UIColor(red:0.81, green:0.81, blue:0.81, alpha:1)
        
        LB3.translatesAutoresizingMaskIntoConstraints = false
        
        return LB3
    }()
    
    let StatusContainer: UIView = {
        let SC = UIView()
        SC.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
        SC.translatesAutoresizingMaskIntoConstraints = false
        
        return SC
    }()
    
    let DailyStreakLabel: UILabel = {
        let DSL = UILabel()
        DSL.text = "CURRENT DAILY STREAK"
        DSL.textColor = UIColor(red:0.4, green:0.41, blue:0.43, alpha:1)
        DSL.font = UIFont.init(name: "AvenirNext-DemiBold", size: 15)
        DSL.translatesAutoresizingMaskIntoConstraints = false
        
        return DSL
    }()
    
    let DailyStreakEmblem: UIImageView = {
        let DSEimage = #imageLiteral(resourceName: "streak")
        let DSE = UIImageView(image: DSEimage)
        DSE.translatesAutoresizingMaskIntoConstraints = false
        
        return DSE
    }()
    
    let DailystreakNumber: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:0.95, green:0.27, blue:0, alpha:1)
        label.font = UIFont.init(name: "AvenirNext-DemiBold", size: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let TotalSessionLabel: UILabel = {
        let TSL = UILabel()
        TSL.text = "TOTAL TRAINING DAYS"
        TSL.textColor = UIColor(red:0.4, green:0.41, blue:0.43, alpha:1)
        TSL.font = UIFont.init(name: "AvenirNext-DemiBold", size: 15)
        TSL.translatesAutoresizingMaskIntoConstraints = false
        TSL.textAlignment = .center
        
        return TSL
    }()
    
    let TotalSessionEmblem: UIImageView = {
        let TSEimage = #imageLiteral(resourceName: "totalSession")
        let TSE = UIImageView(image: TSEimage)
        TSE.translatesAutoresizingMaskIntoConstraints = false
        
        return TSE
    }()
    
    let SessionNumber: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:0.95, green:0.27, blue:0, alpha:1)
        label.font = UIFont.init(name: "AvenirNext-DemiBold", size: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let AchievementsContainer: UIView = {
        let AC = UIView()
        AC.backgroundColor = UIColor(red:0.35, green:0.38, blue:0.46, alpha:1)
        AC.translatesAutoresizingMaskIntoConstraints = false
        
        return AC
    }()
    
    let AchievementLabel: UILabel = {
        let AL = UILabel()
        AL.text = "ACHIEVEMENTS"
        AL.textColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
        AL.font = UIFont.init(name: "AvenirNext-DemiBold", size: 25)
        AL.translatesAutoresizingMaskIntoConstraints = false
        AL.textAlignment = .center
        AL.adjustsFontSizeToFitWidth = true
        
        
        return AL
    }()
    
    
    
    let emblem1: UIImageView = {
        let EImage = #imageLiteral(resourceName: "SitEmblemDog")
        
        let E = UIImageView(image: EImage)
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 66).isActive = true
        E.heightAnchor.constraint(equalToConstant: 66).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        //E.isUserInteractionEnabled = true
        
        return E
    }()
    
    let container1: UIButton = {
        let C = UIButton()
        C.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
        C.backgroundColor = UIColor(red:0.62, green:0.53, blue:0.75, alpha:1)
        C.translatesAutoresizingMaskIntoConstraints = false
        C.layer.cornerRadius = 44
        C.layer.borderWidth = 5
        C.isUserInteractionEnabled = true
        
        return C
    }()
    
    let emblem2: UIImageView = {
        let EImage = #imageLiteral(resourceName: "ComeBudge")
        
        let E = UIImageView(image: EImage)
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 66).isActive = true
        E.heightAnchor.constraint(equalToConstant: 66).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        
        return E
    }()
    
    let container2: UIButton = {
        let C = UIButton()
        C.translatesAutoresizingMaskIntoConstraints = false
        C.layer.cornerRadius = 44
        C.layer.borderWidth = 5
        C.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
        C.backgroundColor = UIColor(red:0.62, green:0.53, blue:0.75, alpha:1)
        C.clipsToBounds = false
        
        return C
    }()
    
    let emblem3: UIImageView = {
        let EImage = #imageLiteral(resourceName: "LayTraining")
        
        let E = UIImageView(image: EImage)
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 66).isActive = true
        E.heightAnchor.constraint(equalToConstant: 66).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        
        return E
    }()
    
    let container3: UIButton = {
        let C = UIButton()
        C.translatesAutoresizingMaskIntoConstraints = false
        C.layer.cornerRadius = 44
        C.layer.borderWidth = 5
        C.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
        C.backgroundColor = UIColor(red:0.62, green:0.53, blue:0.75, alpha:1)
        
        return C
    }()
    
    let emblem4: UIImageView = {
        let EImage = #imageLiteral(resourceName: "LeashBudge")
        
        let E = UIImageView(image: EImage)
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 66).isActive = true
        E.heightAnchor.constraint(equalToConstant: 66).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        
        return E
    }()
    
    let container4: UIButton = {
        let C = UIButton()
        C.translatesAutoresizingMaskIntoConstraints = false
        C.layer.cornerRadius = 44
        C.layer.borderWidth = 5
        C.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
        C.backgroundColor = UIColor(red:0.62, green:0.53, blue:0.75, alpha:1)
        
        return C
    }()
    
    let emblem5: UIImageView = {
        let EImage = #imageLiteral(resourceName: "CrateTraining")
        
        let E = UIImageView(image: EImage)
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 66).isActive = true
        E.heightAnchor.constraint(equalToConstant: 66).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        
        return E
    }()
    
    let container5: UIButton = {
        let C = UIButton()
        C.translatesAutoresizingMaskIntoConstraints = false
        C.layer.cornerRadius = 44
        C.layer.borderWidth = 5
        C.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
        C.backgroundColor = UIColor(red:0.62, green:0.53, blue:0.75, alpha:1)
        
        return C
    }()
    
    let emblem6: UIImageView = {
        let EImage = #imageLiteral(resourceName: "badgeTouch")
        
        let E = UIImageView(image: EImage)
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 66).isActive = true
        E.heightAnchor.constraint(equalToConstant: 66).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        
        return E
    }()
    
    let container6: UIButton = {
        let C = UIButton()
        C.translatesAutoresizingMaskIntoConstraints = false
        C.layer.cornerRadius = 44
        C.layer.borderWidth = 5
        C.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
        C.backgroundColor = UIColor(red:0.62, green:0.53, blue:0.75, alpha:1)
        
        return C
    }()
    
    let emblem7: UIImageView = {
        let EImage = #imageLiteral(resourceName: "badgeShake")
        
        let E = UIImageView(image: EImage)
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 60).isActive = true
        E.heightAnchor.constraint(equalToConstant: 60).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        
        return E
    }()
    
    let container7: UIButton = {
        let C = UIButton()
        C.translatesAutoresizingMaskIntoConstraints = false
        C.layer.cornerRadius = 44
        C.layer.borderWidth = 5
        C.layer.borderColor = UIColor.white.cgColor
        C.backgroundColor = UIColor(red:0.62, green:0.53, blue:0.75, alpha:1)
        
        return C
    }()
    
    let emblem8: UIImageView = {
        let EImage = #imageLiteral(resourceName: "badgeJump")
        
        let E = UIImageView(image: EImage)
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 60).isActive = true
        E.heightAnchor.constraint(equalToConstant: 60).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        
        return E
    }()
    
    let container8: UIButton = {
        let C = UIButton()
        C.translatesAutoresizingMaskIntoConstraints = false
        C.layer.cornerRadius = 44
        C.layer.borderWidth = 5
        C.layer.borderColor = UIColor.white.cgColor
        C.backgroundColor = UIColor(red:0.62, green:0.53, blue:0.75, alpha:1)
        
        return C
    }()
    
    let emblem9: UIImageView = {
        let EImage = #imageLiteral(resourceName: "badgeFootsies")
        
        let E = UIImageView(image: EImage)
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 60).isActive = true
        E.heightAnchor.constraint(equalToConstant: 60).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        
        return E
    }()
    
    let container9: UIButton = {
        let C = UIButton()
        C.translatesAutoresizingMaskIntoConstraints = false
        C.layer.cornerRadius = 44
        C.layer.borderWidth = 5
        C.layer.borderColor = UIColor.white.cgColor
        C.backgroundColor = UIColor(red:0.62, green:0.53, blue:0.75, alpha:1)
        
        return C
    }()
    
    let emblem10: UIImageView = {
        let image = #imageLiteral(resourceName: "badgeCircle")
        
        let E = UIImageView(image: image)
        
        
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 66).isActive = true
        E.heightAnchor.constraint(equalToConstant: 66).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        
        return E
    }()
    
    let container10: UIButton = {
        let C = UIButton()
        C.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
        C.backgroundColor = UIColor(red:0.62, green:0.53, blue:0.75, alpha:1)
        C.translatesAutoresizingMaskIntoConstraints = false
        C.layer.cornerRadius = 44
        C.layer.borderWidth = 5
        C.isUserInteractionEnabled = true
        
        return C
    }()
    
    let emblem11: UIImageView = {
        let EImage =  #imageLiteral(resourceName: "DiplomatBudge")
        
        let E = UIImageView(image: EImage)
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 55).isActive = true
        E.heightAnchor.constraint(equalToConstant: 55).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        //E.isUserInteractionEnabled = true
        
        return E
    }()
    
    let container11: UIButton = {
        let C = UIButton()
        C.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
        C.backgroundColor = UIColor(red:0.62, green:0.53, blue:0.75, alpha:1)
        C.translatesAutoresizingMaskIntoConstraints = false
        C.layer.cornerRadius = 44
        C.layer.borderWidth = 5
        C.isUserInteractionEnabled = true
        
        return C
    }()
    
    let emblem12: UIImageView = {
        let EImage = #imageLiteral(resourceName: "LockIcon")
        
        let E = UIImageView(image: EImage)
        E.translatesAutoresizingMaskIntoConstraints = false
        E.widthAnchor.constraint(equalToConstant: 66).isActive = true
        E.heightAnchor.constraint(equalToConstant: 66).isActive = true
        E.clipsToBounds = true
        E.contentMode = UIViewContentMode.scaleAspectFit
        //E.isUserInteractionEnabled = true
        
        return E
    }()
    
    let container12: UIButton = {
        let C = UIButton()
        C.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
        C.backgroundColor = UIColor(red:0.27, green:0.69, blue:0.66, alpha:1)
        C.translatesAutoresizingMaskIntoConstraints = false
        C.layer.cornerRadius = 44
        C.layer.borderWidth = 5
        C.isUserInteractionEnabled = true
        
        return C
    }()
    
    let gearIcon : UIButton = {
        let g = UIButton()
        g.translatesAutoresizingMaskIntoConstraints = false
        g.setImage(#imageLiteral(resourceName: "settingIcon") , for: [])
        g.clipsToBounds = true
        
        return g
    }()
    
    let profileIcon : UIButton = {
        let g = UIButton()
        g.translatesAutoresizingMaskIntoConstraints = false
        g.setImage(#imageLiteral(resourceName: "defaultProfile") , for: [])
        g.clipsToBounds = true
        g.layer.cornerRadius = 30
        
        return g
    }()
    
    let cover1: UIButton = {
        let c = UIButton()
        c.backgroundColor = UIColor.black
        c.layer.opacity = 0.5
        c.layer.cornerRadius = 44
        c.translatesAutoresizingMaskIntoConstraints = false
        c.widthAnchor.constraint(equalToConstant: 88).isActive = true
        c.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        return c
    }()
    
    let cover2: UIButton = {
        let c = UIButton()
        c.backgroundColor = UIColor.black
        c.layer.opacity = 0.5
        c.translatesAutoresizingMaskIntoConstraints = false
        c.widthAnchor.constraint(equalToConstant: 88).isActive = true
        c.heightAnchor.constraint(equalToConstant: 88).isActive = true
        c.layer.cornerRadius = 44
        
        return c
    }()
    
    
    let cover3: UIButton = {
        let c = UIButton()
        c.backgroundColor = UIColor.black
        c.layer.opacity = 0.5
        c.translatesAutoresizingMaskIntoConstraints = false
        c.widthAnchor.constraint(equalToConstant: 88).isActive = true
        c.heightAnchor.constraint(equalToConstant: 88).isActive = true
        c.layer.cornerRadius = 44
        return c
    }()
    
    let cover4: UIButton = {
        let c = UIButton()
        c.backgroundColor = UIColor.black
        c.layer.opacity = 0.5
        c.translatesAutoresizingMaskIntoConstraints = false
        c.widthAnchor.constraint(equalToConstant: 88).isActive = true
        c.heightAnchor.constraint(equalToConstant: 88).isActive = true
        c.layer.cornerRadius = 44
        return c
    }()
    
    let cover5: UIButton = {
        let c = UIButton()
        c.backgroundColor = UIColor.black
        c.layer.opacity = 0.5
        c.translatesAutoresizingMaskIntoConstraints = false
        c.widthAnchor.constraint(equalToConstant: 88).isActive = true
        c.heightAnchor.constraint(equalToConstant: 88).isActive = true
        c.layer.cornerRadius = 44
        return c
    }()
    
    let cover6: UIButton = {
        let c = UIButton()
        c.backgroundColor = UIColor.black
        c.layer.opacity = 0.5
        c.translatesAutoresizingMaskIntoConstraints = false
        c.widthAnchor.constraint(equalToConstant: 88).isActive = true
        c.heightAnchor.constraint(equalToConstant: 88).isActive = true
        c.layer.cornerRadius = 44
        return c
    }()
    
    let cover7: UIButton = {
        let c = UIButton()
        c.backgroundColor = UIColor.black
        c.layer.opacity = 0.5
        c.layer.cornerRadius = 44
        c.translatesAutoresizingMaskIntoConstraints = false
        c.widthAnchor.constraint(equalToConstant: 88).isActive = true
        c.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        return c
    }()
    
    let cover8: UIButton = {
        let c = UIButton()
        c.backgroundColor = UIColor.black
        c.layer.opacity = 0.5
        c.layer.cornerRadius = 44
        c.translatesAutoresizingMaskIntoConstraints = false
        c.widthAnchor.constraint(equalToConstant: 88).isActive = true
        c.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        return c
    }()
    
    let cover9: UIButton = {
        let c = UIButton()
        c.backgroundColor = UIColor.black
        c.layer.opacity = 0.5
        c.layer.cornerRadius = 44
        c.translatesAutoresizingMaskIntoConstraints = false
        c.widthAnchor.constraint(equalToConstant: 88).isActive = true
        c.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        return c
    }()
    
    let cover10: UIButton = {
        let c = UIButton()
        c.backgroundColor = UIColor.black
        c.layer.opacity = 0.5
        c.layer.cornerRadius = 44
        c.translatesAutoresizingMaskIntoConstraints = false
        c.widthAnchor.constraint(equalToConstant: 88).isActive = true
        c.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        return c
    }()
    
    let cover11: UIButton = {
        let c = UIButton()
        c.backgroundColor = UIColor.black
        c.layer.opacity = 0.5
        c.layer.cornerRadius = 44
        c.translatesAutoresizingMaskIntoConstraints = false
        c.widthAnchor.constraint(equalToConstant: 88).isActive = true
        c.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        return c
    }()
    let cover12: UIButton = {
        let c = UIButton()
        c.backgroundColor = UIColor.black
        c.layer.opacity = 0.5
        c.layer.cornerRadius = 44
        c.translatesAutoresizingMaskIntoConstraints = false
        c.widthAnchor.constraint(equalToConstant: 88).isActive = true
        c.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
        
        self.ScrollableView.addSubview(UserInfoContainer)
        self.ScrollableView.addSubview(LineBreaker1)
        self.ScrollableView.addSubview(LineBreaker2)
        self.ScrollableView.addSubview(LineBreaker3)
        self.ScrollableView.addSubview(StatusContainer)
        self.ScrollableView.addSubview(AchievementsContainer)
        
        setPosition_UserInfo()
        setPosition_LineBreaker()
        setPosition_StatusContainer()
        setPosition_AchievementsContainer()
        
        
        coverAll()
        activateCover()
        
        gearIcon.addTarget(self, action: #selector(achievementsViewController.toSetting), for: .touchUpInside)
        
        
        activateBadge()
        getUserInfoFromBackEnd()
        getDogInfoFromBackEnd()
        getProfile()
        
        self.profileIcon.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        imagePicker.delegate = self
    }
    
    var imagePicker = UIImagePickerController()
    
//    @objc func pickImage(){
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//
//        present(imagePicker, animated: true, completion: nil)
//    }
    
    @objc func pickImage(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var chosenImage: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            chosenImage = editedImage
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            chosenImage = originalImage
        }
        
        if let selectedImage = chosenImage {
            self.profileIcon.setImage(selectedImage, for: .normal)
            UserManager.shared.uploadImageToStorage(newProfile: selectedImage)
        }
        
        dismiss(animated:true, completion: nil) //5
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Profile"
    }
    
    
    @objc func openBadge(sender: UIButton){
        //self.tabBarController?.tabBar.isHidden = true
        if sender == container1{
            achievementOpened(type: LessonBadge.sit)
        }else if sender == container2{
            achievementOpened(type: LessonBadge.come)
        }else if sender == container3{
            achievementOpened(type: LessonBadge.lay)
        }else if sender == container4{
            achievementOpened(type: LessonBadge.leash)
        }else if sender == container5{
            achievementOpened(type: LessonBadge.crate)
        }else if sender == container6{
            achievementOpened(type: LessonBadge.touch)
        }else if sender == container7{
            achievementOpened(type: LessonBadge.shake)
        }else if sender == container8{
            achievementOpened(type: LessonBadge.jump)
        }else if sender == container9{
            achievementOpened(type: LessonBadge.footsies)
        }else if sender == container10{
            achievementOpened(type: LessonBadge.circle)
        }else if sender == container11{
            achievementOpened(type: LessonBadge.final)
        }else if sender == container12{
            //achievementOpened(type: LessonBadge.sit)
        }
        
    }
    
    func activateBadge(){
        container1.addTarget(self, action: #selector(self.openBadge), for: .touchUpInside)
        container2.addTarget(self, action: #selector(self.openBadge), for: .touchUpInside)
        container3.addTarget(self, action: #selector(self.openBadge), for: .touchUpInside)
        container4.addTarget(self, action: #selector(self.openBadge), for: .touchUpInside)
        container5.addTarget(self, action: #selector(self.openBadge), for: .touchUpInside)
        container6.addTarget(self, action: #selector(self.openBadge), for: .touchUpInside)
        container7.addTarget(self, action: #selector(self.openBadge), for: .touchUpInside)
        container8.addTarget(self, action: #selector(self.openBadge), for: .touchUpInside)
        container9.addTarget(self, action: #selector(self.openBadge), for: .touchUpInside)
        container10.addTarget(self, action: #selector(self.openBadge), for: .touchUpInside)
        container11.addTarget(self, action: #selector(self.openBadge), for: .touchUpInside)
        container12.addTarget(self, action: #selector(self.openBadge), for: .touchUpInside)
    }
    
    func activateCover(){
        cover1.addTarget(self, action: #selector(self.coverAlert), for: .touchUpInside)
        cover2.addTarget(self, action: #selector(self.coverAlert), for: .touchUpInside)
        cover3.addTarget(self, action: #selector(self.coverAlert), for: .touchUpInside)
        cover4.addTarget(self, action: #selector(self.coverAlert), for: .touchUpInside)
        cover5.addTarget(self, action: #selector(self.coverAlert), for: .touchUpInside)
        cover6.addTarget(self, action: #selector(self.coverAlert), for: .touchUpInside)
        cover7.addTarget(self, action: #selector(self.coverAlert), for: .touchUpInside)
        cover8.addTarget(self, action: #selector(self.coverAlert), for: .touchUpInside)
        cover9.addTarget(self, action: #selector(self.coverAlert), for: .touchUpInside)
        cover10.addTarget(self, action: #selector(self.coverAlert), for: .touchUpInside)
        cover11.addTarget(self, action: #selector(self.coverAlert), for: .touchUpInside)
        cover12.addTarget(self, action: #selector(self.coverAlert), for: .touchUpInside)
    }
    
    @objc func coverAlert(sender: UIButton){
        
        if sender == cover1{
            panel = AchievementsViews(frame: self.view.frame, text: LessonBadge.sit, isComplete: false)
            self.view.addSubview(self.panel)
        }else if sender == cover2{
            panel = AchievementsViews(frame: self.view.frame, text: LessonBadge.come, isComplete: false)
            self.view.addSubview(self.panel)
        }else if sender == cover3{
            panel = AchievementsViews(frame: self.view.frame, text: LessonBadge.lay, isComplete: false)
            self.view.addSubview(self.panel)
        }else if sender == cover4{
            panel = AchievementsViews(frame: self.view.frame, text: LessonBadge.leash, isComplete: false)
            self.view.addSubview(self.panel)
        }else if sender == cover5{
            panel = AchievementsViews(frame: self.view.frame, text: LessonBadge.crate, isComplete: false)
            self.view.addSubview(self.panel)
        }else if sender == cover6{
            panel = AchievementsViews(frame: self.view.frame, text: LessonBadge.touch, isComplete: false)
            self.view.addSubview(self.panel)
        }else if sender == cover7{
            panel = AchievementsViews(frame: self.view.frame, text: LessonBadge.shake, isComplete: false)
            self.view.addSubview(self.panel)
        }else if sender == cover8{
            panel = AchievementsViews(frame: self.view.frame, text: LessonBadge.jump, isComplete: false)
            self.view.addSubview(self.panel)
        }else if sender == cover9{
            panel = AchievementsViews(frame: self.view.frame, text: LessonBadge.footsies, isComplete: false)
            self.view.addSubview(self.panel)
        }else if sender == cover10{
            panel = AchievementsViews(frame: self.view.frame, text: LessonBadge.circle, isComplete: false)
            self.view.addSubview(self.panel)
        }else if sender == cover11{
            panel = AchievementsViews(frame: self.view.frame, text: LessonBadge.final, isComplete: false)
            self.view.addSubview(self.panel)
        }else if sender == cover12{
            //achievementOpened(type: LessonBadge.sit)-ooou
        }
    }

    
    
    func hidePrevButton(){
        self.prevDogButton.addSubview(self.hideLeft)
        
        self.hideLeft.topAnchor.constraint(equalTo: self.prevDogButton.topAnchor).isActive = true
        self.hideLeft.bottomAnchor.constraint(equalTo: self.prevDogButton.bottomAnchor).isActive = true
        self.hideLeft.leftAnchor.constraint(equalTo: self.prevDogButton.leftAnchor).isActive = true
        self.hideLeft.rightAnchor.constraint(equalTo: self.prevDogButton.rightAnchor).isActive = true
        
    }
    
    func hideNextButton(){
        self.nextDogButton.addSubview(self.hideRight)
        
        self.hideRight.topAnchor.constraint(equalTo: self.nextDogButton.topAnchor).isActive = true
        self.hideRight.bottomAnchor.constraint(equalTo: self.nextDogButton.bottomAnchor).isActive = true
        self.hideRight.leftAnchor.constraint(equalTo: self.nextDogButton.leftAnchor).isActive = true
        self.hideRight.rightAnchor.constraint(equalTo: self.nextDogButton.rightAnchor).isActive = true
    }
    
    func achievementOpened(type: String){
        panel = AchievementsViews(frame: self.view.frame, text: type, isComplete: true)
        //self.view.addSubview(self.panel)
        UIView.transition(with: self.tabBarController?.view ?? self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.tabBarController?.view.addSubview(self.panel)
        }, completion: nil)
        
    }
    
    
    @objc func toSetting(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Setting")
        if let navigator = self.navigationController {
            navigator.pushViewController(vc, animated: true)
        }
        //present(vc, animated: true, completion: nil)
    }
    
    
}

extension achievementsViewController{
    func getUserInfoFromBackEnd(){
        UserManager.shared.getUsersStreak() { fname,lname,streak,session in
            print(streak)
            let NameString = fname + " " + lname
            self.UserName.text = NameString
            self.DailystreakNumber.text = streak
            if (Int(streak) ?? 0 < 10){
                self.DailystreakNumber.font = UIFont.init(name: "AvenirNext-DemiBold", size: 50)
                //label.font = UIFont.init(name: "AvenirNext-DemiBold", size: 40)
            }
            if (Int(streak) ?? 0 > 99){
                self.DailystreakNumber.font = UIFont.init(name: "AvenirNext-DemiBold", size: 30)
                //label.font = UIFont.init(name: "AvenirNext-DemiBold", size: 40)
            }
            
            self.SessionNumber.text = session
            
            self.user?.firstName = fname
            self.user?.lastName = lname
            self.user?.lastStreak = streak
            self.user?.lastSession = session
            
        }
    }
    
    func getProfile(){
        UserManager.shared.getOneUserInfomation(nodeToQuery: UserManager.Data2.Fields.profileImage){ urlString in
            
            let dummyImageView = UIImageView()
            var url: URL?
            
            if let url = URL(string: urlString){
                dummyImageView.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition , runImageTransitionIfCached: true){ complete in
                    
                    if let imageData: UIImage = complete.value{
                        self.profileIcon.setImage(imageData, for: .normal)
                    }
                }
            }
            
        }
    }
    
    func getDogInfoFromBackEnd(){
        
        UserManager.shared.getDogGeneralInfo(){ dName, prev, next, trainer, intro, sit, come, lay, leash, crate, trick, touch, shake, jump, footsies, circle, final in
            
            print("in achivement vc")
            print(prev)
            print(next)
            
            if (dName != "Pupster"){
                self.AchievementLabel.text = dName + "'s Awards"
            }
            
            if (prev != "none"){
                
                self.prevDog = prev
                self.prevDogButton.isUserInteractionEnabled = true
                
                self.hideLeft.removeFromSuperview()
            }else{
                
                self.prevDogButton.isUserInteractionEnabled = false
                self.hidePrevButton()
            }
            
            if (next != "none"){
                self.nextDog = next
                self.nextDogButton.isUserInteractionEnabled = true
                self.hideRight.removeFromSuperview()
            }else{
                
                self.nextDogButton.isUserInteractionEnabled = false
                self.hideNextButton()
            }
            
            if (intro == false){
                //88,44,black,opacity 0.5
            }
            if (sit == true){
                self.cover1.removeFromSuperview()
                self.container1.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
            }else{
                self.CoverEmblem1()
            }
            
            if (come == true){
                self.cover2.removeFromSuperview()
                self.container2.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
                
            }else{
                self.CoverEmblem2()
            }
            if (lay == true){
                self.cover3.removeFromSuperview()
                self.container3.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
            }else{
                self.CoverEmblem3()
            }
            if (leash == true){
                self.cover4.removeFromSuperview()
                self.container4.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
            }else{
                self.CoverEmblem4()
            }
            if (crate == true){
                self.cover5.removeFromSuperview()
                self.container5.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
            }else{
                self.CoverEmblem5()
            }
            if (touch == true){
                self.cover6.removeFromSuperview()
                self.container6.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
            }else{
                self.CoverEmblem6()
            }
            
            if (shake == true){
                self.cover7.removeFromSuperview()
                self.container7.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
            }else{
                self.CoverEmblem7()
            }
            if (jump == true){
                self.cover8.removeFromSuperview()
                self.container8.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
            }else{
                self.CoverEmblem8()
            }
            if (footsies == true){
                self.cover9.removeFromSuperview()
                self.container9.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
            }else{
                self.CoverEmblem9()
            }
            
            if (circle == true){
                self.cover10.removeFromSuperview()
                self.container10.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
            }else{
                self.CoverEmblem10()
            }
            if (final == true){
                self.cover11.removeFromSuperview()
                self.container11.layer.borderColor = UIColor(red:0.98, green:0.66, blue:0.09, alpha:1).cgColor
            }else{
                self.CoverEmblem11()
            }
        }
    }
        
    @objc func toNextDog(){
        //change current dog to nextDog
        UserManager.shared.changeCurrentDog(destNode: nextDog){ complete in
            if (complete == true){
                self.getDogInfoFromBackEnd()
                //change backgroun??
            }
        }
    }
    
    @objc func toPrevDog(){
        UserManager.shared.changeCurrentDog(destNode: prevDog){ complete in
            if (complete == true){
                self.getDogInfoFromBackEnd()
                //change backgroun??
            }
        }
    }
        
        
    
}

extension achievementsViewController{
    func coverAll(){
        CoverEmblem1()
        CoverEmblem2()
        CoverEmblem3()
        CoverEmblem4()
        CoverEmblem5()
        CoverEmblem6()
        CoverEmblem7()
        CoverEmblem8()
        CoverEmblem9()
        CoverEmblem10()
        CoverEmblem11()
        CoverEmblem12()
    }
    func CoverEmblem1(){
        self.AchievementsContainer.addSubview(self.cover1)
        self.cover1.centerXAnchor.constraint(equalTo: self.emblem1.centerXAnchor).isActive = true
        self.cover1.centerYAnchor.constraint(equalTo: self.emblem1.centerYAnchor).isActive = true
        self.container1.layer.borderColor = UIColor.white.cgColor
    }
    func CoverEmblem2(){
        self.AchievementsContainer.addSubview(self.cover2)
        self.cover2.centerXAnchor.constraint(equalTo: self.emblem2.centerXAnchor).isActive = true
        self.cover2.centerYAnchor.constraint(equalTo: self.emblem2.centerYAnchor).isActive = true
        self.container2.layer.borderColor = UIColor.white.cgColor
    }
    func CoverEmblem3(){
        self.AchievementsContainer.addSubview(self.cover3)
        self.cover3.centerXAnchor.constraint(equalTo: self.emblem3.centerXAnchor).isActive = true
        self.cover3.centerYAnchor.constraint(equalTo: self.emblem3.centerYAnchor).isActive = true
        self.container3.layer.borderColor = UIColor.white.cgColor
    }
    func CoverEmblem4(){
        self.AchievementsContainer.addSubview(self.cover4)
        self.cover4.centerXAnchor.constraint(equalTo: self.emblem4.centerXAnchor).isActive = true
        self.cover4.centerYAnchor.constraint(equalTo: self.emblem4.centerYAnchor).isActive = true
        self.container4.layer.borderColor = UIColor.white.cgColor
    }
    func CoverEmblem5(){
        self.AchievementsContainer.addSubview(self.cover5)
        self.cover5.centerXAnchor.constraint(equalTo: self.emblem5.centerXAnchor).isActive = true
        self.cover5.centerYAnchor.constraint(equalTo: self.emblem5.centerYAnchor).isActive = true
        self.container5.layer.borderColor = UIColor.white.cgColor
    }
    func CoverEmblem6(){
        self.AchievementsContainer.addSubview(self.cover6)
        self.cover6.centerXAnchor.constraint(equalTo: self.emblem6.centerXAnchor).isActive = true
        self.cover6.centerYAnchor.constraint(equalTo: self.emblem6.centerYAnchor).isActive = true
        self.container6.layer.borderColor = UIColor.white.cgColor
    }
    func CoverEmblem7(){
        self.AchievementsContainer.addSubview(self.cover7)
        self.cover7.centerXAnchor.constraint(equalTo: self.emblem7.centerXAnchor).isActive = true
        self.cover7.centerYAnchor.constraint(equalTo: self.emblem7.centerYAnchor).isActive = true
        self.container7.layer.borderColor = UIColor.white.cgColor
        
    }
    func CoverEmblem8(){
        self.AchievementsContainer.addSubview(self.cover8)
        self.cover8.centerXAnchor.constraint(equalTo: self.emblem8.centerXAnchor).isActive = true
        self.cover8.centerYAnchor.constraint(equalTo: self.emblem8.centerYAnchor).isActive = true
        self.container8.layer.borderColor = UIColor.white.cgColor
    }
    func CoverEmblem9(){
        self.AchievementsContainer.addSubview(self.cover9)
        self.cover9.centerXAnchor.constraint(equalTo: self.emblem9.centerXAnchor).isActive = true
        self.cover9.centerYAnchor.constraint(equalTo: self.emblem9.centerYAnchor).isActive = true
        self.container9.layer.borderColor = UIColor.white.cgColor
    }
    func CoverEmblem10(){
        self.AchievementsContainer.addSubview(self.cover10)
        self.cover10.centerXAnchor.constraint(equalTo: self.emblem10.centerXAnchor).isActive = true
        self.cover10.centerYAnchor.constraint(equalTo: self.emblem10.centerYAnchor).isActive = true
        self.container10.layer.borderColor = UIColor.white.cgColor
    }
    
    func CoverEmblem11(){
        self.AchievementsContainer.addSubview(self.cover11)
        self.cover11.centerXAnchor.constraint(equalTo: self.emblem11.centerXAnchor).isActive = true
        self.cover11.centerYAnchor.constraint(equalTo: self.emblem11.centerYAnchor).isActive = true
        self.container11.layer.borderColor = UIColor.white.cgColor
    }
    func CoverEmblem12(){
        
        self.AchievementsContainer.addSubview(self.cover12)
        self.cover12.centerXAnchor.constraint(equalTo: self.emblem12.centerXAnchor).isActive = true
        self.cover12.centerYAnchor.constraint(equalTo: self.emblem12.centerYAnchor).isActive = true
        self.container12.layer.borderColor = UIColor.white.cgColor
    }
    
    func setPosition_UserInfo(){
        UserInfoContainer.centerXAnchor.constraint(equalTo: ScrollableView.centerXAnchor).isActive = true
        UserInfoContainer.topAnchor.constraint(equalTo: ScrollableView.topAnchor).isActive = true
        UserInfoContainer.widthAnchor.constraint(equalTo: ScrollableView.widthAnchor).isActive = true
        UserInfoContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        UserInfoContainer.addSubview(UserName)
        UserInfoContainer.addSubview(profileIcon)
        UserInfoContainer.addSubview(gearIcon)
        
        setPosition_ElementsUserInfo()
        
        gearIcon.rightAnchor.constraint(equalTo: UserInfoContainer.rightAnchor, constant: -19).isActive = true
        gearIcon.centerYAnchor.constraint(equalTo: UserName.centerYAnchor).isActive = true
        gearIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        gearIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileIcon.leftAnchor.constraint(equalTo: UserInfoContainer.leftAnchor, constant: 20).isActive = true
        profileIcon.centerYAnchor.constraint(equalTo: UserName.centerYAnchor).isActive = true
        profileIcon.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileIcon.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
    }
    
    func setPosition_LineBreaker(){
        LineBreaker1.leftAnchor.constraint(equalTo: ScrollableView.leftAnchor).isActive = true
        LineBreaker1.topAnchor.constraint(equalTo: UserInfoContainer.bottomAnchor).isActive = true
        LineBreaker1.rightAnchor.constraint(equalTo: LineBreaker2.leftAnchor).isActive = true
        LineBreaker1.widthAnchor.constraint(equalTo: LineBreaker2.widthAnchor).isActive = true
        LineBreaker1.widthAnchor.constraint(equalTo: LineBreaker3.widthAnchor).isActive = true
        LineBreaker1.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        LineBreaker2.leftAnchor.constraint(equalTo: LineBreaker1.rightAnchor).isActive = true
        LineBreaker2.topAnchor.constraint(equalTo: UserInfoContainer.bottomAnchor).isActive = true
        LineBreaker2.widthAnchor.constraint(equalTo: LineBreaker1.widthAnchor).isActive = true
        LineBreaker2.rightAnchor.constraint(equalTo: LineBreaker3.leftAnchor).isActive = true
        LineBreaker2.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        LineBreaker3.leftAnchor.constraint(equalTo: LineBreaker2.rightAnchor).isActive = true
        LineBreaker3.topAnchor.constraint(equalTo: UserInfoContainer.bottomAnchor).isActive = true
        LineBreaker3.widthAnchor.constraint(equalTo: LineBreaker1.widthAnchor).isActive = true
        LineBreaker3.widthAnchor.constraint(equalTo: LineBreaker2.widthAnchor).isActive = true
        LineBreaker3.rightAnchor.constraint(equalTo: ScrollableView.rightAnchor).isActive = true
        LineBreaker3.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
    }
    
    func setPosition_StatusContainer(){
        
        StatusContainer.centerXAnchor.constraint(equalTo: ScrollableView.centerXAnchor).isActive = true
        StatusContainer.topAnchor.constraint(equalTo: LineBreaker1.bottomAnchor).isActive = true
        StatusContainer.widthAnchor.constraint(equalTo: ScrollableView.widthAnchor).isActive = true
        StatusContainer.heightAnchor.constraint(equalToConstant: 417).isActive = true
        
        StatusContainer.addSubview(DailyStreakLabel)
        StatusContainer.addSubview(DailyStreakEmblem)
        StatusContainer.addSubview(DailystreakNumber)
        StatusContainer.addSubview(TotalSessionLabel)
        StatusContainer.addSubview(TotalSessionEmblem)
        StatusContainer.addSubview(SessionNumber)
        
        setPosition_ElementsStatusContainer()
    }
    
    func setPosition_AchievementsContainer(){
        AchievementsContainer.centerXAnchor.constraint(equalTo: ScrollableView.centerXAnchor).isActive = true
        AchievementsContainer.topAnchor.constraint(equalTo: StatusContainer.bottomAnchor).isActive = true
        AchievementsContainer.widthAnchor.constraint(equalTo: ScrollableView.widthAnchor).isActive = true
        //AchievementsContainer.heightAnchor.constraint(equalToConstant: 488).isActive = true
        AchievementsContainer.bottomAnchor.constraint(equalTo: self.ScrollableView.bottomAnchor).isActive = true
        
        AchievementsContainer.addSubview(AchievementLabel)
        
        AchievementsContainer.addSubview(container1)
        AchievementsContainer.addSubview(container2)
        AchievementsContainer.addSubview(container3)
        AchievementsContainer.addSubview(container4)
        AchievementsContainer.addSubview(container5)
        AchievementsContainer.addSubview(container6)
        AchievementsContainer.addSubview(container7)
        AchievementsContainer.addSubview(container8)
        AchievementsContainer.addSubview(container9)
        AchievementsContainer.addSubview(container10)
        AchievementsContainer.addSubview(container11)
        AchievementsContainer.addSubview(container12)
        
        AchievementsContainer.addSubview(prevDogButton)
        AchievementsContainer.addSubview(nextDogButton)
        
        setPosition_ElementsAchievementsContainer()
    }
    
    func setPosition_ElementsUserInfo(){
        UserName.leftAnchor.constraint(equalTo: ScrollableView.leftAnchor, constant: 92).isActive = true
        UserName.topAnchor.constraint(equalTo: UserInfoContainer.topAnchor, constant: 25).isActive = true
        UserName.heightAnchor.constraint(equalToConstant: 27).isActive = true
        UserName.widthAnchor.constraint(equalToConstant: 200).isActive = true
        //width?
    }
    
    func setPosition_ElementsStatusContainer(){
        DailyStreakLabel.centerXAnchor.constraint(equalTo: StatusContainer.centerXAnchor).isActive = true
        DailyStreakLabel.topAnchor.constraint(equalTo: StatusContainer.topAnchor, constant: 18).isActive = true
        DailyStreakLabel.widthAnchor.constraint(equalToConstant: 177).isActive = true
        DailyStreakLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        DailyStreakEmblem.centerXAnchor.constraint(equalTo: StatusContainer.centerXAnchor).isActive = true
        DailyStreakEmblem.topAnchor.constraint(equalTo: StatusContainer.topAnchor, constant: 54).isActive = true
        DailyStreakEmblem.widthAnchor.constraint(equalToConstant: 205).isActive = true
        DailyStreakEmblem.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        TotalSessionLabel.centerXAnchor.constraint(equalTo: StatusContainer.centerXAnchor).isActive = true
        TotalSessionLabel.topAnchor.constraint(equalTo: StatusContainer.topAnchor, constant: 205).isActive = true
        TotalSessionLabel.widthAnchor.constraint(equalToConstant: 240).isActive = true
        TotalSessionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        TotalSessionEmblem.centerXAnchor.constraint(equalTo: StatusContainer.centerXAnchor).isActive = true
        TotalSessionEmblem.topAnchor.constraint(equalTo: StatusContainer.topAnchor, constant: 240).isActive = true
        TotalSessionEmblem.widthAnchor.constraint(equalToConstant: 120).isActive = true
        TotalSessionEmblem.heightAnchor.constraint(equalToConstant: 139).isActive = true
        
        DailystreakNumber.centerXAnchor.constraint(equalTo: DailyStreakEmblem.centerXAnchor).isActive = true
        DailystreakNumber.topAnchor.constraint(equalTo: DailyStreakEmblem.topAnchor, constant: 18).isActive = true
        DailystreakNumber.widthAnchor.constraint(equalToConstant: 100).isActive = true
        DailystreakNumber.heightAnchor.constraint(equalToConstant: 68).isActive = true
        
        SessionNumber.centerXAnchor.constraint(equalTo: TotalSessionEmblem.centerXAnchor).isActive = true
        SessionNumber.topAnchor.constraint(equalTo: TotalSessionEmblem.topAnchor, constant: 30).isActive = true
        SessionNumber.widthAnchor.constraint(equalToConstant: 64).isActive = true
        SessionNumber.heightAnchor.constraint(equalToConstant: 68).isActive = true
    }
    
    func setPosition_ElementsAchievementsContainer(){
        //AchievementLabel.centerXAnchor.constraint(equalTo: ScrollableView.centerXAnchor).isActive = true
        AchievementLabel.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 18).isActive = true
        AchievementLabel.leftAnchor.constraint(equalTo: AchievementsContainer.leftAnchor, constant: 50).isActive = true
        AchievementLabel.rightAnchor.constraint(equalTo: AchievementsContainer.rightAnchor, constant: -50).isActive = true
        //AchievementLabel.widthAnchor.constraint(equalToConstant: 194).isActive = true
        AchievementLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        container1.centerXAnchor.constraint(equalTo: LineBreaker1.centerXAnchor).isActive = true
        container1.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 75).isActive = true
        container1.widthAnchor.constraint(equalToConstant: 88).isActive = true
        container1.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        container2.centerXAnchor.constraint(equalTo: ScrollableView.centerXAnchor).isActive = true
        container2.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 75).isActive = true
        container2.widthAnchor.constraint(equalToConstant: 88).isActive = true
        container2.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        container3.centerXAnchor.constraint(equalTo: LineBreaker3.centerXAnchor).isActive = true
        container3.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 75).isActive = true
        container3.widthAnchor.constraint(equalToConstant: 88).isActive = true
        container3.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        container4.centerXAnchor.constraint(equalTo: LineBreaker1.centerXAnchor).isActive = true
        container4.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 214).isActive = true
        container4.widthAnchor.constraint(equalToConstant: 88).isActive = true
        container4.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        container5.centerXAnchor.constraint(equalTo: ScrollableView.centerXAnchor).isActive = true
        container5.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 214).isActive = true
        container5.widthAnchor.constraint(equalToConstant: 88).isActive = true
        container5.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        container6.centerXAnchor.constraint(equalTo: LineBreaker3.centerXAnchor).isActive = true
        container6.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 214).isActive = true
        container6.widthAnchor.constraint(equalToConstant: 88).isActive = true
        container6.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        container7.centerXAnchor.constraint(equalTo: LineBreaker1.centerXAnchor).isActive = true
        container7.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 351).isActive = true
        container7.widthAnchor.constraint(equalToConstant: 88).isActive = true
        container7.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        container8.centerXAnchor.constraint(equalTo: ScrollableView.centerXAnchor).isActive = true
        container8.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 351).isActive = true
        container8.widthAnchor.constraint(equalToConstant: 88).isActive = true
        container8.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        container9.centerXAnchor.constraint(equalTo: LineBreaker3.centerXAnchor).isActive = true
        container9.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 351).isActive = true
        container9.widthAnchor.constraint(equalToConstant: 88).isActive = true
        container9.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        container10.centerXAnchor.constraint(equalTo: LineBreaker1.centerXAnchor).isActive = true
        container10.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 488).isActive = true
        container10.widthAnchor.constraint(equalToConstant: 88).isActive = true
        container10.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        container11.centerXAnchor.constraint(equalTo: LineBreaker2.centerXAnchor).isActive = true
        container11.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 488).isActive = true
        container11.widthAnchor.constraint(equalToConstant: 88).isActive = true
        container11.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        container12.centerXAnchor.constraint(equalTo: LineBreaker3.centerXAnchor).isActive = true
        container12.topAnchor.constraint(equalTo: AchievementsContainer.topAnchor, constant: 488).isActive = true
        container12.widthAnchor.constraint(equalToConstant: 88).isActive = true
        container12.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        prevDogButton.rightAnchor.constraint(equalTo: AchievementLabel.leftAnchor, constant: -12).isActive = true
        prevDogButton.centerYAnchor.constraint(equalTo: AchievementLabel.centerYAnchor).isActive = true
        prevDogButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        prevDogButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        nextDogButton.leftAnchor.constraint(equalTo: AchievementLabel.rightAnchor, constant: 12).isActive = true
        nextDogButton.centerYAnchor.constraint(equalTo: AchievementLabel.centerYAnchor).isActive = true
        nextDogButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nextDogButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        prevDogButton.isUserInteractionEnabled = false
        nextDogButton.isUserInteractionEnabled = false
        
        hidePrevButton()
        hideNextButton()
        
        container1.addSubview(emblem1)
        container2.addSubview(emblem2)
        container3.addSubview(emblem3)
        container4.addSubview(emblem4)
        container5.addSubview(emblem5)
        container6.addSubview(emblem6)
        container7.addSubview(emblem7)
        container8.addSubview(emblem8)
        container9.addSubview(emblem9)
        container10.addSubview(emblem10)
        container11.addSubview(emblem11)
        container12.addSubview(emblem12)
        
        
        setPosition_Emblems()
    }
    
    
    func setPosition_Emblems(){
        
        emblem1.centerXAnchor.constraint(equalTo: container1.centerXAnchor).isActive = true
        emblem1.centerYAnchor.constraint(equalTo: container1.centerYAnchor).isActive = true
        
        emblem2.centerXAnchor.constraint(equalTo: container2.centerXAnchor).isActive = true
        emblem2.centerYAnchor.constraint(equalTo: container2.centerYAnchor).isActive = true
        
        emblem3.centerXAnchor.constraint(equalTo: container3.centerXAnchor).isActive = true
        emblem3.centerYAnchor.constraint(equalTo: container3.centerYAnchor).isActive = true
        
        emblem4.centerXAnchor.constraint(equalTo: container4.centerXAnchor).isActive = true
        emblem4.centerYAnchor.constraint(equalTo: container4.centerYAnchor).isActive = true
        
        emblem5.centerXAnchor.constraint(equalTo: container5.centerXAnchor).isActive = true
        emblem5.centerYAnchor.constraint(equalTo: container5.centerYAnchor).isActive = true
        
        emblem6.centerXAnchor.constraint(equalTo: container6.centerXAnchor).isActive = true
        emblem6.centerYAnchor.constraint(equalTo: container6.centerYAnchor).isActive = true
        
        emblem7.centerXAnchor.constraint(equalTo: container7.centerXAnchor).isActive = true
        emblem7.centerYAnchor.constraint(equalTo: container7.centerYAnchor).isActive = true
        
        emblem8.centerXAnchor.constraint(equalTo: container8.centerXAnchor).isActive = true
        emblem8.centerYAnchor.constraint(equalTo: container8.centerYAnchor).isActive = true
        
        emblem9.centerXAnchor.constraint(equalTo: container9.centerXAnchor).isActive = true
        emblem9.centerYAnchor.constraint(equalTo: container9.centerYAnchor).isActive = true
        
        emblem10.centerXAnchor.constraint(equalTo: container10.centerXAnchor).isActive = true
        emblem10.centerYAnchor.constraint(equalTo: container10.centerYAnchor).isActive = true
        
        emblem11.centerXAnchor.constraint(equalTo: container11.centerXAnchor).isActive = true
        emblem11.centerYAnchor.constraint(equalTo: container11.centerYAnchor).isActive = true
        
        emblem12.centerXAnchor.constraint(equalTo: container12.centerXAnchor).isActive = true
        emblem12.centerYAnchor.constraint(equalTo: container12.centerYAnchor).isActive = true
    }
}




