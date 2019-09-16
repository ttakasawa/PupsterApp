//
//  ArticleHeadingView.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class ArticleHeadingView: DashBoardCell, ImageProtocol {
    
    var baseViewButton = UIButton()
    let articleImageView = UIImageView()
    var articleTitle: TileLabel!
    
    override init(){
        super.init()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(forCell: Bool){
        super.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        super.configureTileStyle()
        articleTitle = TileLabel(text: "", style: TileLabelStyling(font: self.getArticleTitleFont(), color: self.getLightTextColor()))
        articleTitle.textAlignment = .center
        
        self.uiElementSetUp()
        self.constrain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: ArticleDisplayable){
        super.configureTileStyle()
        
        
        data.downloadImage(stringUrl: data.readableImageUrl) { (image) in
            self.articleImageView.image = image
        }
        articleTitle = TileLabel(text: data.readableTitle, style: TileLabelStyling(font: self.getArticleTitleFont(), color: self.getLightTextColor()))
        
        
        self.uiElementSetUp()
        self.constrain()
    }
    
    func configureForLessonCell(title: String, imageUrl: String){
        
        
        self.downloadImage(stringUrl: imageUrl) { (image) in
            self.articleImageView.image = image
        }
        articleTitle.text = title
        
    }
    
    func uiElementSetUp(){
        self.layer.masksToBounds = false
        
        baseViewButton.translatesAutoresizingMaskIntoConstraints = false
        baseViewButton.backgroundColor = UIColor.clear
        baseViewButton.layer.cornerRadius = 8
        baseViewButton.clipsToBounds = true
        
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        articleImageView.clipsToBounds = true
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.isUserInteractionEnabled = false
        
        articleTitle.numberOfLines = 0
        articleTitle.isUserInteractionEnabled = false
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrain(){
        self.addSubview(baseViewButton)
        baseViewButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        baseViewButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        baseViewButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        baseViewButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        baseViewButton.addSubview(articleImageView)
        baseViewButton.addSubview(articleTitle)
        
        articleImageView.topAnchor.constraint(equalTo: baseViewButton.topAnchor).isActive = true
        articleImageView.leftAnchor.constraint(equalTo: baseViewButton.leftAnchor).isActive = true
        articleImageView.rightAnchor.constraint(equalTo: baseViewButton.rightAnchor).isActive = true
        articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor, multiplier: 144/313).isActive = true
        
        articleTitle.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 8).isActive = true
        articleTitle.leftAnchor.constraint(equalTo: baseViewButton.leftAnchor, constant: 14).isActive = true
        articleTitle.centerXAnchor.constraint(equalTo: baseViewButton.centerXAnchor).isActive = true
        
        baseViewButton.bottomAnchor.constraint(equalTo: articleTitle.bottomAnchor, constant: 12).isActive = true
    }
}


