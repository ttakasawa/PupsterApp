//
//  ProductViewFrontEnd.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit



extension productView{
    //all front end of product view
    
    
    func setproductImageContainer(){
        self.productImageContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        //self.productImageContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
        self.productImageContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.productImageContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.productImageContainer.heightAnchor.constraint(equalToConstant: frameHeight).isActive = true
    }
    func setLabels(){
        
        self.price.rightAnchor.constraint(equalTo: self.scrollableView.rightAnchor, constant: -15).isActive = true
        self.price.topAnchor.constraint(equalTo: self.scrollableView.topAnchor, constant: 20).isActive = true
        
        self.name.topAnchor.constraint(equalTo: self.scrollableView.topAnchor, constant: 20).isActive = true
        self.name.leftAnchor.constraint(equalTo: self.scrollableView.leftAnchor, constant: 20).isActive = true
        self.name.rightAnchor.constraint(equalTo: self.price.leftAnchor, constant: -10).isActive = true
        
        
        self.companyName.topAnchor.constraint(equalTo: self.name.bottomAnchor, constant: 1).isActive = true
        self.companyName.leftAnchor.constraint(equalTo: self.name.leftAnchor).isActive = true
        self.companyName.rightAnchor.constraint(equalTo: self.name.rightAnchor).isActive = true
        
        if (self.numOfSelectables == 0){
            self.purchaseButton.topAnchor.constraint(equalTo: self.companyName.bottomAnchor, constant: 20).isActive = true
            self.purchaseButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
            
            //self.purchaseButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 100).isActive = true
            self.purchaseButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
            self.purchaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            
        }
        if (self.numOfSelectables == 1){
            self.scrollableView.addSubview(colorContainer)
            self.colorContainer.topAnchor.constraint(equalTo: companyName.bottomAnchor, constant: 20).isActive = true
            self.colorContainer.leftAnchor.constraint(equalTo: scrollableView.leftAnchor, constant: 15).isActive = true
            self.colorContainer.rightAnchor.constraint(equalTo: scrollableView.rightAnchor, constant: -15).isActive = true
            self.colorContainer.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            self.purchaseButton.topAnchor.constraint(equalTo: self.colorContainer.bottomAnchor, constant: 20).isActive = true
            self.purchaseButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
            
            //self.purchaseButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 100).isActive = true
            self.purchaseButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
            self.purchaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
        }
        if (self.numOfSelectables == 2){
            self.scrollableView.addSubview(colorContainer)
            self.colorContainer.topAnchor.constraint(equalTo: companyName.bottomAnchor, constant: 20).isActive = true
            self.colorContainer.leftAnchor.constraint(equalTo: scrollableView.leftAnchor, constant: 15).isActive = true
            self.colorContainer.rightAnchor.constraint(equalTo: scrollableView.rightAnchor, constant: -15).isActive = true
            self.colorContainer.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            self.scrollableView.addSubview(colorContainer2)
            self.colorContainer2.topAnchor.constraint(equalTo: colorContainer.bottomAnchor, constant: 20).isActive = true
            self.colorContainer2.leftAnchor.constraint(equalTo: scrollableView.leftAnchor, constant: 15).isActive = true
            self.colorContainer2.rightAnchor.constraint(equalTo: scrollableView.rightAnchor, constant: -15).isActive = true
            self.colorContainer2.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            self.purchaseButton.topAnchor.constraint(equalTo: self.colorContainer2.bottomAnchor, constant: 20).isActive = true
            self.purchaseButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
            
            //self.purchaseButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 100).isActive = true
            self.purchaseButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
            self.purchaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            
        }
        if (self.numOfSelectables == 3){
            self.scrollableView.addSubview(colorContainer)
            self.colorContainer.topAnchor.constraint(equalTo: companyName.bottomAnchor, constant: 20).isActive = true
            self.colorContainer.leftAnchor.constraint(equalTo: scrollableView.leftAnchor, constant: 15).isActive = true
            self.colorContainer.rightAnchor.constraint(equalTo: scrollableView.rightAnchor, constant: -15).isActive = true
            self.colorContainer.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            self.scrollableView.addSubview(colorContainer2)
            self.colorContainer2.topAnchor.constraint(equalTo: colorContainer.bottomAnchor, constant: 20).isActive = true
            self.colorContainer2.leftAnchor.constraint(equalTo: scrollableView.leftAnchor, constant: 15).isActive = true
            self.colorContainer2.rightAnchor.constraint(equalTo: scrollableView.rightAnchor, constant: -15).isActive = true
            self.colorContainer2.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            self.scrollableView.addSubview(colorContainer3)
            self.colorContainer3.topAnchor.constraint(equalTo: colorContainer2.bottomAnchor, constant: 20).isActive = true
            self.colorContainer3.leftAnchor.constraint(equalTo: scrollableView.leftAnchor, constant: 15).isActive = true
            self.colorContainer3.rightAnchor.constraint(equalTo: scrollableView.rightAnchor, constant: -15).isActive = true
            self.colorContainer3.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            
            self.purchaseButton.topAnchor.constraint(equalTo: self.colorContainer3.bottomAnchor, constant: 20).isActive = true
            self.purchaseButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
            self.purchaseButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
            self.purchaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        self.scroller.topAnchor.constraint(equalTo: self.purchaseButton.bottomAnchor, constant: 5).isActive = true
        self.scroller.leftAnchor.constraint(equalTo: self.scrollableView.leftAnchor).isActive = true
        self.scroller.rightAnchor.constraint(equalTo: self.scrollableView.rightAnchor).isActive = true
        self.scroller.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //scroller.layer.borderColor = UIColor.black.cgColor
        //scroller.layer.borderWidth = 2
        
        self.productDescriptionText.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 40).isActive = true
        self.productDescriptionText.leftAnchor.constraint(equalTo: self.name.leftAnchor).isActive = true
        self.productDescriptionText.rightAnchor.constraint(equalTo: self.price.rightAnchor).isActive = true
        //self.price.heightAnchor.constraint(equalToConstant: frameHeight).isActive = true
    }
    
