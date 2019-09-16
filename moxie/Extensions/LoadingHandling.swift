//
//  LoadingHandling.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//


import Foundation
import SCLAlertView
import UIKit
import SVProgressHUD

protocol LoadingHandling: class {
    var blurEffectView: UIVisualEffectView? { set get }
    func hideLoading()
    func showLoading()
    func nothingFound(main: String, sub: String)
    func recovery()
    func showBlur()
    func removeBlur()
    
    func showRegularLoading()
    func showRegularBlur()
}

private var xoAssociationKey: UInt8 = 0
extension LoadingHandling where Self:UIViewController {
    
    var blurEffectView: UIVisualEffectView? {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? UIVisualEffectView
        }
        
        set(newBlurEffectView) {
            objc_setAssociatedObject(self, &xoAssociationKey, newBlurEffectView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func hideLoading(){
        SVProgressHUD.dismiss()
        self.removeBlur()
    }
    
    func showLoading(){
        SVProgressHUD.show(withStatus: "Loading...")
        self.showBlur()
    }
    
    func showRegularLoading(){
        SVProgressHUD.show(withStatus: "Loading...")
        self.showRegularBlur()
    }
    
    func showBlur(){
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = self.view.bounds
        if let blurEffectView = blurEffectView { self.view.addSubview(blurEffectView) }
    }
    
    func showRegularBlur(){
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = self.view.bounds
        if let blurEffectView = blurEffectView { self.view.addSubview(blurEffectView) }
    }
    
    func removeBlur(){
        if let blurEffectView = blurEffectView {
            blurEffectView.removeFromSuperview()
        }
        blurEffectView = nil
    }
    
    func nothingFound(main: String, sub: String){
        //self.hideLoading()
        self.showBlur()
        self.navigationItem.title = ""
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Try Again", action: {
            self.removeBlur()
            self.recovery()
        })
        alert.addButton("Go Home", action: {
            self.removeBlur()
            if let navigator = self.navigationController {
                navigator.popToRootViewController(animated: true)
            }
        })
        alert.showWarning(main, subTitle: sub)
    }
}

