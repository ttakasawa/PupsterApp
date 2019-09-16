//
//  NewDashboardViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import BubbleTransition
import SCLAlertView
import FirebaseInstanceID
import UserNotifications

class NewDashboardViewController: UIViewController, UIViewControllerTransitioningDelegate, ImageProtocol, RootLevelViewControllerHelper {
    
    var object: DashboardType!
    var builder: NewDashBoardBuildable!
    var network: TypeNetwork
    var user: UserData?
    
    var recommendedArticle: Article?
    var globalLessons: [GlobalLesson]?
    
    let scrollView = UIScrollView()
    let baseView = UIView()
    
    var topTile: DashBoardCell?
    var middleTile: DashBoardCell?
    var bottomTile: DashBoardCell?
    var footerTile: DashBoardCell?
    
    let transition = BubbleTransition()
    var imagePicker = UIImagePickerController()
    
    var userActivityPercentile: Int = 0
    
    let center = UNUserNotificationCenter.current()
    
    init(network: TypeNetwork, dashboardBulder: NewDashBoardBuildable, object: DashboardType) {
        self.object = object
        self.builder = dashboardBulder
        self.network = network
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        self.topTile = builder.createTopView()
        self.middleTile = builder.createMiddleView()
        self.bottomTile = builder.createBottomView()
        self.footerTile = builder.createFooterView()
        
        self.configure()
        self.constrain()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationItem()
        
        self.updateView()
        //track, subscribe, chat
        // program, chat
    }
    
    
    func updateView(){
        
        if let user = self.network.user {
            
            self.network.checkMessage(user: user){ isUnread in
                self.changeMessageIcon(isUnread: isUnread)
            }
            
            if let userStatsTile = self.topTile as? UserProfileCell {
                userStatsTile.updateProfile(data: user)
            }
            
            if let subscriptionTile = self.bottomTile as? UpgradeCell {
                subscriptionTile.updateView(data: user)
            }
            
            if self.object.dashboardKind == .activity {
                self.updateLessonView(program: user.programs![0])
            }
            
        }
    }
    
    
    func setNavigationItem(){
        self.pupserBase?.navigationController?.navigationBar.isHidden = true
        
        if (self.object.dashboardKind == .activity){
            navigationItem.title = "Activities"
        }else{
            navigationItem.title = "Tracking"
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let chatButton: UIBarButtonItem = {
            let b = UIBarButtonItem()
            b.image = #imageLiteral(resourceName: "chatIcon").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            b.style = .plain
            b.target = self
            b.action = #selector(chatPressed)
            b.tintColor = UIColor(red:0.09, green:0.75, blue:0.93, alpha:1)
            return b
        }()
        
        self.navigationItem.rightBarButtonItem = chatButton
    }
    
   
    
    
    
    func configure(){
        //topTile
        self.showLoading()
        self.network.queryUser { (user, error) in
            
            
            guard let user = user else { return }
            guard let program = user.programs?[0] else { return }
            
            self.network.user = user//user    moxie.UserData?    0x00006000019e9600
            self.user = self.network.user
            
            self.network.getRecentMessages()
            
            if let isUnread = self.user?.isUnreadMessage {
                self.changeMessageIcon(isUnread: isUnread)
            }
            
            if let profileUrl = self.user?.userProfileImageUrl {
                self.downloadImage(stringUrl: profileUrl, completion: { (image) in
                    Global.network.userProfileImage = image
                })
            }
            
            let currentLessonId = program.currentLessonId
            let secondLessonId = program.nextLessonId
            
            var recommendedArticleIdArray = program.getSubProgramArticleIds(lessonId: currentLessonId)
            let copiedArticleArray = recommendedArticleIdArray
            
            var index: Int = 0
            for _ in 0..<recommendedArticleIdArray.count {
                if let readArticles = user.readArticleIds {
                    for j in 0..<readArticles.count {
                        if recommendedArticleIdArray[index] == readArticles[j]{
                            recommendedArticleIdArray.remove(at: index)
                            index = index - 1
                            break
                        }
                    }
                }
                index = index + 1
            }
            if recommendedArticleIdArray.count == 0 {
                recommendedArticleIdArray = copiedArticleArray
            }
            
            let randomIndex = Int(arc4random_uniform(UInt32(recommendedArticleIdArray.count)))
            
            var todayArticle = ""
            if recommendedArticleIdArray.count == 0 {
                todayArticle = "Car-Safety-for-Your-Dog"
            }else{
                if recommendedArticleIdArray[randomIndex] == "" {
                    recommendedArticleIdArray[randomIndex] = "Car-Safety-for-Your-Dog"
                }
                
                todayArticle = recommendedArticleIdArray[randomIndex]
            }
            
            
            if self.object.dashboardKind == .activity {
                
                self.network.getLessonContent(lessonId: currentLessonId, completion: { (lesson) in
                    self.globalLessons?.append(lesson)
                    let programInterface = ProgramInterface(program: program, lesson: lesson)
                    
                    self.builder.configureTopView(data: programInterface)
                })
                
                
                self.network.getLessonContent(lessonId: secondLessonId, completion: { (lesson) in
                    self.globalLessons?.append(lesson)
                    let programInterface = ProgramInterface(program: program, lesson: lesson)
                    self.builder.configureMiddleView(data: programInterface)
                    if (program.completedLessons == 2) && (user.subscription == nil) {
                        self.setUpPayWall()
                    }
                })
                
                
                self.network.getArticleContent(articleId: todayArticle, completion: { (content) in
                    self.recommendedArticle = content
                    self.builder.configureBottomView(data: content)
                })
                
                self.builder.configureFooterView(data: user)
                
                self.hideLoading()
                
                if (self.user?.sessions != nil) {
                    //not first time
                }else{
                    InstanceID.instanceID().instanceID(handler: { (result, error) in
                        if error != nil {
                            print("error")
                        }else if let result = result {
                            if let user = self.user {
                                self.network.updateRegistrationToken(id: user.id, token: result.token)
                            }
                        }
                    })
                }
                
                self.repairUserDefaults()
                
            }else{
                
                self.network.queryRankingPercentile(completion: { (percentileArr) in
                    
                    Global.network.perentileScoreArray = percentileArr
                    self.user?.percentMostActive = Global.network.calculatePercentile(percentileArr: percentileArr, user: self.user!)
                    
                    self.builder.configureTopView(data: user)
                    self.builder.configureMiddleView(data: user)
                    self.builder.configureBottomView(data: user)
                    self.builder.configureFooterView(data: user)
                    
                    self.updateView()
                    self.hideLoading()
                })
                
            }
            
        }
    }
    
    var perentileScoreArray: [Int]?
    func calculatePercentile(percentileArr: [Int]){
        var abovePercentileIndex: Int = 9
        
        if let weeklyEarning = self.user?.weeklyEarnedTrophyQuantity {
            self.perentileScoreArray = percentileArr
            for i in 0..<percentileArr.count {
                if weeklyEarning < percentileArr[i] {
                    
                    abovePercentileIndex = i
                    break
                }else{
                    
                }
            }
            
            var abovePercentile: Int = 0
            var belowPercentile: Int = 0
            
            var percentile: Int = 0
            
            if abovePercentileIndex == 9 {
                percentile = 90
                
            }else if abovePercentileIndex > 0 {
                abovePercentile = percentileArr[abovePercentileIndex]
                belowPercentile = percentileArr[abovePercentileIndex - 1]
                let lastDigit = Int((Double(weeklyEarning - belowPercentile) / Double(abovePercentile - belowPercentile)) * 10)
                percentile = (abovePercentileIndex - 1) * 10 + lastDigit
                
            }else{
                abovePercentile = percentileArr[abovePercentileIndex]
                belowPercentile = 0
                let lastDigit = Int((Double(weeklyEarning - belowPercentile) / Double(abovePercentile - belowPercentile)) * 10)
                
                percentile = lastDigit
            }
            
            self.userActivityPercentile = percentile
        }else{
            self.userActivityPercentile = 50
        }
        
        if(self.userActivityPercentile < 10){
            self.user?.percentMostActive = 10
        }else{
            self.user?.percentMostActive = self.userActivityPercentile
        }
        
    }
    
    func constrain(){
        
        guard let topTile = topTile else { return }
        guard let middleTile = middleTile else { return }
        guard let bottomTile = bottomTile else { return }
        guard let footerTile = footerTile else { return }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        baseView.translatesAutoresizingMaskIntoConstraints = false
        topTile.translatesAutoresizingMaskIntoConstraints = false
        middleTile.translatesAutoresizingMaskIntoConstraints = false
        bottomTile.translatesAutoresizingMaskIntoConstraints = false
        footerTile.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(baseView)
        self.baseView.addSubview(topTile)
        self.baseView.addSubview(middleTile)
        self.baseView.addSubview(bottomTile)
        
        self.baseView.addSubview(footerTile)
        
        
        topTile.leftAnchor.constraint(equalTo: self.baseView.leftAnchor, constant: 7).isActive = true
        topTile.topAnchor.constraint(equalTo: self.baseView.topAnchor, constant: 15).isActive = true
        topTile.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor).isActive = true
        
        
        
        middleTile.leftAnchor.constraint(equalTo: self.baseView.leftAnchor, constant: 7).isActive = true
        middleTile.topAnchor.constraint(equalTo: topTile.bottomAnchor, constant: 15).isActive = true
        middleTile.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor).isActive = true
        
        
        
