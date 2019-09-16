

//
//  AppDelegate.swift
//  moxie
//
//  Created by Tomoki Takasawa on 12/15/17.
//  Copyright © 2017 Tomoki Takasawa. All rights reserved.
//

import Firebase
import UIKit

import FirebaseMessaging
import FirebaseInstanceID

import UserNotifications
import Fabric
import Crashlytics
import FPSCounter
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
import Stripe
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func testMode() -> Bool{
        return false
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //Appsee temporarily not in use
//        Appsee.start()
//        Appsee.setDelegate(self)
        
        
        Branch.getInstance().setDebug()
        // listener for Branch Deep Link data
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            print(params as? [String: AnyObject] ?? {})
        }
        
        setupIAP()
        
        FirebaseApp.configure()
        setRealTimeDatabasePersistence()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        self.setupStripe(isTest: false)
        self.setupFabric()
        Messaging.messaging().delegate = self
        
        let center =  UNUserNotificationCenter.current()
        center.delegate = self
        
        if (testMode()){
            //Global.network = Global.DemoNetwork()
        }
        autoLoginIfPossible()
        return true
    }
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter in app delegate")
        //MustDo
        
        if (response.notification.request.content.categoryIdentifier == NotificationCategory.lesson) {
            print("lesson notification tapped")
        }else{
            guard let rootNav = self.window?.rootViewController else { return }
            let baseVCs = rootNav.childViewControllers
            
            var baseVC: UIViewController!
            
            if baseVCs.count > 0 {
                baseVC = baseVCs[0]
            }else{
                return
            }
            
            let lateSplash = UIImageView(image: #imageLiteral(resourceName: "Splash"))
            lateSplash.contentMode = .scaleAspectFill
            lateSplash.translatesAutoresizingMaskIntoConstraints = false
            rootNav.view.addSubview(lateSplash)
            lateSplash.topAnchor.constraint(equalTo: rootNav.view.topAnchor).isActive = true
            lateSplash.bottomAnchor.constraint(equalTo: rootNav.view.bottomAnchor).isActive = true
            lateSplash.leftAnchor.constraint(equalTo: rootNav.view.leftAnchor).isActive = true
            lateSplash.rightAnchor.constraint(equalTo: rootNav.view.rightAnchor).isActive = true
            
            if let user = Global.network.user {
                guard let initialMsg = Global.network.initialMessages else{ return }
                let navVC = baseVC.childViewControllers[0]
                let dashBoard = navVC.childViewControllers[0]
                dashBoard.navigationController?.popToRootViewController(animated: false)
                
                let middleNav = baseVC.childViewControllers[1]
                let middleDashBoard = middleNav.childViewControllers[0]
                middleDashBoard.navigationController?.popToRootViewController(animated: false)
                
                let lastNav = baseVC.childViewControllers[2]
                let lastDashBoard = lastNav.childViewControllers[0]
                lastDashBoard.navigationController?.popToRootViewController(animated: false)
                
                
                dashBoard.pupserBase?.navigationController?.popToRootViewController(animated: false)
                
                let presentedVC = dashBoard.presentedViewController
                if presentedVC != nil {
                    presentedVC?.dismiss(animated: false, completion: nil)
                    lateSplash.removeFromSuperview()
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    dashBoard.pupserBase?.navigationController?.navigationBar.isHidden = false
                    dashBoard.pupserBase?.navigationController?.pushViewController(ChatViewController(network: Global.network, user: user, initialMsg: initialMsg, isPrefilled: true), animated: false)
                    lateSplash.removeFromSuperview()
                }
                //lateSplash.removeFromSuperview()
                return
                
            }else{
                
                Global.network.queryUser { (user: UserData?, error: Error?) in
                    
                    if error != nil {
                        return
                    }
                    guard let user = user else {
                        return
                    }
                    
                    //Global.network.getRecentMessages()
                    
                    let navVC = baseVC.childViewControllers[0]
                    let dashBoard = navVC.childViewControllers[0]
                    dashBoard.pupserBase?.navigationController?.navigationBar.isHidden = false
                    dashBoard.pupserBase?.navigationController?.pushViewController(ChatViewController(network: Global.network, user: user, initialMsg: [], isPrefilled: false), animated: true)
                    lateSplash.removeFromSuperview()
                }
                
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
            }
            
        }
        completionHandler()
    }

    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        let branchHandled = Branch.getInstance().application(app, open: url, options: options)
        if branchHandled {
            return true
        }
        
        let facebookHandled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        if facebookHandled {
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let branchHandled = Branch.getInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        if branchHandled {
            return true
        }
        
        let facebookHandled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        if facebookHandled {
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        Branch.getInstance().continue(userActivity)
        return true
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("last call")
        
        guard let currentSession = Global.network.session else { return }
        guard let user = Global.network.user else { return }
        let updatedSession = Session(startTime: currentSession.startTime, endTime: Date())
        
        var newSessions: [Session] = []
        if let sessions = user.sessions {
            newSessions = sessions
        }
        newSessions.append(updatedSession)
        
        
        Global.network.storeUserSession(user: user, sessions: newSessions)
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        let center =  UNUserNotificationCenter.current()
        center.delegate = self
        
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        Global.network.session = Session(startTime: Date(), endTime: Date())
        
        Messaging.messaging().shouldEstablishDirectChannel = true
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

   
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        //print("application opened from didReceiveRemoteNotification")
        if userInfo[gcmMessageIDKey] != nil {
            //print("Message ID: \(messageID)")
        }
        
        if application.applicationState == UIApplicationState.inactive {
            //let vc = TestingViewController()
            print("didReceiveNotification activated")
        }
        
        //if userInfo[aler]
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        Branch.getInstance().handlePushNotification(userInfo)
        
        if userInfo[gcmMessageIDKey] != nil {
            //print("Message ID: \(messageID)")
        }
        
        
        guard let rootNav = self.window?.rootViewController else { return }
        let baseVC = rootNav.childViewControllers[0]
        
        for i in 0..<baseVC.childViewControllers.count {
            let navVC = baseVC.childViewControllers[i]
            for j in 0..<navVC.childViewControllers.count {
                if let dashBoard = navVC.childViewControllers[j] as? NewDashboardViewController {
                    dashBoard.changeMessageIcon(isUnread: true)
                }
                if let dashBoard = navVC.childViewControllers[j] as? MarketAndCollectionsTableViewController {
                    dashBoard.changeMessageIcon(isUnread: true)
                }
            }
        }
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    
    func showDashBoard(){
        let nav = UINavigationController()
        nav.navigationBar.isHidden = true
        let tabBarController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaseVC") as! BaseVC
        nav.setViewControllers([tabBarController], animated: false)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = .white
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        if let id = Auth.auth().currentUser?.uid {
            Global.network.updateRegistrationToken(id: id, token: fcmToken)
        }
        
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        //print("Received data message: \(remoteMessage.appData)")
        
        guard let rootNav = self.window?.rootViewController else { return }
        let baseVC = rootNav.childViewControllers[0]
        
        for i in 0..<baseVC.childViewControllers.count {
            let navVC = baseVC.childViewControllers[i]
            for j in 0..<navVC.childViewControllers.count {
                if let dashBoard = navVC.childViewControllers[j] as? NewDashboardViewController {
                    dashBoard.changeMessageIcon(isUnread: true)
                }
                if let dashBoard = navVC.childViewControllers[j] as? MarketAndCollectionsTableViewController {
                    dashBoard.changeMessageIcon(isUnread: true)
                }
            }
        }
        
        
        
    }

}

extension AppDelegate {
    
    func autoLoginIfPossible() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if let currentUser = Auth.auth().currentUser {
            if let user = PUser.deserialize(uid: currentUser.uid) {
                UserService.shared.setCurrent(user: user)
                if let dog = PDog.deserialize(id: user.dogId), !dog.name.isEmpty, !dog.breed.isEmpty {
                    DogService.shared.setCurrent(dog: dog)
                    showDashBoard()
                } else {
                    //user without full data
                    window?.rootViewController = DogNameGenderVC.init(nibName: nil, bundle: nil)
                    window?.makeKeyAndVisible()
                    window?.backgroundColor = .white
                }
                
            } else {
                //No user
                window?.rootViewController = UIStoryboard.init(name: "LoginFlow", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                window?.makeKeyAndVisible()
                window?.backgroundColor = .white
            }
            
        } else {
            //No auth user
            window?.rootViewController = UIStoryboard.init(name: "LoginFlow", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            window?.makeKeyAndVisible()
            window?.backgroundColor = .white
        }
    }
}

extension AppDelegate {
    
    func setupFabric(){
        Fabric.with([Crashlytics.self])
    }
    
    func setupStripe(isTest: Bool){
        if isTest {
            
            STPPaymentConfiguration.shared().publishableKey = "pk_test_TYooMQauvdEDq54NiTphI7jx"
        }else{
            STPPaymentConfiguration.shared().publishableKey = "pk_live_Ja68ebHf36to5Bcnv4cPhS1v"
        }
    }
    
    func setRealTimeDatabasePersistence(){
        Database.database().isPersistenceEnabled = true
        let maketRef = Database.database().reference(withPath: "market")
        let collectionRef = Database.database().reference(withPath: "collection")
        let unreadMessageRef = Database.database().reference(withPath: "users/{user}/isUnreadMessage")
        let messageRef = Database.database().reference(withPath: "messages")
        let userMessageRef = Database.database().reference(withPath: "UserMessages")
        let rankingRef = Database.database().reference(withPath: "Ranking")
        
        maketRef.keepSynced(true)
        collectionRef.keepSynced(true)
        unreadMessageRef.keepSynced(true)
        messageRef.keepSynced(true)
        userMessageRef.keepSynced(true)
        rankingRef.keepSynced(true)
    }
}

//extension AppDelegate: AppseeDelegate {
//    func appseeSessionStarted(_ sessionId: String!, videoRecorded isVideoRecorded: Bool) {
//        let crashlyticsAppseeId: String = Appsee.generate3rdPartyID("Crashlytics", persistent: false)
//        Crashlytics.sharedInstance().setObjectValue("https://dashboard.appsee.com/3rdparty/crashlytics/\(crashlyticsAppseeId)", forKey: "AppseeSessionUrl")
//    }
//}
