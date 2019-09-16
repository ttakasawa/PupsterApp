//
//  ProductViewImageManipulation.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit


extension productView {
    //expanding image related
    
    func tapToExpand(imgView: UIImageView){
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        pictureTap.numberOfTapsRequired = 1
        imgView.addGestureRecognizer(pictureTap)
        imgView.isUserInteractionEnabled = true
    }
    
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        //self.tabBarController?.tabBar.isHidden = false
        self.pupserBase?.setTabBar(hidden: false)
        UIView.animate(withDuration: 0.5, animations: {
            sender.view?.alpha = 0.0
        }, completion: { (value: Bool) in
            sender.view?.removeFromSuperview()
            if (self.scrollPinch.isDescendant(of: self.view)){
                self.scrollPinch.removeFromSuperview()
            }
        })
    }
    
    @objc func nextExpandedImage(){
        print(imageCurrentIndex)
        print(self.imageArray.count)
        if (imageCurrentIndex != self.imageArray.count - 1){
            imageCurrentIndex = imageCurrentIndex + 1
            newImageView.image = self.imageArray[imageCurrentIndex]
            //gestureRecognizedImageView(imgView: newImageView)
        }
    }
    
    @objc func prevExpandedImage(){
        if (imageCurrentIndex != 0){
            imageCurrentIndex = imageCurrentIndex - 1
            newImageView.image = self.imageArray[imageCurrentIndex]
            //gestureRecognizedImageView(imgView: newImageView)
        }
    }
    
    func gestureRecognizedImageView(imgView: UIImageView){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
        imgView.addGestureRecognizer(tap)
        
        let slideUp = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
        slideUp.direction = .up
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
        slideDown.direction = .down
        
        imgView.addGestureRecognizer(slideUp)
        imgView.addGestureRecognizer(slideDown)
        
        
        let slideLeft = UISwipeGestureRecognizer(target: self, action: #selector(nextExpandedImage))
        slideLeft.direction = .left
        let slideRight = UISwipeGestureRecognizer(target: self, action: #selector(self.prevExpandedImage))
        slideRight.direction = .right    //prevExpandedImage
        
        imgView.addGestureRecognizer(slideLeft)
        imgView.addGestureRecognizer(slideRight)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer){
        let imageView = sender.view as! UIImageView
        newImageView = UIImageView(image: imageView.image)
        
        for i in 0..<imageArray.count {
            if imageView.image == self.imageArray[i]{
                imageCurrentIndex = i
            }
        }
        
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        
        gestureRecognizedImageView(imgView: newImageView)
        
        
        scrollPinch = UIScrollView()
        scrollPinch.frame = UIScreen.main.bounds
        scrollPinch.isUserInteractionEnabled = true
        scrollPinch.minimumZoomScale = 1.0
        scrollPinch.maximumZoomScale = 6.0
        scrollPinch.delegate = self
        scrollPinch.backgroundColor = .black
        
        newImageView.frame = scrollPinch.bounds
        
        self.scrollPinch.addSubview(newImageView)
        UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.view.addSubview(self.scrollPinch)
            
        }, completion: nil)
        
        self.navigationController?.isNavigationBarHidden = true
        //self.tabBarController?.tabBar.isHidden = true
        self.pupserBase?.setTabBar(hidden: true)
    }
}