        bottomTile.leftAnchor.constraint(equalTo: self.baseView.leftAnchor, constant: 7).isActive = true
        bottomTile.topAnchor.constraint(equalTo: middleTile.bottomAnchor, constant: 15).isActive = true
        bottomTile.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor).isActive = true
        
        footerTile.leftAnchor.constraint(equalTo: self.baseView.leftAnchor, constant: 7).isActive = true
        footerTile.topAnchor.constraint(equalTo: bottomTile.bottomAnchor, constant: 15).isActive = true
        footerTile.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor).isActive = true
        
        
        self.scrollView.bottomAnchor.constraint(equalTo: footerTile.bottomAnchor, constant: 15).isActive = true
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.baseView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.baseView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.baseView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        self.baseView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.baseView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        
    }
    
    func updateLessonView(program: Program){
        
        let currentLessonId = program.currentLessonId
        let secondLessonId = program.nextLessonId
        
        self.globalLessons = []
        
        self.network.getLessonContent(lessonId: currentLessonId, completion: { (lesson) in
            self.globalLessons?.append(lesson)
            let programInterface = ProgramInterface(program: program, lesson: lesson)
            
            if let top = self.topTile as? LessonCell {
                top.update(data: programInterface)
            }
        })
        
        if (program.completedLessons > 1) && (self.user?.subscription == nil){
            self.setUpPayWall()
        }else{
            self.network.getLessonContent(lessonId: secondLessonId, completion: { (lesson) in
                self.globalLessons?.append(lesson)
                let programInterface = ProgramInterface(program: program, lesson: lesson)
                if let middle = self.middleTile as? LessonCell {
                    middle.update(data: programInterface)
                }
            })
        }
        
        
        
        if let bottom = self.footerTile as? ProgressCell {
            guard let user = self.user else { return }
            bottom.update(data: user)
        }
    }
    
    func setUpPayWall(){
        if let middle = self.middleTile as? LessonCell {
            middle.hitPayWall()
        }
    }
    
    
    func repairUserDefaults(){
        guard let user = self.user else { return }
        guard let dogs = user.dogs else { return }
        if PUser.deserialize(uid: user.id) == nil {
            let defautltUser = PUser(uid: user.id, email: user.email, firstName: user.firstName, lastName: user.lastName, dogId: dogs[0].id)
            PUser.save(defautltUser)
            
            self.repairDogDefaults()
        }else{
            self.repairDogDefaults()
        }
        
        center.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                self.center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            }
        })
    }
    
    func repairDogDefaults(){
        guard let user = self.user else { return }
        guard let dogs = user.dogs else { return }
        if PDog.deserialize(id: dogs[0].id) == nil {
            let dog = dogs[0]
            let defaultDog = PDog(id: dog.id, name: dog.name, gender: .boy, breed: "temp", age: 0, ownershipDuration: 0)
            PDog.save(defaultDog)
        }
    }
}

