//
//  tabBarViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 8/13/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewControllers = [activitiesTabBarItem, trackingTabBarItem, productTabBarItem]
    }
    
    lazy public var activitiesTabBarItem: UINavigationController = {
        
//        let tabBar = UINavigationController(rootViewController: DashboardViewController(dashboardBulder: ActivityTrackingDisplayable(), object: ActivityTrackingDashBoardType(), themeStyle: ThemeColorStyling(mainColor: UIColor(red:0.09, green:0.75, blue:0.93, alpha:1), secondaryColor: UIColor(red:1, green:0.69, blue:0.13, alpha:1))))
        
        let tabBar = UINavigationController(rootViewController: NewDashboardViewController(network: Global.network, dashboardBulder: ActivityBoardBuildable(), object: ActivityTrackingDashBoardType()))
        
        let title = "ACTIVITIES"
        let defaultImage = #imageLiteral(resourceName: "tabBarIconActivities")
        let selectedImage = #imageLiteral(resourceName: "tabBarIconActivitiesSelected")
        let tabBarItems = (title: title, image: defaultImage, selectedImage: selectedImage)
        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
        
        tabBar.tabBarItem = tabBarItem
        return tabBar
    }()
    
    lazy public var trackingTabBarItem: UINavigationController = {
        
        let tabBar = UINavigationController(rootViewController: NewDashboardViewController(network: Global.network, dashboardBulder: TrackingBoardBuildable(), object: TrackingDashBoardType()))
        
        let title = "TRACKING"
        let defaultImage = #imageLiteral(resourceName: "tabBarIconTrackingSelected")
        let selectedImage = #imageLiteral(resourceName: "tabBarIconTrackingSelected")
        let tabBarItems = (title: title, image: defaultImage, selectedImage: defaultImage)
        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
        
        tabBar.tabBarItem = tabBarItem
        return tabBar
    }()
    
    
    
    lazy public var productTabBarItem: UINavigationController = {
        
        
        let finalTabBar = UINavigationController(rootViewController: MarketAndCollectionsTableViewController(network: Global.network))
        
        let defaultImage = #imageLiteral(resourceName: "tabBarIconProducts")
        let selectedImage = #imageLiteral(resourceName: "tabBarIconProductsSelected")
        
        let tabBarItem = UITabBarItem(title: "PRODUCTS", image: defaultImage, selectedImage: selectedImage)
        finalTabBar.tabBarItem = tabBarItem
        return finalTabBar
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

