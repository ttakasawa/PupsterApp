//
//  CheckInViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/1/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import SCLAlertView

class CheckInViewController: UIViewController, CheckInControllerHelper, Stylable {
    var upButton = UIButton(type: .custom)
    var bottomButton = UIButton(type: .custom)
    var closeButton = UIButton(type: .custom)
    
    let singleViewHeight = ScreenSize.SCREEN_HEIGHT
    
    var activitiesDone: [ActivityType] = []
    var dogActivity: [DogActivity] = []
    
    var baseScrollView = UIScrollView()
    var baseView = UIView()
    var checkInViews: [UIView] = []
    
    let activitySelecting = ActivitySelectingView()
    let rateReporting = RateSettingView()
    let rewardView = ActivityTrackingRewardingView()
    let redeemView = TrophyRedeemingView()
//    let confirmationView = ActivityTrackingConfirmationView()
    
    var shouldPresentRating: Bool = false
    
    var user: UserData
    var network: TypeNetwork
    
    var ratingAlreadyChanged: Bool!
    
    init(user: UserData, network: TypeNetwork){
        self.user = user
        self.network = network
        super.init(nibName: nil, bundle: nil)
        
        ratingAlreadyChanged = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitySelecting.configure(dog: self.user.dogs![0])
        rateReporting.configure()
        redeemView.configure()
        checkInViews.append(activitySelecting)
        
        self.configure()
        
        self.configureCloseButton(selector: #selector(self.closeView))
        self.configureUpButton(selector: #selector(self.scrollUp))
        self.configureDownButton(selector: #selector(self.scrollDown))
    }
    
    
    func configure(){
        
        baseScrollView.isScrollEnabled = false
        
        self.view.backgroundColor = self.getMainColor()
        
        baseScrollView.translatesAutoresizingMaskIntoConstraints = false
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(baseScrollView)
        baseScrollView.addSubview(baseView)
        
        baseScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        baseScrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        baseScrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        baseScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        //let viewHeight = singleViewHeight * CGFloat(self.checkInViews.count)
        let viewHeight = singleViewHeight * 4
        
        baseView.topAnchor.constraint(equalTo: self.baseScrollView.topAnchor).isActive = true
        baseView.leftAnchor.constraint(equalTo: self.baseScrollView.leftAnchor).isActive = true
        baseView.rightAnchor.constraint(equalTo: self.baseScrollView.rightAnchor).isActive = true
        baseView.bottomAnchor.constraint(equalTo: self.baseScrollView.bottomAnchor).isActive = true
        
        baseView.widthAnchor.constraint(equalTo: baseScrollView.widthAnchor).isActive = true
        baseView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        
        //baseScrollView.contentSize.height = viewHeight
        
        baseView.addSubview(self.checkInViews[0])
        
        self.checkInViews[0].topAnchor.constraint(equalTo: baseView.topAnchor).isActive = true
        self.checkInViews[0].leftAnchor.constraint(equalTo: baseView.leftAnchor).isActive = true
        self.checkInViews[0].rightAnchor.constraint(equalTo: baseView.rightAnchor).isActive = true
        self.checkInViews[0].heightAnchor.constraint(equalToConstant: singleViewHeight).isActive = true
        
        
    }
    
    func getCurrentPageNumber() -> CGFloat {
        let currentOffset = self.baseScrollView.contentOffset.y
        let currentPage = currentOffset / singleViewHeight
        return currentPage
    }
    
    func appendViews(view: UIView){
        let lastIndex = self.checkInViews.count - 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.checkInViews.append(view)
        
        baseView.addSubview(view)
        
        view.topAnchor.constraint(equalTo: self.checkInViews[lastIndex].bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: baseView.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: baseView.rightAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: singleViewHeight).isActive = true
        
        //baseView.bottom
    }
    
    @objc func scrollUp(sender: UIButton){
        let currentPage = getCurrentPageNumber()
        if sender.isSelected {
            let newYPosition = singleViewHeight * (currentPage - 1)
            UIView.animate(withDuration: 1.0) {
                self.baseScrollView.setContentOffset(CGPoint(x: 0, y: newYPosition), animated: false)
            }
        }
        
        if (Int(currentPage) == 1)  {
            self.upButtonActivation(isActivated: false)
            self.downButtonActivation(isActivated: true)
        }
        
    }
    
    @objc func scrollDown(sender: UIButton){
        sender.isUserInteractionEnabled = false
        let currentPage = getCurrentPageNumber()
        
        if currentPage == 1 {
            self.dogActivity.append(DogActivity(dogId: self.user.dogs![0].id, rating: 0.5, globalLessonId: nil))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                self.completeCheckIn(){
                    self.appendViews(view: self.rewardView)
                    self.goDown()
                    self.rewardStartAnimation()
                    sender.isUserInteractionEnabled = true
                }
            }
        }
        
        
        if sender.isSelected {
            if currentPage != 1 {
                self.goDown()
                sender.isUserInteractionEnabled = true
            }
        }
    }
    
    func goDown(){
        let currentPage = getCurrentPageNumber()
        
        if Int(currentPage) < self.checkInViews.count - 1 {
            let newYPosition = singleViewHeight * (currentPage + 1)
            UIView.animate(withDuration: 1.0) {
                self.baseScrollView.setContentOffset(CGPoint(x: 0, y: newYPosition), animated: false)
            }
        }
        
        if currentPage == 0 {
            self.upButtonActivation(isActivated: true)
            self.downButtonActivation(isActivated: true)
        }
        
    }
    
    func upButtonActivation(isActivated: Bool) {
        if isActivated {
            self.upButton.setImage(#imageLiteral(resourceName: "checkInButtonScrollUp"), for: .normal)
            self.upButton.isSelected = true
            self.upButton.isUserInteractionEnabled = true
        }else{
            self.upButton.setImage(#imageLiteral(resourceName: "checkInButtonScrollUpDisabled"), for: .normal)
            self.upButton.isSelected = false
            self.upButton.isUserInteractionEnabled = false
        }
    }
    
    
    func downButtonActivation(isActivated: Bool) {
        if isActivated {
            self.bottomButton.setImage(#imageLiteral(resourceName: "checkInButtonScrollDown"), for: .normal)
            self.bottomButton.isSelected = true
            self.bottomButton.isUserInteractionEnabled = true
        }else{
            self.bottomButton.setImage(#imageLiteral(resourceName: "checkInButtonScrollDownDisabled"), for: .normal)
            self.bottomButton.isSelected = false
            self.bottomButton.isUserInteractionEnabled = false
        }
    }
    
    
    
    func rewardStartAnimation(){
        self.rewardView.startAnimation()
        self.upButton.removeFromSuperview()
        self.bottomButton.removeFromSuperview()
    }
    
    @objc func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func noActivitySelectionAlert(){
        SCLAlertView().showWarning("Whoops..", subTitle: "Please select at least one activity")
    }
    

    @objc func completeActivitySelection(sender: UIButton){
        
        if self.activitiesDone.count == 0 {
            noActivitySelectionAlert()
        }else{
            sender.isUserInteractionEnabled = false
            sender.alpha = 0
            shouldPresentRating = false
            for i in 0..<self.activitiesDone.count {
                if(self.activitiesDone[i] == .train){
                    shouldPresentRating = true
                    rateReporting.switchRateType(type: .train)
                    //TODO: here add the view rating view
                    self.appendViews(view: self.rateReporting)
                    self.goDown()
                    
                    self.upButtonActivation(isActivated: true)
                    self.downButtonActivation(isActivated: true)
                    return
                }else if(self.activitiesDone[i] == .walk){
                    shouldPresentRating = true
                    rateReporting.switchRateType(type: .walk)
                    //TODO: here add the view rating view
                    self.appendViews(view: self.rateReporting)
                    self.goDown()
                    self.upButtonActivation(isActivated: true)
                    self.downButtonActivation(isActivated: true)
                    return
                }
            }
            if(shouldPresentRating == false){
                //TODO: here add trophy
                //Make sure to have the appending of dog activity done
                self.dogActivity.append(DogActivity(dogId: self.user.dogs![0].id, rating: nil, globalLessonId: nil))
                self.completeCheckIn(){
                    self.appendViews(view: self.rewardView)
                    self.goDown()
                    self.rewardStartAnimation()
                }
                return
            }
        }
    }
    
    
    @objc func ratingChangedFinished(slider: UISlider, event: UIEvent){
        if(ratingAlreadyChanged == false){
            if let touchEvent = event.allTouches?.first {
                switch touchEvent.phase {
                case .ended:
                    self.ratingAlreadyChanged = true
                    self.dogActivity.append(DogActivity(dogId: self.user.dogs![0].id, rating: Double(slider.value), globalLessonId: nil))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                        self.completeCheckIn(){
                            self.appendViews(view: self.rewardView)
                            self.goDown()
                            self.rewardStartAnimation()
                        }
                    }
                default:
                    break
                }
            }
        }
    }
    
    
    func completeCheckIn(completion: ()-> Void){
        let activities = self.network.createActivity(activitiesDone: self.activitiesDone, dogActivity: self.dogActivity)
        self.network.createCheckIn(user: self.user, activities: activities)
        
        self.calculateTrophyTransaction(activityCompleted: activities, type: .activity) { trophyEarned in
            self.rewardView.configure(data: self.user)
            self.rewardView.updateTrophyAdded(numberOfTrophies: trophyEarned)
            //self.goDown()
            
            completion()
        }
    }
    
    func calculateTrophyTransaction(activityCompleted: [Activity], type: TrophyType, completion: (_ trophyEarned: Int) -> Void){
        var trophyEarned: Int = 0
        var counter: Int = 0
        
        for i in 0..<activityCompleted.count{
            let activity = activityCompleted[i]
            if activity.type == .water {
                trophyEarned = trophyEarned + 1
            }else if activity.type == .feed {
                trophyEarned = trophyEarned + 1
            }else{
                counter = counter + 1
            }
        }
        
        if counter > 2 {
            trophyEarned = trophyEarned + 8
        }else if counter == 2 {
            trophyEarned = trophyEarned + 7
        }else if counter == 1 {
            trophyEarned = trophyEarned + 4
        }
        
        let transaction = self.network.createTrophyTransaction(quantity: trophyEarned, type: .activity, user: self.user)
        
        updateTrophyTransaction(transaction: transaction){ success in
            //nothing in particular
        }
        
        completion (trophyEarned)
    }
    
    func updateTrophyTransaction(transaction: Trophy, completion: @escaping (_ success: Bool) -> Void){
        self.network.storeTrophyTransaction(user: self.user, trophy: transaction) { success in
            completion(success)
        }
    }
    
    
    
    
    
    func removeActivityType(type: ActivityType) {
        var count = 0
        for _ in 0..<self.activitiesDone.count {
            if self.activitiesDone[count] == type {
                activitiesDone.remove(at: count)
                count = count - 1
            }
            count = count + 1
        }
    }
    
    
    
    func redeemingPopUp(title: String, subTitle: String){
        //thank you here
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false // hide default button
        )
        let alert = SCLAlertView(appearance: appearance) // create alert with appearance
        alert.addButton("Done", action: { // create button on alert
            self.closeView()
        })
        alert.showSuccess(title, subTitle: subTitle)
    }
    
    
}


//MARK: @objc Actions
@objc
extension CheckInViewController {
    func donationPressed(){
        let transaction = self.network.createTrophyTransaction(quantity: -125, type: .donation, user: self.user)
        updateTrophyTransaction(transaction: transaction){ success in
            self.redeemingPopUp(title: "Thank you!", subTitle: "You’ve just provided a meal to a pup waiting for adoption through our adoption partner program. The more you track your activities, the more dogs you’ll feed!")
        }
        
    }
    
    func discountPressed(){
        let transaction = self.network.createTrophyTransaction(quantity: -125, type: .discount, user: self.user)
        updateTrophyTransaction(transaction: transaction){ success in
            self.redeemingPopUp(title: "Thank you!", subTitle: "Use promo code 'Pupster9403' to earn 10% off your next purchase through Pupster, and message Gwen with any questions.")
        }
    }
    
    func showRedeemingView(){
        if let baseVC = self.pupserBase {
            baseVC.updateDashBoards()
        }
        
        if self.user.restScoreInt == 0{
            //add redeem view
            self.appendViews(view: self.redeemView)
            self.goDown()
        }else{
            self.network.logFirebaseEvents(logEventsName: "CheckCompleted", parameterd: ["name" : "CheckCompleted"])
            self.closeView()
        }
    }
}


//MARK: Used for activity selection purposes
@objc
extension CheckInViewController {
    
    func walkActivityPressed(sender: CheckInActivityButton){
        let activity = ActivityType.walk
        sender.isSelected ? activitiesDone.append(activity) : removeActivityType(type: activity)
    }
    func playActivityPressed(sender: CheckInActivityButton){
        let activity = ActivityType.play
        sender.isSelected ? activitiesDone.append(activity) : removeActivityType(type: activity)
    }
    func trainActivityPressed(sender: CheckInActivityButton){
        let activity = ActivityType.train
        sender.isSelected ? activitiesDone.append(activity) : removeActivityType(type: activity)
    }
    
    func parkActivityPressed(sender: CheckInActivityButton){
        let activity = ActivityType.park
        sender.isSelected ? activitiesDone.append(activity) : removeActivityType(type: activity)
    }
    func feedActivityPressed(sender: CheckInActivityButton){
        let activity = ActivityType.feed
        sender.isSelected ? activitiesDone.append(activity) : removeActivityType(type: activity)
    }
    func waterActivityPressed(sender: CheckInActivityButton){
        let activity = ActivityType.water
        sender.isSelected ? activitiesDone.append(activity) : removeActivityType(type: activity)
    }
    
    
    func cuddleActivityPressed(sender: CheckInActivityButton){
        let activity = ActivityType.cuddle
        sender.isSelected ? activitiesDone.append(activity) : removeActivityType(type: activity)
    }
    func adventureActivityPressed(sender: CheckInActivityButton){
        let activity = ActivityType.adventure
        sender.isSelected ? activitiesDone.append(activity) : removeActivityType(type: activity)
    }
    func socializeActivityPressed(sender: CheckInActivityButton){
        let activity = ActivityType.socialize
        sender.isSelected ? activitiesDone.append(activity) : removeActivityType(type: activity)
    }
}








