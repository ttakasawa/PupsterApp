//
//  offlinePanel.swift
//  Testing
//
//  Created by Tomoki Takasawa on 4/14/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class offlinePanel: UIView, UIScrollViewDelegate {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    let offLineLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.text = "You are offline, please connect to the internet. You can still check out some of our training contents."
        t.numberOfLines = 0
        t.textColor = UIColor.white
        t.textAlignment = .center
        
        return t
    }()
    
    let goBackButton: ShadowButton = {
        let gb = ShadowButton()
        gb.backgroundColor = UIColor(red:0.33, green:0.74, blue:0.72, alpha:1.0)
        gb.translatesAutoresizingMaskIntoConstraints = false
        gb.setTitle("Go To Training", for: .normal)
        gb.setTitleColor(UIColor.white, for: .normal)
        gb.titleLabel?.font = UIFont.init(name: "AvenirNext-DemiBold", size: 20)
        gb.titleLabel?.adjustsFontSizeToFitWidth = true
        
        return gb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        /*let network: NetworkManager = NetworkManager.sharedInstance
        
        
        NetworkManager.isReachable { _ in
            print("is online")
            self.removeFromSuperview()
        }
        
        //NetworkManager.reacha
        
        network.reachability.whenReachable = { _ in
            print("Became online")
            self.removeFromSuperview()
        }*/
        
        self.addSubview(offLineLabel)
        self.addSubview(goBackButton)
        self.backgroundColor = UIColor(red:0.35, green:0.38, blue:0.46, alpha:1.0)
        
        offLineLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        offLineLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //offLineLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        offLineLabel.widthAnchor.constraint(equalToConstant: 240).isActive = true
        
        goBackButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        goBackButton.topAnchor.constraint(equalTo: self.offLineLabel.bottomAnchor, constant: 40).isActive = true
        goBackButton.widthAnchor.constraint(equalToConstant: 240).isActive = true
        goBackButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        goBackButton.addTarget(self, action: #selector(self.goHome), for: .touchUpInside)
        
        //self.isUserInteractionEnabled = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func goHome(){
        //self.tabBarController?.selectedIndex = 1
        //self.navigationController?.popToRootViewController(animated: true)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let mv = sb.instantiateViewController(withIdentifier: "tabBar")  as! UITabBarController
        mv.selectedViewController = mv.viewControllers?[1]
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController = mv
            //window.rootViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scroll")
    }
    
    
}

