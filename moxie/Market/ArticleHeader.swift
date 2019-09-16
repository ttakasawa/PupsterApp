//
//  ArticleHeader.swift
//  Testing
//
//  Created by Tomoki Takasawa on 6/8/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit


class ArticleHeader: UITableViewCell {
    
    var title: String?
    var header: String?
    var author: String?
    var authorAdditional: String?
    var authorImage: UIImage?
    
    let background: UIView = {
        let b = UIView()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor.white
        
        return b
    }()
    
    let titleTextView: UITextView = {
        let t = UITextView()
        //c.translatesAutoresizingMaskIntoConstraints = false
        //t.numberOfLines = 0
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = UIFont.init(name: "AvenirNext-Medium", size: 20)
        t.textColor = UIColor.black
        t.textAlignment = .left
        t.isScrollEnabled = false
        t.isEditable = false
        
        return t
    }()
    
    let headerTextView: UITextView = {
        let t = UITextView()
        //c.translatesAutoresizingMaskIntoConstraints = false
        //t.numberOfLines = 0
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = UIFont.init(name: "AvenirNext-Medium", size: 16)
        t.textColor = UIColor.black
        t.textAlignment = .left
        t.isScrollEnabled = false
        t.isEditable = false
        
        
        return t
    }()
    
    let authorTextView: UITextView = {
        let t = UITextView()
        //c.translatesAutoresizingMaskIntoConstraints = false
        //t.numberOfLines = 0
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = UIFont.init(name: "AvenirNext-Medium", size: 16)
        t.textColor = UIColor.black
        t.textAlignment = .left
        t.isScrollEnabled = false
        t.isEditable = false
        t.backgroundColor = UIColor.clear
        
        return t
    }()
    
    let authorAdditionalTextView: UITextView = {
        let t = UITextView()
        //c.translatesAutoresizingMaskIntoConstraints = false
        //t.numberOfLines = 0
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = UIFont.init(name: "AvenirNext-Medium", size: 16)
        t.textColor = UIColor.black
        t.textAlignment = .left
        t.isScrollEnabled = false
        t.isEditable = false
        t.backgroundColor = UIColor.clear
        
        return t
    }()
    
    let authorImageView: UIImageView = {
        let a = UIImageView()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.contentMode = .scaleAspectFit
        a.layer.cornerRadius = 20
        a.clipsToBounds = true
        
        return a
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 0.39)
        
        
        self.addSubview(background)
        self.background.addSubview(titleTextView)
        self.background.addSubview(headerTextView)
        self.background.addSubview(authorTextView)
        self.background.addSubview(authorAdditionalTextView)
        self.background.addSubview(authorImageView)
        
        
        self.background.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.background.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.background.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        self.titleTextView.topAnchor.constraint(equalTo: self.background.topAnchor, constant: 15).isActive = true
        self.titleTextView.leftAnchor.constraint(equalTo: self.background.leftAnchor, constant: 18).isActive = true
        self.titleTextView.rightAnchor.constraint(equalTo: self.background.rightAnchor, constant: -18).isActive = true
        //self.titleTextView.bottomAnchor.constraint(equalTo: self.background.bottomAnchor, constant: -15).isActive = true
        
        self.headerTextView.topAnchor.constraint(equalTo: self.titleTextView.bottomAnchor, constant: 10).isActive = true
        self.headerTextView.leftAnchor.constraint(equalTo: self.titleTextView.leftAnchor).isActive = true
        self.headerTextView.rightAnchor.constraint(equalTo: self.titleTextView.rightAnchor).isActive = true
        
        self.authorImageView.topAnchor.constraint(equalTo: self.headerTextView.bottomAnchor, constant: 18).isActive = true
        self.authorImageView.leftAnchor.constraint(equalTo: self.headerTextView.leftAnchor).isActive = true
        self.authorImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.authorImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.authorTextView.topAnchor.constraint(equalTo: self.authorImageView.topAnchor, constant: -5).isActive = true
        self.authorTextView.leftAnchor.constraint(equalTo: self.authorImageView.rightAnchor, constant: 10).isActive = true
        self.authorTextView.rightAnchor.constraint(equalTo: self.titleTextView.rightAnchor).isActive = true
        
        self.authorAdditionalTextView.topAnchor.constraint(equalTo: self.authorTextView.bottomAnchor, constant: -20).isActive = true
        self.authorAdditionalTextView.leftAnchor.constraint(equalTo: self.authorImageView.rightAnchor, constant: 10).isActive = true
        self.authorAdditionalTextView.rightAnchor.constraint(equalTo: self.titleTextView.rightAnchor).isActive = true
        
        self.background.bottomAnchor.constraint(equalTo: self.authorAdditionalTextView.bottomAnchor, constant: 20).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let title = title {
            titleTextView.text = title
        }
        if let header = header{
            headerTextView.text = header
        }
        if let author = author{
            authorTextView.text = author
        }
        if let authorAdditional = authorAdditional{
            authorAdditionalTextView.text = authorAdditional
        }
        
    }
    
    func setImages(url: String, completion: @escaping(_ success: Bool)->Void){
        if let urlImage = URL(string: url){
            authorImageView.af_setImage(withURL: urlImage, placeholderImage: #imageLiteral(resourceName: "marketLoadingPlace"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: true){
                complete in
                completion(complete.result.isSuccess)
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
}
