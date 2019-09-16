//
//  BaseVC.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/19/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class BaseVC: UIViewController, RootLevelViewControllerHelper {
    
    @IBOutlet weak var tabBar: PupsterTabBar!
    
    @IBOutlet weak var activitiesContainer: UIView!
    @IBOutlet weak var trainingContainer: UIView!
    @IBOutlet weak var productsContrainer: UIView!
    @IBOutlet weak var containersBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureContainers()
    }
    
    func setTabBar(hidden: Bool) {
        tabBar.isHidden = hidden
        containersBottomConstraint.constant = hidden ? 0 : 54.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateDashBoards()
    }
    
    func configureTabBar() {
        
        if #available(iOS 11.0, *) {
            guard let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else { return }
            tabBarHeightConstraint.constant = 74.0 + bottom
        } else {
            tabBarHeightConstraint.constant = 74.0
        }
        
        tabBar.tabCallback = setSelected(_:)
        tabBar.setSelected(tab: .activites)
        
        self.showDescription(type: ViewControllerKind.activity, network: Global.network)
    }
    
    func setSelected(_ tab: PupsterTab) {
        
        var vType: ViewControllerKind!
        if (tab == .activites){
            vType = ViewControllerKind.activity
        }else if (tab == .tracking){
            vType = ViewControllerKind.tracking
        }else{
            vType = ViewControllerKind.market
        }
        
        self.showDescription(type: vType, network: Global.network)
        
        activitiesContainer.alpha = tab == .activites ? 1 : 0
        trainingContainer.alpha = tab == .tracking ? 1 : 0
        productsContrainer.alpha = tab == .products ? 1 : 0
        
    }
    
    func configureContainers() {
        let activityController = UINavigationController(rootViewController: NewDashboardViewController(network: Global.network, dashboardBulder: ActivityBoardBuildable(), object: ActivityTrackingDashBoardType()))
        let trainingController = UINavigationController(rootViewController: NewDashboardViewController(network: Global.network, dashboardBulder: TrackingBoardBuildable(), object: TrackingDashBoardType()))
        let productsController = UINavigationController(rootViewController: MarketAndCollectionsTableViewController(network: Global.network))
        
        configureContainer(container: activitiesContainer, controller: activityController)
        configureContainer(container: trainingContainer, controller: trainingController)
        configureContainer(container: productsContrainer, controller: productsController)
    }
    
    func configureContainer(container: UIView, controller: UIViewController) {
        addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: container.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        
        controller.didMove(toParentViewController: self)
    }
    
    func updateDashBoards(){
        print("update")
        for i in 0..<self.childViewControllers.count {
            let navVC = self.childViewControllers[i]
            for j in 0..<navVC.childViewControllers.count {
                if let dashboardVC = navVC.childViewControllers[j] as? NewDashboardViewController {
                    //dashboardVC.updateView()
                }
                
            }
        }
    }

}
