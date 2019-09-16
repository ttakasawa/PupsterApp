//
//  MarketTilesWithCachedImage.swift
//  moxie
//
//  Created by Tomoki Takasawa on 6/9/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

//
//  MarketTiles.swift
//  moxie
//
//  Created by Tomoki Takasawa on 5/23/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import AlamofireImage

class MarketTilesWithCachedImage: UITableViewCell {
    
    var title1: String?
    var actionButtonTitle: String?
    var mainImage: UIImageView?
    var id: String?
    var panelType: String?
    
    let background: UIView = {
        let b = UIView()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor.white
        
        return b
    }()
    
    let iconImageForTile: UIImageView = {
        let t = UIImageView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.contentMode = .scaleAspectFit
        
        return t
    }()
    
    let titleView: UITextView = {
        let t = UITextView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = UIFont.init(name: "AvenirNext-Medium", size: 16)
        t.textColor = UIColor.black
        t.textAlignment = .left
        t.isScrollEnabled = false
        t.isEditable = false
        t.backgroundColor = UIColor.clear
        
        return t
    }()
    
    var mainImageView: UIImageView = {
        let t = UIImageView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.contentMode = .scaleAspectFit
        
        return t
    }()
    
    //let testing: ImageV
    
    let actionButton: UIView = {
        let b = UIView()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 4
        b.layer.borderColor = UIColor(red: 0.2, green: 0.6, blue: 1, alpha: 1).cgColor
        b.layer.borderWidth = 1
        
        return b
    }()
    
    let actionButtonLabel: UILabel = {
        let a = UILabel()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.textAlignment = .center
        a.font = UIFont.init(name: "AvenirNext-Medium", size: 16)
        a.textColor = UIColor(red: 0.2, green: 0.6, blue: 1, alpha: 1)
        a.adjustsFontSizeToFitWidth = true
        
        return a
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 0.39)
        
        self.addSubview(background)
        self.background.addSubview(iconImageForTile)
        self.background.addSubview(titleView)
        self.background.addSubview(mainImageView)
        self.background.addSubview(actionButton)
        self.actionButton.addSubview(actionButtonLabel)
        
        
        self.background.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.background.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.background.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        
        self.iconImageForTile.topAnchor.constraint(equalTo: self.background.topAnchor, constant: 18).isActive = true
        self.iconImageForTile.rightAnchor.constraint(equalTo: self.titleView.leftAnchor, constant: -7).isActive = true
        self.iconImageForTile.leftAnchor.constraint(equalTo: self.background.leftAnchor, constant: 20).isActive = true
        self.iconImageForTile.heightAnchor.constraint(equalTo: self.iconImageForTile.widthAnchor).isActive = true
        
        self.titleView.topAnchor.constraint(equalTo: self.background.topAnchor, constant: 5).isActive = true
        self.titleView.leftAnchor.constraint(equalTo: self.background.leftAnchor, constant: 40).isActive = true
        self.titleView.rightAnchor.constraint(equalTo: self.background.rightAnchor).isActive = true
        
        self.mainImageView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 5).isActive = true
        self.mainImageView.rightAnchor.constraint(equalTo: self.background.rightAnchor).isActive = true
        self.mainImageView.leftAnchor.constraint(equalTo: self.background.leftAnchor).isActive = true
        //self.mainImageView.heightAnchor.constraint(equalTo: self.background.widthAnchor, ).isActive = true
        self.mainImageView.heightAnchor.constraint(equalTo: self.background.widthAnchor, multiplier: 0.75).isActive = true
        
        self.actionButton.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 17).isActive = true
        self.actionButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        self.actionButton.centerXAnchor.constraint(equalTo: self.background.centerXAnchor).isActive = true
        self.actionButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.background.bottomAnchor.constraint(equalTo: self.actionButton.bottomAnchor, constant: 18).isActive = true
        
        self.actionButtonLabel.centerYAnchor.constraint(equalTo: self.actionButton.centerYAnchor).isActive = true
        self.actionButtonLabel.centerXAnchor.constraint(equalTo: self.actionButton.centerXAnchor).isActive = true
        self.actionButtonLabel.widthAnchor.constraint(equalTo: self.actionButton.widthAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let panelTitle = title1 {
            titleView.text = panelTitle
            //titleView.layer.borderColor = UIColor.black.cgColor
            //titleView.layer.borderWidth = 2
        }
        
        if let panelImage = mainImage {
            mainImageView = panelImage
        }
        
        if let panelButton = actionButtonTitle {
            actionButtonLabel.text = panelButton
        }
        
        if let panelType = panelType {
            if (panelType == "product"){
                iconImageForTile.image = #imageLiteral(resourceName: "TileIcon_Tag")
            }else if (panelType == "collection"){
                iconImageForTile.image = #imageLiteral(resourceName: "TileIcon_Tag")
            }else if (panelType == "article"){
                iconImageForTile.image = #imageLiteral(resourceName: "TileIcon_Book")
            }else if (panelType == "quote"){
                iconImageForTile.image = #imageLiteral(resourceName: "TileIcon_Quote")
            }else if (panelType == "community"){
                iconImageForTile.image = #imageLiteral(resourceName: "TileIcon_Community")
            }else if (panelType == "training"){
                iconImageForTile.image = #imageLiteral(resourceName: "TileIcon_LightBulb")
            }
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        
        //print("selected")
        
        // Configure the view for the selected state
    }
    
    func setImageForCell(url: String, completion: @escaping (_ success: Bool) -> Void){
        /*mainImageView.loadImage(urlString: url){ success in
            completion(success)
        }*/
        if let urlImage = URL(string: url){
            mainImageView.af_setImage(withURL: urlImage, placeholderImage: #imageLiteral(resourceName: "marketLoadingPlace"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: true){
                complete in
                if(complete.result.isSuccess){
                }else{
                    print(complete.error.debugDescription)
                    print(urlImage)
                }
            }
        }
        
        completion(true)
    }
    
    func getHeight() -> CGFloat {
        return self.frame.height
    }
}

