//
//  ShadowButton.swift
//  moxie
//
//  Created by ZacharyH on 1/23/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class ShadowButton: UIButton {
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureShadow()
        self.configureAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.configureShadow()
        self.configureAnimation()
    }
    
    func configureShadow() {
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
        self.layer.shadowOpacity = 1
        self.layer.cornerRadius = 8
    }

    func configureAnimation() {
        self.addTarget(self, action: #selector(ShadowButton.animatePress), for: .touchDown)
    }
    
    @objc func animatePress() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (completed) in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = .identity
            })
        }
    }
}


class ShadowRoundAnimatedButton: UIButton {
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureShadow()
        self.configureAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.configureShadow()
        self.configureAnimation()
    }
    
    func configureShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowColor = UIColor(red:0.66, green:0.67, blue:0.71, alpha:1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.cornerRadius = 22
    }
    
    func changeShadowType(){
        //custom shadows
    }
    
    func configureAnimation() {
        self.addTarget(self, action: #selector(self.animatePress), for: .touchDown)
    }
    
    @objc func animatePress() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (completed) in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = .identity
            })
        }
    }
}

