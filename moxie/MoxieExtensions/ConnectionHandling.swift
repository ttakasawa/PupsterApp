//
//  nonConnectionAlert.swift
//  moxie
//
//  Created by Tomoki Takasawa on 3/19/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import SystemConfiguration
import SCLAlertView

protocol ConnectionHandling {
    var errorBlock:(_ error: Error?) -> Void { get }
    func nonConnectionAlert()
    func isConnectedToNetwork() -> Bool
    
}

extension ConnectionHandling where Self:UIViewController {
    func nonConnectionAlert() {
        SCLAlertView().showWarning("Not connected to the internet", subTitle: "The content you tried to access requires an internet connection.")
    }
    
    func isConnectedToNetwork() -> Bool {
     
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