extension NewDashboardViewController: VideoProtocol {
    func playLesson(token: String){
        self.playVideo(with: VideoDataSource.wistia, token: token)
    }
}


@objc
extension NewDashboardViewController {
    
    func videoPlayPressed(sender: PlayVideoButton){
        self.playLesson(token: sender.videoUrl!)
        self.network.logFirebaseEvents(logEventsName: "Wistia" + sender.videoUrl! + "VideoPlayed", parameterd: ["name" : sender.videoUrl!])
    }
    
    
    func chatPressed(){
        //to chat room
        guard let user = self.network.user else { return }
        guard let initialMsg = self.network.initialMessages else{ return }
        self.pupserBase?.navigationController?.navigationBar.isHidden = false
        self.pupserBase?.navigationController?.pushViewController(ChatViewController(network: self.network, user: user, initialMsg: initialMsg, isPrefilled: true), animated: true)
        
    }
    
    func toCheckIn(sender: DashBoardButton){
        //check in
        if(sender.isSelected){
            if self.user != nil {
                self.network.logFirebaseEvents(logEventsName: "CheckInPressed", parameterd: ["name" : "ChecKInAction"])
                let vc = CheckInViewController(user: self.network.user!, network: self.network)
                vc.transitioningDelegate = self
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            }
        }else{
            self.network.logFirebaseEvents(logEventsName: "CheckInInvalid", parameterd: ["name" : "CheckInInvalid"])
            SCLAlertView().showWarning("Hello there", subTitle: "It seems you have completed a check in for today! Please come back tomorrow.")
        }
        
    }
    
