//
//  upgradeToVersion2.swift
//  moxie
//
//  Created by Tomoki Takasawa on 4/18/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
//import Stripe

extension UserManager{
    
    func getBasicDogInfo(uRef: DatabaseReference, completion: @escaping (_ basicInfo: String, String, String) -> Void){
        uRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let dogName = value?[Data2.Fields.dog.dogName] as? String
            let dogSize = value?[Data2.Fields.dog.dogSize] as? String
            let dogType = value?[Data2.Fields.dog.dogType] as? String
            
            completion(dogName ?? "Pupster", dogSize ?? "Medium", dogType ?? "Puppy")
        })
    }
    
    func getLessonInfoForUpgrade(uRef: DatabaseReference, completion: @escaping (_ lessonInfo: Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool) -> Void){
        let lRef = uRef.child(Data2.parentNodes.Lesson)
        lRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let Trainer = value?[Data2.Fields.dog.Lesson.trainer] as? Bool
            let Intro = value?[Data2.Fields.dog.Lesson.intro] as? Bool
            let Sit = value?[Data2.Fields.dog.Lesson.sit] as? Bool
            let Come = value?[Data2.Fields.dog.Lesson.come] as? Bool
            let Lay = value?[Data2.Fields.dog.Lesson.lay] as? Bool
            let Leash = value?[Data2.Fields.dog.Lesson.leash] as? Bool
            let Crate = value?[Data2.Fields.dog.Lesson.crate] as? Bool
            
            let Trick = value?[Data2.Fields.dog.Lesson.trick] as? Bool
            let Touch = value?[Data2.Fields.dog.Lesson.touch] as? Bool
            let Shake = value?[Data2.Fields.dog.Lesson.shake] as? Bool
            let Jump = value?[Data2.Fields.dog.Lesson.jump] as? Bool
            let Footsies = value?[Data2.Fields.dog.Lesson.footsies] as? Bool
            let Circle = value?[Data2.Fields.dog.Lesson.circle] as? Bool
            
            let Final = value?[Data2.Fields.dog.Lesson.final] as? Bool
            
            completion(Trainer ?? false, Intro ?? false, Sit ?? false, Come ?? false, Lay ?? false, Leash ?? false, Crate ?? false, Trick ?? false, Touch ?? false, Shake ?? false, Jump ?? false, Footsies ?? false, Circle ?? false, Final ?? false)
        })
        
    }
    
    func getCertStatusForUpgrade(uRef: DatabaseReference, completion: @escaping (_ certInfo: Bool, Bool, Bool, Bool, Bool, Bool) -> Void){
        //sitStatus, layStatus, stayStatus, comeStatus, jumpStatus, footsiesStatus
        let certRef = uRef.child(Data2.parentNodes.certStatus)
        certRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let sitStatus = value?[Data2.Fields.dog.Lesson.trainer] as? Bool
            let layStatus = value?[Data2.Fields.dog.Lesson.intro] as? Bool
            let stayStatus = value?[Data2.Fields.dog.Lesson.sit] as? Bool
            let comeStatus = value?[Data2.Fields.dog.Lesson.come] as? Bool
            let jumpStatus = value?[Data2.Fields.dog.Lesson.lay] as? Bool
            let footsiesStatus = value?[Data2.Fields.dog.Lesson.leash] as? Bool
            
            completion(sitStatus ?? false, layStatus ?? false, stayStatus ?? false, comeStatus ?? false, jumpStatus ?? false, footsiesStatus ?? false)
        })
    }
    
    func getProgressInfoForUpgrade(uRef: DatabaseReference, completion: @escaping (_ progressInfo: Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool) -> Void){
        let progressRef = uRef.child(Data2.parentNodes.InProgress)
        progressRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let Trainer = value?[Data2.Fields.dog.InProgress.trainer] as? Bool
            let Intro = value?[Data2.Fields.dog.InProgress.intro] as? Bool
            let Sit = value?[Data2.Fields.dog.InProgress.sit] as? Bool
            let Come = value?[Data2.Fields.dog.InProgress.come] as? Bool
            let Lay = value?[Data2.Fields.dog.InProgress.lay] as? Bool
            let Leash = value?[Data2.Fields.dog.InProgress.leash] as? Bool
            let Crate = value?[Data2.Fields.dog.InProgress.crate] as? Bool
            
            let Trick = value?[Data2.Fields.dog.InProgress.trick] as? Bool
            let Touch = value?[Data2.Fields.dog.InProgress.touch] as? Bool
            let Shake = value?[Data2.Fields.dog.InProgress.shake] as? Bool
            let Jump = value?[Data2.Fields.dog.InProgress.jump] as? Bool
            let Footsies = value?[Data2.Fields.dog.InProgress.footsies] as? Bool
            let Circle = value?[Data2.Fields.dog.InProgress.circle] as? Bool
            
            let Final = value?[Data2.Fields.dog.InProgress.final] as? Bool
            
            completion(Trainer ?? false, Intro ?? false, Sit ?? false, Come ?? false, Lay ?? false, Leash ?? false, Crate ?? false, Trick ?? false, Touch ?? false, Shake ?? false, Jump ?? false, Footsies ?? false, Circle ?? false, Final ?? false)
        })
    }
    //func getMoreData(completion: () -> Void){
    func versionUpdate1to2(completion: () -> Void){
        //append dog name, dog type, dog size, lesson, in progress, certificates onto new dog node
        //update version number
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        if let userID = currentUser?.uid {
            let UserReference = ref.child("users").child(userID)
            
            UserReference.updateChildValues([Data2.Fields.firstDog: Data2.parentNodes.dog1])
            UserReference.updateChildValues([Data2.Fields.dogNumber: 1])
            UserReference.updateChildValues([Data2.Fields.existingDogNumber: 1])
            UserReference.updateChildValues([Data2.Fields.currentDog: Data2.parentNodes.dog1])
            UserReference.updateChildValues([Data2.Fields.versionNumber: 2])
            
            
            let dogRef = UserReference.child(Data2.parentNodes.dog1)
            self.getBasicDogInfo(uRef: UserReference){ dogName, dogSize, dogType in
                
                dogRef.updateChildValues([Data2.Fields.dog.dogName: dogName])
                dogRef.updateChildValues([Data2.Fields.dog.dogSize: dogSize])
                dogRef.updateChildValues([Data2.Fields.dog.dogType: dogType])
                dogRef.updateChildValues([Data2.Fields.dog.isDeleted: false])
                dogRef.updateChildValues([Data2.Fields.dog.next: "none"])
                dogRef.updateChildValues([Data2.Fields.dog.prev: "none"])
                dogRef.updateChildValues([Data2.Fields.dog.index: Data2.parentNodes.dog1])
            }
            
            let dogLessonRef = dogRef.child(Data2.parentNodes.Lesson)
            self.getLessonInfoForUpgrade(uRef: UserReference){ trainer, intro, sit, come, lay, leash, crate, trick, touch, shake, jump, footsies, circle, final in
                
                
                let lessonValues = [Data2.Fields.dog.Lesson.trainer: trainer, Data2.Fields.dog.Lesson.intro: intro, Data2.Fields.dog.Lesson.sit: sit, Data2.Fields.dog.Lesson.come: come, Data2.Fields.dog.Lesson.lay: lay, Data2.Fields.dog.Lesson.leash: leash, Data2.Fields.dog.Lesson.crate: crate, Data2.Fields.dog.Lesson.trick: trick, Data2.Fields.dog.Lesson.touch: touch, Data2.Fields.dog.Lesson.shake: shake, Data2.Fields.dog.Lesson.jump: jump, Data2.Fields.dog.Lesson.footsies: footsies, Data2.Fields.dog.Lesson.circle: circle, Data2.Fields.dog.Lesson.final: final]
                
                dogLessonRef.updateChildValues(lessonValues)
                
                //dogLessonRef.updateChildValues([Data2.Fields.dog.dogName: dogName])
            }
            
            let dogcertRef = dogRef.child(Data2.parentNodes.certStatus)
            self.getCertStatusForUpgrade(uRef: UserReference){ sitStatus, layStatus, stayStatus, comeStatus, jumpStatus, footsiesStatus in
                
                let certValue = [Data2.Fields.dog.CertificationStatus.sit: sitStatus, Data2.Fields.dog.CertificationStatus.lay: layStatus, Data2.Fields.dog.CertificationStatus.stay: stayStatus, Data2.Fields.dog.CertificationStatus.come: comeStatus, Data2.Fields.dog.CertificationStatus.jump: jumpStatus, Data2.Fields.dog.CertificationStatus.footsies: footsiesStatus]
                
                dogcertRef.updateChildValues(certValue)
                
            }
            
            let progressRef = dogRef.child(Data2.parentNodes.InProgress)
            self.getProgressInfoForUpgrade(uRef: UserReference){ trainer, intro, sit, come, lay, leash, crate, trick, touch, shake, jump, footsies, circle, final in
                
                let lessonValues = [Data2.Fields.dog.InProgress.trainer: trainer, Data2.Fields.dog.InProgress.intro: intro, Data2.Fields.dog.InProgress.sit: sit, Data2.Fields.dog.InProgress.come: come, Data2.Fields.dog.InProgress.lay: lay, Data2.Fields.dog.InProgress.leash: leash, Data2.Fields.dog.InProgress.crate: crate, Data2.Fields.dog.InProgress.trick: trick, Data2.Fields.dog.InProgress.touch: touch, Data2.Fields.dog.InProgress.shake: shake, Data2.Fields.dog.InProgress.jump: jump, Data2.Fields.dog.InProgress.footsies: footsies, Data2.Fields.dog.InProgress.circle: circle, Data2.Fields.dog.InProgress.final: final]
                
                progressRef.updateChildValues(lessonValues)
                
                
            }
        }
        
        completion()
        
    }
    
    func versionUpdate0to2(){
        print("user in the version 0")
    }
    
    
}
