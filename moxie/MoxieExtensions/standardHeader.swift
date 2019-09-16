//
//  standardHeader.swift
//  moxie
//
//  Created by Tomoki Takasawa on 5/24/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class standardHeader: UIView {

    let textLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.textAlignment = .center
        t.font = UIFont.init(name: "AvenirNext-Medium", size: 18)
        //t.textColor = UIColor(red:0.78, green:0.78, blue:0.79, alpha:1)
        t.textColor = UIColor.black
        t.adjustsFontSizeToFitWidth = true
        
        return t
    }()
    
    let goBackButton: UIButton = {
        let g = UIButton()
        g.translatesAutoresizingMaskIntoConstraints = false
        g.setImage(#imageLiteral(resourceName: "goBackIcon"), for: .normal)
        //
        return g
    }()
    
    let separator: UIView = {
        let s = UIView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = UIColor.lightGray
        return s
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
        self.configureAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
        self.configureAnimation()
    }
    
    func configureAnimation() {
        goBackButton.addTarget(self, action: #selector(self.animatePress), for: .touchDown)
    }
    
    func configureView(){
        self.addSubview(goBackButton)
        self.addSubview(textLabel)
        self.addSubview(separator)
        
        self.goBackButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        self.goBackButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        self.goBackButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24).isActive = true
        self.goBackButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14).isActive = true
        
        self.textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //self.textLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        self.textLabel.leftAnchor.constraint(equalTo: self.goBackButton.rightAnchor, constant: 10).isActive = true
        self.textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        
        self.separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.separator.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.separator.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func animatePress() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (completed) in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = .identity
            })
        }
        //self.contro
    }

}
