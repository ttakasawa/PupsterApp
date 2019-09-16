//
//  RootLevelViewControllerHelper.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/18/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//
import Foundation
import UIKit

protocol RootLevelViewControllerHelper {
    func showDescription(type: ViewControllerKind, network: UserType, user: UserData?)
    func shouldDescriptionShown(type: ViewControllerKind, network: UserType, user: UserData)
    func presentDescription(type: ViewControllerKind, network: UserType, user: UserData)
    
    func changeMessageIcon(isUnread: Bool)
}

extension RootLevelViewControllerHelper where Self: UIViewController {
    
    func changeMessageIcon(isUnread: Bool){
        if isUnread {
            self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "chatIconUnread").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }else{
            self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "chatIcon").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }
    }
    
    func showDescription(type: ViewControllerKind, network: UserType, user: UserData? = nil){
        
        if let user = user {
            self.shouldDescriptionShown(type: type, network: network, user: user)
        }else{
            network.queryUser { (user: UserData?, error: Error?) in
                guard let user = user else { return }
                self.shouldDescriptionShown(type: type, network: network, user: user)
            }
        }
    }
    
    func shouldDescriptionShown(type: ViewControllerKind, network: UserType, user: UserData){
        let activityIntroduced = user.viewIntroduction?.activity ?? false
        let trackingIntroduced = user.viewIntroduction?.tracking ?? false
        let marketIntroduced = user.viewIntroduction?.market ?? false
        
        if (type == .activity) && (activityIntroduced == false){
            self.presentDescription(type: type, network: network, user: user)
        }else if (type == .tracking) && (trackingIntroduced == false){
            self.presentDescription(type: type, network: network, user: user)
        }else if (type == .market) && (marketIntroduced == false){
            self.presentDescription(type: type, network: network, user: user)
        }
    }
    
    func presentDescription(type: ViewControllerKind, network: UserType, user: UserData){
        network.updateVIewIntroStatus(user: user, type: type)
        
        let view = OverlayView(type: type)
        
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        guard let navVC = self.navigationController else { return }
        navVC.view.addSubview(view)
        //Exception Here
        view.topAnchor.constraint(equalTo: navVC.view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: navVC.view.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: navVC.view.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: navVC.view.rightAnchor).isActive = true
    }
}
