//
//  SetupNotificationsVC.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/9/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import UserNotifications

class SetupNotificationsVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var enableNotificationsButton: PLFButton!
    @IBOutlet weak var notNowButton: UIButton!
    
    let center = UNUserNotificationCenter.current()
    
    var isNotificationOn: Bool = true
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableNotificationsButton.set(enabled: true)
        isNotificationOn = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        center.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .authorized {
                self.setRemoteNotification()
                self.finishLoginFlow()
            }
        })
    }
    
    
    @IBAction func enableTapped(_ sender: Any) {
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            if granted {
                self.setRemoteNotification()
                self.finishLoginFlow()
            } else {
                self.showAlert(title: "Error", message: "Notifications services aren't unabled for this app. You can always change this in the settings.", completion: {
                    self.finishLoginFlow()
                })
            }
        }
    }
    
    @IBAction func notNowTapped(_ sender: Any) {
        isNotificationOn = false
        self.finishLoginFlow()
    }
    
}


extension SetupNotificationsVC: LoadingHandling, DashBoardPresentable {
    func recovery() { }
    
    /**
     Opens whatever you want to be after login flow
     */
    func finishLoginFlow() {
        guard let currentUser = PUser.current else { return }
//
//        // -- Here we have our user
//        print(currentUser.fullName)
//        print(currentUser.serialize())
//
        guard let currentDog = PDog.current else { return }
//
//        // -- Here we have our dog
//
//        print(currentDog.name)
//        print(currentDog.serialize())
        
        self.completeSignIn(currentUser: currentUser, currentDog: currentDog)
    }
    
    
    /**
     Updates UserData to Firebase Real time DB
     */
    func completeSignIn(currentUser: PUser, currentDog: PDog){
        
        DispatchQueue.main.async {
            self.showLoading()
        }
        
        
        let dogBirthDate = Date().addingTimeInterval(-currentDog.age)
        let ownershipStart = Date().addingTimeInterval(-currentDog.ownershipDuration)
        
        var dogGender: Gender = .male
        if currentDog.gender == .girl { dogGender = .female }
        
        let newUser = UserData(id: currentUser.uid, email: currentUser.email, firstName: currentUser.firstName, lastName: currentUser.lastName, dogs: Dog(id: currentDog.id, name: currentDog.name, gender: dogGender, birthTime: dogBirthDate, ownershipStart: ownershipStart, breed: currentDog.breed, profileImageUrl: nil))
        
        //This is for default notification on
//        if isNotificationOn {
//            let notificationDefaultStatus = UserNotificationStatus(notificationTime: 19, isNotificationOn: true, notificationDates: [.Sun, .Mon, .Tue, .Wed, .Thu, .Fri, .Sat])
//            newUser.notificationStatus = notificationDefaultStatus
//            Global.network.changeNotificationTime(status: notificationDefaultStatus)
//
//        }
        
        
        let defaultProgramForPupster2 = Program(id: "program", name: "Pupster Program", subPrograms: [], subProgramIds: ["basics", "adventures", "tricks"])
        
        Global.network.fetchFirebase(endpoint: LessonEndpoints.getSubPrograms, completion: { (subPrograms: [SubProgram]?, error: Error?) in
            
            guard let subPrograms = subPrograms else {
                print("subProgram query fail")
                return
            }
            
            var userSubProgram: [SubProgram] = []
            for i in 0..<subPrograms.count {
                for j in 0..<defaultProgramForPupster2.subProgramIds.count {
                    if subPrograms[i].id == defaultProgramForPupster2.subProgramIds[j]{
                        userSubProgram.append(subPrograms[i])
                    }
                }
            }
            
            defaultProgramForPupster2.subPrograms = userSubProgram
            var defaultUserProgramArr:[Program] = []
            defaultUserProgramArr.append(defaultProgramForPupster2)
            
            newUser.programs = defaultUserProgramArr
            
            Global.network.updateUserInfo(user: newUser, completion: { (user, error) in
                
                Global.network.user = newUser
                
                DispatchQueue.main.async {
                    self.hideLoading()
                    self.presentDashBoard()
                }
                
            })
        })
    }
    
    func setRemoteNotification(){
        DispatchQueue.main.async(execute: {
            UIApplication.shared.registerForRemoteNotifications()
        })
    }
}




protocol DashBoardPresentable {
    func presentDashBoard()
}

extension DashBoardPresentable where Self: UIViewController {
    func presentDashBoard() {
        //TODO: fix this. This is only temporary fix
        let whiteView = UIView()
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.backgroundColor = .white
        self.view.addSubview(whiteView)
        whiteView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        whiteView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        whiteView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        whiteView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showDashBoard()
        
    }
}



