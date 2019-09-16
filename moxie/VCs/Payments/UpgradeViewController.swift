//
//  UpgradeViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import BubbleTransition

class UpgradeViewController: UIViewController, Stylable, UIViewControllerTransitioningDelegate {
    
    let transition = BubbleTransition()
    var network: UserType
    var user: UserData
    var dismissButton: UIButton!
    var toPaymentButton: DashBoardButton!
    
    let scrollView = UIScrollView()
    let baseView = UIView()
    private var gradient: CAGradientLayer!
    
    var subscriptionInfo = """
        Pupster Membership Details
        • 1-month recurring subscription:
               Basic: Pupster Program, $9.99/month.
               Plus: Pupster Program and 1 video chat, $39.99/month.
               Premium: Pupster program and 4 video chats, $99.99/month.
        • Payment will be charged to iTunes Account at confirmation of purchase.
        • Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.
        • Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal.
        • Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase.
    """
    
    init(network: TypeNetwork, user: UserData) {
        self.network = network
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientView = FourGradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gradientView)
        gradientView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        gradientView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.setGradient(view: gradientView)
        
        let infoImage = #imageLiteral(resourceName: "UpgradeIntroduction")
        let infoView = UIImageView(image: infoImage)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(infoView)
        
        if (DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5) {
            infoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        }else{
            infoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        }
        
        infoView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        infoView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        infoView.heightAnchor.constraint(equalTo: infoView.widthAnchor, multiplier: 1).isActive = true
        
        dismissButton = UIButton()
        dismissButton.backgroundColor = .clear
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setTitle("Not Now", for: .normal)
        dismissButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 17)!
        dismissButton.setTitleColor(.white, for: .normal)
        
        self.view.addSubview(dismissButton)
        dismissButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        dismissButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -23).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        toPaymentButton = DashBoardButton(title: "CHOOSE YOUR PLAN")
        toPaymentButton.configureStyle(style: DashBoardMainButtonStyle(themeColor: self.getWhiteColor()))
        toPaymentButton.setTitleColor(self.getMainColor(), for: .normal)
        toPaymentButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toPaymentButton)
        
        let infoLabel = TileLabel(text: self.subscriptionInfo, style: TileLabelStyling(font: self.getSmallFont(), color: self.getWhiteColor()))
        infoLabel.numberOfLines = 0
        
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.backgroundColor = .clear
        
        
        
        self.view.addSubview(baseView)
        baseView.addSubview(scrollView)
        scrollView.addSubview(infoLabel)
        
        
        toPaymentButton.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -30).isActive = true
        toPaymentButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 23).isActive = true
        toPaymentButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -23).isActive = true
        toPaymentButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        dismissButton.addTarget(self, action: #selector(self.dismissPressed), for: .touchUpInside)
        toPaymentButton.addTarget(self, action: #selector(self.toPayments), for: .touchUpInside)
        
        
        
        
        baseView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        baseView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        baseView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        baseView.heightAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 61.0/329.0).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: baseView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: baseView.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: baseView.rightAnchor).isActive = true
        
        infoLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 3).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        infoLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        infoLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -48).isActive = true
        
        
        //infoLabel.heightAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        gradient = CAGradientLayer()
        gradient.frame = baseView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.1, 0.9, 1]
        baseView.layer.mask = gradient
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.frame = baseView.bounds
    }
    
    func setGradient(view: FourGradientView){
        view.firstColor = UIColor(red:0.53, green:0.84, blue:1, alpha:1)
        view.secondColor = UIColor(red:0.3, green:0.82, blue:1, alpha:1)
        view.thirdColor = UIColor(red:0.38, green:0.85, blue:1, alpha:1)
        view.fourthColor = UIColor(red:0.09, green:0.38, blue:1, alpha:1)
        
        view.firstLocation = 0
        view.secondLocation = 0.28833094
        view.thirdLocation = 0.5405136
        view.fourthLocation = 1
    }
    
    @objc func dismissPressed(){
        //        if let baseVC = self.pupserBase {
        //            baseVC.updateDashBoards()
        //        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func toPayments(){
        let vc = SubscriptionViewController(network: self.network, user: self.user)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.startingPoint = toPaymentButton.center
        transition.transitionMode = .present
        transition.bubbleColor = self.getSecondaryColor()
        
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = toPaymentButton.center
        transition.bubbleColor = self.getSecondaryColor()
        return transition
    }
}

extension Stylable where Self: UpgradeViewController {
    func getSecondaryColor() -> UIColor {
        return UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    }
}


class FourGradientView: UIView {
    var firstColor:   UIColor = .black { didSet { updateColors() }}
    var secondColor:  UIColor = .black { didSet { updateColors() }}
    var thirdColor:   UIColor = .black { didSet { updateColors() }}
    var fourthColor:     UIColor = .white { didSet { updateColors() }}
    
    var firstLocation: Double =   0 { didSet { updateLocations() }}
    var secondLocation: Double =   0.28833094 { didSet { updateLocations() }}
    var thirdLocation: Double =   0.5405136 { didSet { updateLocations() }}
    var fourthLocation:   Double =   1 { didSet { updateLocations() }}
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.19)
        gradientLayer.endPoint = CGPoint(x: 0.18, y: 1.03)
    }
    func updateLocations() {
        //gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
        gradientLayer.locations = [firstLocation as NSNumber, secondLocation as NSNumber, thirdLocation as NSNumber, fourthLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor,    fourthColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}
