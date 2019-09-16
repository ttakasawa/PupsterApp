//
//  IntroViewController.swift
//  moxie
//
//  Created by ZacharyH on 1/27/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import Firebase

class IntroViewController: UIViewController {
    
    //@IBOutlet weak var dogImage: DogProgression!
    @IBInspectable var index: NSNumber = 0
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var skipIntro: UILabel!
    
    @IBOutlet weak var skipIntro2: UILabel!
    
    @IBOutlet weak var skipIntro3: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

//        if let dogImage = self.dogImage {
//            dogImage.index = self.index.int8Value
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (skipIntro != nil){
            skipIntro.isUserInteractionEnabled = true
        }
        if (skipIntro2 != nil){
            skipIntro2.isUserInteractionEnabled = true
        }
        if (skipIntro3 != nil){
            skipIntro3.isUserInteractionEnabled = true
        }
        let skip: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IntroViewController.skipping(recognizer:)))
        
        skip.numberOfTapsRequired = 1
        
        if (skipIntro != nil){
            skipIntro.addGestureRecognizer(skip)
        }
        if (skipIntro2 != nil){
            skipIntro2.addGestureRecognizer(skip)
        }
        if (skipIntro3 != nil){
            skipIntro3.addGestureRecognizer(skip)
        }
        
        
        if index == -1 {
//            Auth.auth().addStateDidChangeListener({ [weak self] (_, user) in
//                if user != nil {
//
//                    print("user authenticated background")
//                    UserManager.shared.setUserLogInStatus(){ last in
//                        print("user updated in introviewcontroller")
//                        if (last == 0){
//                            print("first time user")
//                            print("from intro view controller")
//
//                        }else{
//                            let sb = UIStoryboard(name: "Main", bundle: nil)
//                            let vc = sb.instantiateViewController(withIdentifier: "tabBar")
//                            if let window = UIApplication.shared.keyWindow {
//                                window.rootViewController = vc
//                            }
//                        }
//                    }
//
//                } else {
//                    guard let strongSelf = self else {
//                        return
//                    }
//                    strongSelf.performSegue(withIdentifier: "Intro", sender: self)
//                }
//            })
        } else if index == 0 {
        }
    }
    
    /*override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("intro perform esgue" )
        /*if let _ = UserManager.shared.currentUser {
            print("directly to path")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "tabBar")
            if let window = UIApplication.shared.keyWindow {
                window.rootViewController = vc
            }
            return false
        }*/
        /*if let _ = FBSDKAccessToken.current(), identifier == "GetStarted" {
            print("through facebook")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "tabBar")
            if let window = UIApplication.shared.keyWindow {
                window.rootViewController = vc
            }
            return false
        }*/
        return true
    }*/
    
    @objc func skipping(recognizer: UIGestureRecognizer){
        let sb = UIStoryboard(name: "Intro", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "skippedDest")
        present(vc, animated: false, completion: nil)
    }

}