    func viewProgramPressed(){
        //view program
        if let navigator = self.navigationController {
            let vc = ProgramContentsTableViewController(network: self.network, user: self.network.user!)
            navigator.pushViewController(vc, animated: true)
        }
    }
    
    func subscriptionPressed(){
        //subscription pressed
        guard let user = self.network.user else { return }
        let vc = UpgradeViewController(network: self.network, user: user)
        self.present(vc, animated: true, completion: nil)
    }
    
    func viewArticle(){
        //view article
        if let navigator = self.navigationController {
            let vc = ArticleViewController(article: self.recommendedArticle!, network: self.network, user: self.network.user!)
            navigator.pushViewController(vc, animated: true)
        }
    }
    
    func settingCellPressed(){
        guard let user = self.network.user else { return }
        if let navigator = self.navigationController {
            let vc = SettingsViewController(settingsType: .setting, network: self.network, user: user)
            navigator.pushViewController(vc, animated: true)
        }
    }
    
    
    func completeLesson(sender: DashBoardButton){
        
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: true
        )
        let lessonCompletePopUp = SCLAlertView(appearance: appearance)
        let alertViewIcon = #imageLiteral(resourceName: "alertIcon_LessonComplete")
        
        lessonCompletePopUp.addButton("MASTERED") {
            
            if let userProgram = self.network.user?.programs![0] {
                
                if (userProgram.completedLessons > 1) && (self.network.user?.subscription == nil){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.subscribeNowPopUp()
                    }
                } else {
                    self.placeCongratsView()
                    self.network.markComplete(lessonId: sender.actionKey!, user: self.network.user!, userProgram: userProgram) { isReady in
                        self.updateLessonView(program: userProgram)
                    }
                }
            }
        }
        
        lessonCompletePopUp.showWarning("Ready to move on to your next mission?", subTitle: "", closeButtonTitle: "NOT YET", circleIconImage: alertViewIcon)
        
    }
    
    func subscribeNowPopUp(){
        let subscriptionPopUp = SCLAlertView()
        
        subscriptionPopUp.addButton("Learn More") {
            self.subscriptionPressed()
        }
        
        subscriptionPopUp.showInfo("Pupster Membership", subTitle: "Become a Pupster Member today to unlock the entire program.", closeButtonTitle: "Not Now")
    }
    
    
    func placeCongratsView(){
        let congratsView = LessonCompleteView(name: "", image: Global.network.userProfileImage, imageUrl: self.network.user?.userProfileImageUrl)
        congratsView.translatesAutoresizingMaskIntoConstraints = false
        //self.view.addSubview(congratsView)
        guard let baseVC = self.pupserBase else { return }
        baseVC.view.addSubview(congratsView)
        
        congratsView.topAnchor.constraint(equalTo: baseVC.view.topAnchor).isActive = true
        congratsView.bottomAnchor.constraint(equalTo: baseVC.view.bottomAnchor).isActive = true
        congratsView.leftAnchor.constraint(equalTo: baseVC.view.leftAnchor).isActive = true
        congratsView.rightAnchor.constraint(equalTo: baseVC.view.rightAnchor).isActive = true
        
    }
    
    
    
    func changeProfileImage(){
        
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}







