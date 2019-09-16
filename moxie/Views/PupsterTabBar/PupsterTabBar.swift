//
//  PupsterTabBar.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/19/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

enum PupsterTab {
    case activites
    case tracking
    case products
}

class PupsterTabBar: UIView {

    @IBOutlet var view: UIView!
    
    var tabLayer = CAShapeLayer()
    
    @IBOutlet weak var trackingImageview: UIImageView!
    @IBOutlet weak var trackingLbl: UILabel!
    
    @IBOutlet weak var activitiesLbl: UILabel!
    @IBOutlet weak var activitiesImageview: UIImageView!
    
    @IBOutlet weak var productsLbl: UILabel!
    @IBOutlet weak var productsImageview: UIImageView!
    
    var tabCallback: ((PupsterTab)->())?
    
    var selectedTab: PupsterTab = .tracking
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func setSelected(tab: PupsterTab) {
        selectedTab = tab
        
        let selectedColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
        let defaultColor = UIColor(red:0.39, green:0.38, blue:0.44, alpha:1)
        
        trackingImageview.image = tab == .tracking ? #imageLiteral(resourceName: "trophy-selected") : #imageLiteral(resourceName: "trophy")
        trackingLbl.textColor = tab == .tracking ? selectedColor : defaultColor
        
        activitiesImageview.image = tab == .activites ? #imageLiteral(resourceName: "cards-selected") : #imageLiteral(resourceName: "cards")
        activitiesLbl.textColor = tab == .activites ? selectedColor : defaultColor
        
        productsImageview.image = tab == .products ? #imageLiteral(resourceName: "tag-cut-selected") : #imageLiteral(resourceName: "tag-cut")
        productsLbl.textColor = tab == .products ? selectedColor : defaultColor
    }
    
    @IBAction func activitiesTapped(_ sender: Any) {
        setSelected(tab: .activites)
        tabCallback?(selectedTab)
    }
    
    @IBAction func productsTapped(_ sender: Any) {
        setSelected(tab: .products)
        tabCallback?(selectedTab)
    }
    
    @IBAction func trackingTapped(_ sender: Any) {
        setSelected(tab: .tracking)
        tabCallback?(selectedTab)
    }
    
}

extension PupsterTabBar {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PupsterTabBar", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        configureUI()
    }
    
    override func layoutSubviews() {
        tabLayer.path = updateBezierPath(rect: view.bounds).cgPath
    }
    
    func configureUI() {
        view.layer.insertSublayer(tabLayer, at: 0)
        configureTabLayer()
    }
    
    func configureTabLayer() {
        tabLayer.occupation = view.layer.occupation
        tabLayer.path = updateBezierPath(rect: view.bounds).cgPath
        tabLayer.fillColor = UIColor.white.cgColor
        tabLayer.shadowOffset = CGSize(width: 0, height: -1)
        tabLayer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.3).cgColor
        tabLayer.shadowOpacity = 1
        tabLayer.shadowRadius = 2
    }
    
    func updateBezierPath(rect: CGRect) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: rect.minX + 0.59046 * rect.width, y: rect.minY + 15))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 15))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 15))
        bezierPath.addLine(to: CGPoint(x: rect.minX + 0.40533 * rect.width, y: rect.minY + 15))
        bezierPath.addCurve(to: CGPoint(x: rect.minX + 0.49867 * rect.width, y: rect.minY), controlPoint1: CGPoint(x: rect.minX + 0.42822 * rect.width, y: rect.minY + 5.77), controlPoint2: CGPoint(x: rect.minX + 0.46241 * rect.width, y: rect.minY))
        bezierPath.addCurve(to: CGPoint(x: rect.minX + 0.59046 * rect.width, y: rect.minY + 15), controlPoint1: CGPoint(x: rect.minX + 0.53492 * rect.width, y: rect.minY), controlPoint2: CGPoint(x: rect.minX + 0.56758 * rect.width, y: rect.minY + 5.77))
        bezierPath.close()
        return bezierPath
    }
}
