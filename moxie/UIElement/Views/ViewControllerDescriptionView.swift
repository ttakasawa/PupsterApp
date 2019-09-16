//
//  ViewControllerDescriptionView.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/17/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

enum ViewControllerKind {
    case activity
    case tracking
    case market
    
    var stringVal: String {
        switch self {
        case .activity:
            return "activity"
        case .tracking:
            return "tracking"
        case .market:
            return "market"
        }
    }
}


class ViewControllerDescriptionView: UIView, Stylable {
    
    var title: TileLabel!
    var vcDescription: TileLabel!
    var mockButton: TileLabel!
    
    let separator = UIView()
    
    init(type: ViewControllerKind){
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .white
        
        title = TileLabel(text: "", style: TileLabelStyling(font: self.getTitleFont(), color: self.getTextColor()))
        vcDescription = TileLabel(text: "", style: TileLabelStyling(font: self.getNormalTextFont(), color: self.getTextColor()))
        mockButton = TileLabel(text: "", style: TileLabelStyling(font: self.getSubTitleFont(), color: self.getMainColor()))
        
        
        separator.backgroundColor = self.getTextColor()
        
        vcDescription.numberOfLines = 2
        
        self.addSubview(title)
        self.addSubview(vcDescription)
        self.addSubview(mockButton)
        self.addSubview(separator)
        
        self.configure(type: type)
        self.constrain()
        
    }
    
    func configure(type: ViewControllerKind){
        
        if type == .activity {
            title.text = "Start the Pupster Program"
            vcDescription.text = "A step-by-step program designed by experts and customized for your dog."
        }else if type == .tracking {
            title.text = "Track your activity"
            vcDescription.text = "Earn Rewards by tracking what you do with your pup."
        }else{
            title.text = "Find the perfect products"
            vcDescription.text = "Shop expert recommended products for your dog"
        }
        mockButton.text = "GOT IT"
    }
    
    func constrain(){
        title.translatesAutoresizingMaskIntoConstraints = false
        vcDescription.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        mockButton.translatesAutoresizingMaskIntoConstraints = false
        
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        separator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 34).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        vcDescription.leftAnchor.constraint(equalTo: separator.leftAnchor).isActive = true
        vcDescription.rightAnchor.constraint(equalTo: separator.rightAnchor).isActive = true
        vcDescription.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -18).isActive = true
        
        title.leftAnchor.constraint(equalTo: separator.leftAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: vcDescription.topAnchor, constant: -4).isActive = true
        
        mockButton.leftAnchor.constraint(equalTo: separator.leftAnchor).isActive = true
        mockButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 12).isActive = true
        
        
        self.topAnchor.constraint(equalTo: title.topAnchor, constant: -22).isActive = true
        //self.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Stylable where Self: ViewControllerDescriptionView{
    func getTitleFont() -> UIFont {
        return UIFont(name: "SFProText-Semibold", size: 17)!
    }
    func getNormalTextFont() -> UIFont {
        return UIFont(name: "SFProText-Regular", size: 16)!
    }
    
    func getSubTitleFont() -> UIFont {
        return UIFont(name: "SFProText-Bold", size: 15)!
    }
}



class OverlayView: UIView{
    var descriptionView: ViewControllerDescriptionView!
    var darkView = UIView()
    init(type: ViewControllerKind){
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .clear
        
        darkView.backgroundColor = .black
        darkView.layer.opacity = 0.5
        
        descriptionView = ViewControllerDescriptionView(type: type)
        
        self.addSubview(darkView)
        self.addSubview(descriptionView)
        
        darkView.isUserInteractionEnabled = false
        descriptionView.isUserInteractionEnabled = false
        
        self.constrain()
        self.setAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constrain(){
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        darkView.translatesAutoresizingMaskIntoConstraints = false
        
        darkView.bottomAnchor.constraint(equalTo: descriptionView.topAnchor).isActive = true
        darkView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        darkView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        darkView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        descriptionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        descriptionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        descriptionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    func setAction(){
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.removeView))
        gesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(gesture)
    }
    
    @objc func removeView(){
        print("remove")
        self.removeFromSuperview()
    }
}





