//
//  isOnline.swift
//  moxie
//
//  Created by Tomoki Takasawa on 3/12/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import SVProgressHUD

protocol isOnline : class {
    
    func isConnectedToNetwork()
    func alertPopUp(message: String)
    var Offlinepanel: UIView! {get set}
    func recovery()
    
    //func configureTouchId()
}

extension isOnline where Self:UIViewController {
    
    
    func isConnectedToNetwork() {
        //need to fix the issue with deinit of paent view controller
        let network: NetworkManager = NetworkManager.sharedInstance
        
        NetworkManager.isUnreachable { _ in
            print("is offline")
            //self.view.isUserInteractionEnabled = false
            self.Offlinepanel = offlinePanel(frame: self.view.frame)
            
            if let navigator = self.navigationController{
                self.Offlinepanel.tag = 1
                navigator.view.addSubview(self.Offlinepanel)
            }else{
                self.view.addSubview(self.Offlinepanel)
            }
        }
        
        
        network.reachability.whenUnreachable = { reachability in
            print("Became offline")
            SVProgressHUD.dismiss()
            self.Offlinepanel = offlinePanel(frame: self.view.frame)
            if let navigator = self.navigationController{
                self.Offlinepanel.tag = 1
                navigator.view.addSubview(self.Offlinepanel)
            }else{
                self.view.addSubview(self.Offlinepanel)
            }
            
        }
        
        NetworkManager.isReachable { _ in
            print("is online")
            if(self.Offlinepanel != nil){
                print("panel exist")
                if let navigator = self.navigationController{
                    print("on navigator")
                    navigator.view.viewWithTag(1)?.removeFromSuperview()
                    //navigator.view.viewWithTag(1) = nil
                }else{
                    print("normal")
                    if (self.Offlinepanel.isDescendant(of: self.view)){
                        print("isDescendent")
                        self.Offlinepanel.removeFromSuperview()
                        //self.Offlinepanel = nil
                    }
                }

            }
            
        }
 
        //NetworkManager.reacha
        
        network.reachability.whenReachable = { _ in
            print("Became online")
            if(self.Offlinepanel != nil){
                print("panel exist")
                if let navigator = self.navigationController{
                    print("on navigator")
                    navigator.view.viewWithTag(1)?.removeFromSuperview()
                }else{
                    print("normal")
                    if (self.Offlinepanel.isDescendant(of: self.view)){
                        print("isDescendent")
                        self.Offlinepanel.removeFromSuperview()
                        self.recovery()
                    }
                }
                
            }
        }
        return
    }
    
    func alertPopUp(message: String){
        let AuthFailed = UIAlertController(title: "InternetCheck", message: message, preferredStyle: UIAlertControllerStyle.alert)
        AuthFailed.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(AuthFailed, animated: true, completion: nil)
    }
    
    func isConnectedToNetworkFunc() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
        
    }
}


