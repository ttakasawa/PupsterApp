//
//  ModalController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/2/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit



protocol ModalController : class {
    var navigationController:UINavigationController? { get }
    func configureCloseButton(selector: Selector)
    var closeButton: UIButton { get set }
}

protocol CheckInControllerHelper: ModalController {
    var upButton: UIButton { get set }
    var bottomButton: UIButton { get set }
    func configureUpButton(selector: Selector)
    func configureDownButton(selector: Selector)
}

extension CheckInControllerHelper where Self:UIViewController {
    func configureCloseButton(selector: Selector) {
        //let button:UIButton = UIButton(type: .custom)
        closeButton.setImage(#imageLiteral(resourceName: "checkInButtonXout"), for: .normal)
        //button.backgroundColor = UIColor.purple
        closeButton.addTarget(self, action: selector, for: .touchUpInside)
        let bounds = self.view.bounds
        closeButton.frame = CGRect(x: bounds.width - 60, y: 40
            , width: 30, height: 30)
        self.view.addSubview(closeButton)
        self.view.bringSubview(toFront: closeButton)
    }
    
    func configureUpButton(selector: Selector){
        //let button:UIButton = UIButton(type: .custom)
        upButton.setImage(#imageLiteral(resourceName: "checkInButtonScrollUpDisabled"), for: .normal)
        upButton.isSelected = false
        upButton.addTarget(self, action: selector, for: .touchUpInside)
        let bounds = self.view.bounds
        upButton.frame = CGRect(x: bounds.width - 38 - 44, y: bounds.height - 92 - 44
            , width: 44, height: 44)
        self.view.addSubview(upButton)
        self.view.bringSubview(toFront: upButton)
    }
    func configureDownButton(selector: Selector){
        //let button:UIButton = UIButton(type: .custom)
        bottomButton.setImage(#imageLiteral(resourceName: "checkInButtonScrollDownDisabled"), for: .normal)
        bottomButton.isSelected = false
        bottomButton.addTarget(self, action: selector, for: .touchUpInside)
        let bounds = self.view.bounds
        bottomButton.frame = CGRect(x: bounds.width - 38 - 44, y: bounds.height - 28 - 44
            , width: 44, height: 44)
        self.view.addSubview(bottomButton)
        self.view.bringSubview(toFront: bottomButton)
    }
}