    func setNavigationBar(title: String){
        navigationItem.title = title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font: UIFont.init(name: "AvenirNext-Medium", size: 18)!]
        //self.navigationController?.interacti
        //UIFont.init(name: "AvenirNext-Medium", size: 18)
    }
    
    
    func setScrollable(){
        self.scroll.topAnchor.constraint(equalTo: self.productImageContainer.bottomAnchor, constant: 30).isActive = true
        self.scroll.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scroll.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.scroll.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.scrollableView.topAnchor.constraint(equalTo: self.scroll.topAnchor).isActive = true
        self.scrollableView.leftAnchor.constraint(equalTo: self.scroll.leftAnchor).isActive = true
        self.scrollableView.rightAnchor.constraint(equalTo: self.scroll.rightAnchor).isActive = true
        self.scrollableView.bottomAnchor.constraint(equalTo: self.scroll.bottomAnchor).isActive = true
        self.scrollableView.widthAnchor.constraint(equalTo: self.scroll.widthAnchor).isActive = true
        
        
        self.productDescriptionText.bottomAnchor.constraint(equalTo: self.scrollableView.bottomAnchor, constant: -60).isActive = true
        
    }
    
    func setPageControl(){
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.pageControl.topAnchor.constraint(equalTo: self.productImageContainer.bottomAnchor, constant: 10).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 10).isActive = true
        self.pageControl.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        //self.pageControl.numberOfPages
    }
    
    func setImages(){
        
        productImageContainer.frame = self.view.frame
        self.pageControl.numberOfPages = self.imageUrlStrArray.count
        
        for i in 0..<self.imageUrlStrArray.count{
            let imageView = UIImageView()
            
            if (i == 0) && (self.isVideo == true){
                self.placeVideo(imgView: imageView)
            }else{
                self.tapToExpand(imgView: imageView)
                
            }
            //imageView.image = imageArray[i]
            if let urlImage = URL(string: self.imageUrlStrArray[i]){
                imageView.af_setImage(withURL: urlImage, placeholderImage: #imageLiteral(resourceName: "marketLoadingPlace"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true){ [weak self]
                    complete in
                    
                    self?.imageArray.append(complete.value ?? #imageLiteral(resourceName: "marketLoadingPlace"))
                    if(complete.result.isSuccess){
                        //success
                    }
                }
            }
            imageView.contentMode = .scaleAspectFit
            let topleftX = self.productImageContainer.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: topleftX, y: 0, width: self.productImageContainer.frame.width, height: frameHeight)
            
            productImageContainer.contentSize.width = productImageContainer.frame.width * CGFloat(i + 1)
            productImageContainer.addSubview(imageView)
        }
        self.view.addSubview(self.pageControl)
        setPageControl()
    }
    
    func placeButton(imgView: UIImageView){
        imgView.addSubview(videoButton)
        
        videoButton.centerXAnchor.constraint(equalTo: imgView.centerXAnchor).isActive = true
        videoButton.centerYAnchor.constraint(equalTo: imgView.centerYAnchor).isActive = true
        videoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        videoButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
    }
    
    func placeVideo(imgView: UIImageView){
        self.placeButton(imgView: imgView)
        
        self.videoButton.addTarget(self, action: #selector(self.playPressed), for: .touchUpInside)
        self.videoButton.isUserInteractionEnabled = true
        imgView.isUserInteractionEnabled = true
    }
    
    
    func isAllFilled(){
        
    }
}
