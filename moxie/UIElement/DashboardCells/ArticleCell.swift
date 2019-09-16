//
//  ArticleCell.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit


class ArticleCell: DashBoardCell {
    var article = ArticleHeadingView()
    var title: TileLabel!
    
    override init(){
        super.init()
        self.article.baseViewButton.addTarget(self.superview, action: #selector(NewDashboardViewController.viewArticle), for: .touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: ArticleDisplayable){
        super.configureTileStyle()
        let title = TileLabel(text: "Did you know?", style: TileLabelStyling(font: self.getTitleFont(), color: self.getTextColor()))
        
        
        article.configure(data: data)
        
        self.addSubview(title)
        self.addSubview(article)
        
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        
        article.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 15).isActive = true
        article.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 23).isActive = true
        article.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -23).isActive = true
        
        self.bottomAnchor.constraint(equalTo: article.bottomAnchor, constant: 24).isActive = true
        
        //MustDo: article press
    }
    
}