extension NewDashboardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //definitely find a way to do this in protocol. Same code reside in two places.. No good
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
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
            
            self.network.storeUserProfileImage(image: selectedImage, user: self.network.user!)
            if let topView = self.topTile as? UserProfileCell {
                topView.insertImage(image: selectedImage)
                Global.network.userProfileImage = selectedImage
            }
        }
        dismiss(animated:true, completion: nil)
    }

}



extension NewDashboardViewController {
    
    // reminder cell actions
    
    func addNotificationDate(dow: DayOfWeek){
        guard let user = self.network.user else { return }
        var newDates:[DayOfWeek] = []
        var newStatus: UserNotificationStatus!
        if var currentStatus = user.notificationStatus {
            if let currentDates = currentStatus.notificationDates {
                newDates = currentDates
            }
            newDates.append(dow)
            newStatus = UserNotificationStatus(notificationTime: currentStatus.notificationTime, isNotificationOn: true, notificationDates: newDates)
            currentStatus.notificationDates = newDates
        }else{
            newStatus = UserNotificationStatus(notificationTime: 19, isNotificationOn: true, notificationDates: [dow])
            
        }
        user.notificationStatus = newStatus
        self.network.setNotification(user: user, actionType: NotificationActionType.activateIndividualNotification, dowChanged: dow)
        self.turnOnToggle()
    }
    
    func removeNotificationDate(dow: DayOfWeek){
        guard let user = self.network.user else { return }
        var newDates:[DayOfWeek] = []
        var newStatus: UserNotificationStatus!
        
        if let currentStatus = user.notificationStatus {
            guard let statusArray = currentStatus.notificationDates else { return }
            for i in 0..<statusArray.count {
                if(statusArray[i] != dow){
                    newDates.append(statusArray[i])
                }
            }
            newStatus = UserNotificationStatus(notificationTime: currentStatus.notificationTime, isNotificationOn: currentStatus.isNotificationOn, notificationDates: newDates)
        }
        user.notificationStatus = newStatus
        
        self.network.setNotification(user: user, actionType: NotificationActionType.cancelIndividualNotification, dowChanged: dow)
    }
    
    func removeAllNotifications(){
        guard let user = self.network.user else { return }
        var newStatus: UserNotificationStatus!
        if let currentStatus = user.notificationStatus {
            newStatus = UserNotificationStatus(notificationTime: currentStatus.notificationTime, isNotificationOn: false, notificationDates: [])
        }else{
            newStatus = UserNotificationStatus(notificationTime: 19, isNotificationOn: false, notificationDates: [])
        }
        
        user.notificationStatus = newStatus
        
        self.network.setNotification(user: user, actionType: .cancelAllNotification)
        self.resetAllButton()
    }
    
