//
//  ProgramContentsTableViewCell.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/8/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

extension Stylable where Self: ProgramContentsTableViewCell{
    func getSubTitleFont() -> UIFont {
        return UIFont(name: "SFProText-Heavy", size: 16)!
    }
    
    func getSecondaryColor() -> UIColor {
        return UIColor(red:0.87, green:0.87, blue:0.87, alpha:1)
    }
}

class ProgramContentsTableViewCell: UITableViewCell, Stylable {
    
    var title: String?
    var isCompleted: Bool?
    
    var cellType: ProgramContentsType?
    
    let titleLabel = UILabel()
    var completionLabel = UILabel()
    var separator = UIView()
    var completionStatusLabel = UILabel()
    
    var tile = DashBoardCell()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = UIViewAutoresizing.flexibleHeight
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        
        
        tile.configureTileStyle()
        tile.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = self.getSubTitleFont()
        titleLabel.textColor = self.getTextColor()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 0
        
        completionLabel.translatesAutoresizingMaskIntoConstraints = false
        completionLabel.font = self.getSubTitleFont()
        completionLabel.textColor = self.getMainColor()
        
        completionLabel.text = "STATUS"
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = self.getTextColor()
        
        completionStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        completionStatusLabel.font = self.getSubTitleFont()
        completionStatusLabel.textColor = self.getTextColor()
        completionStatusLabel.adjustsFontSizeToFitWidth = true
        
        
        self.addSubview(tile)
        
        tile.addSubview(titleLabel)
        tile.addSubview(completionLabel)
        tile.addSubview(separator)
        tile.addSubview(completionStatusLabel)
        
        
        tile.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        tile.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        tile.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        tile.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        //titleLabel.topAnchor.constraint(equalTo: tile.topAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: tile.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: tile.leftAnchor, constant: 18).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: separator.leftAnchor, constant: -18).isActive = true
        
        separator.widthAnchor.constraint(equalToConstant: 94).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 3).isActive = true
        separator.rightAnchor.constraint(equalTo: tile.rightAnchor, constant: -16).isActive = true
        //separator.centerYAnchor.constraint(equalTo: tile.centerYAnchor).isActive = true
        
        completionLabel.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -5).isActive = true
        completionLabel.rightAnchor.constraint(equalTo: separator.rightAnchor).isActive = true
        completionLabel.topAnchor.constraint(equalTo: tile.topAnchor, constant: 13).isActive = true
        
        completionStatusLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 5).isActive = true
        completionStatusLabel.bottomAnchor.constraint(equalTo: tile.bottomAnchor, constant: -13).isActive = true
        completionStatusLabel.rightAnchor.constraint(equalTo: separator.rightAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let title = self.title {
            titleLabel.text = title
        }
        
        if let isCompleted = self.isCompleted {
            self.completionStatusLabel.text = isCompleted ? "Completed" : "To Do"
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
