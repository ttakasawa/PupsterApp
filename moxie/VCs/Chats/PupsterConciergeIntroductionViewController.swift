//
//  PupsterConciergeIntroductionViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

class PupsterConciergeIntroductionViewController: UIViewController, Stylable {
    var subscriptionType: SubscriptionStatus
    
    init(subscriptionType: SubscriptionStatus){
        self.subscriptionType = subscriptionType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let cell = DashBoardCell()
        cell.configureTileStyle()
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        let gwenView = self.subscriptionType.isOnSubscription ? GwenDetail() : BillDetail()
        gwenView.translatesAutoresizingMaskIntoConstraints = false
        gwenView.backgroundColor = .clear
        
        self.view.addSubview(cell)
        cell.addSubview(gwenView)
        
        cell.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        cell.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        cell.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cell.heightAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 200.0 / 360.0).isActive = true
        
        gwenView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        gwenView.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        gwenView.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        gwenView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigation()
        //self.pupserBase?.setTabBar(hidden: true)
    }
    
    func setNavigation(){
        self.navigationItem.title = "Details"
        //self.navigationItem.title?.colored(with: self.getMainColor())
        //self.tabBarController?.tabBar.isHidden = true
    }
}

protocol SubscriptionStatus {
    var isOnSubscription: Bool { get }
}
extension UserData: SubscriptionStatus {
    
}