    func setTime(timeInt: Int){
        print(timeInt)
        guard let user = self.network.user else { return }
        var newStatus: UserNotificationStatus!
        if var currentStatus = user.notificationStatus {
            newStatus = UserNotificationStatus(notificationTime: timeInt, isNotificationOn: currentStatus.isNotificationOn, notificationDates: currentStatus.notificationDates)
            currentStatus = newStatus
        }else{
            newStatus = UserNotificationStatus(notificationTime: timeInt, isNotificationOn: false, notificationDates: [])
        }
        
        user.notificationStatus = newStatus
        
        self.network.setNotification(user: user, actionType: .updateTime)
        if let reminderCell = self.middleTile as? ReminderCell {
            reminderCell.changeTimeValue(timeInt: timeInt)
        }
    }
    func turnOnToggle(){
        if let reminderCell = self.middleTile as? ReminderCell {
            reminderCell.notificationSwitch.setOn(true, animated: true)
        }
    }
    
    func resetAllButton(){
        if let reminderCell = self.middleTile as? ReminderCell {
            reminderCell.initializeAllButton()
        }
    }
}

@objc extension NewDashboardViewController {
    
    
    func sunPressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Sun) : removeNotificationDate(dow: .Sun)
    }
    
    func monPressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Mon) : removeNotificationDate(dow: .Mon)
    }
    
    func tuePressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Tue) : removeNotificationDate(dow: .Tue)
    }
    func wedPressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Wed) : removeNotificationDate(dow: .Wed)
    }
    
    func thuPressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Thu) : removeNotificationDate(dow: .Thu)
    }
    
    func friPressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Fri) : removeNotificationDate(dow: .Fri)
    }
    
    func satPressed(sender: ReminderDateButton){
        sender.isSelected ? addNotificationDate(dow: .Sat) : removeNotificationDate(dow: .Sat)
    }
    
    func notificationToggled(sender: UISwitch){
        if (sender.isOn == false){
            removeAllNotifications()
        }
    }
    
    func timeSelectionPressed(sender: UIButton){
        let alert = UIAlertController(title: "Set Reminder Time", message: nil, preferredStyle: .actionSheet)
        for i in 0..<24 {
            var stringVal: String = ""
            if i < 12 {
                stringVal = String(describing: i) + ":00 AM"
            }else if (i == 12) {
                stringVal = String(describing: i) + ":00 PM"
            }else{
                stringVal = String(describing: i - 12) + ":00 PM"
            }
            alert.addAction(UIAlertAction(title: stringVal, style: .default, handler: { _ in
                self.setTime(timeInt: i)
            }))
        }
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension NewDashboardViewController: LoadingHandling {
    func recovery() {
        // user reconnected to internet
    }
}


extension NewDashboardViewController {
    //animating button delegate method
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let tile = self.topTile as? UserProfileCell {
            let topSafeArea = self.view.safeAreaInsets.top
            transition.startingPoint = CGPoint(x: tile.checkInButton.center.x, y: tile.checkInButton.center.y + topSafeArea - self.scrollView.contentOffset.y)
        }
        
        transition.transitionMode = .present
        
        transition.bubbleColor = UIColor(red:0.09, green:0.75, blue:0.93, alpha:1)
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        //transition.startingPoint = CGPoint(x: (self.topTile?.center.x)! - 100.0, y: (self.topTile?.center.y)! + 150.0)
        if let tile = self.topTile as? UserProfileCell {
            let topSafeArea = self.view.safeAreaInsets.top
            transition.startingPoint = CGPoint(x: tile.checkInButton.center.x, y: tile.checkInButton.center.y + topSafeArea - self.scrollView.contentOffset.y)
        }
        transition.bubbleColor = UIColor(red:0.09, green:0.75, blue:0.93, alpha:1)
        return transition
    }
}
