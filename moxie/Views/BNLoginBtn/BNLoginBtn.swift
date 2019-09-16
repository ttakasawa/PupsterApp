//
//  LoginGoogleBtn.swift
//  BikeNav
//
//  Created by Tymofii Dolenko on 6/8/18.
//  Copyright © 2018 BikeNav. All rights reserved.
//

import UIKit

enum ThirdPartyLoginType {
    case facebook
    case google
}

class BNLoginBtn: TappableView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var logoLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    var type: ThirdPartyLoginType = .facebook {
        didSet {
            updateButtonType()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BNLoginBtn", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        setupLayer()
    }
    
    func configure(type: ThirdPartyLoginType) {
        self.type = type
    }
    
    func setupLayer() {
        layer.cornerRadius = 28
        layer.masksToBounds = true
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.2).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 2
    }
    
    func updateButtonType() {
        switch type {
        case .facebook:
            let attributedString = NSMutableAttributedString(string: "Facebook", attributes: [
                .font: UIFont.systemFont(ofSize: 15.0, weight: .bold),
                .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
                .kern: 0.0
                ])
            titleLbl.attributedText = attributedString
            logoLbl.text = ""
            contentView.backgroundColor = UIColor(0x3A5999)
        case .google:
            let attributedString = NSMutableAttributedString(string: "Google", attributes: [
                .font: UIFont.systemFont(ofSize: 15.0, weight: .bold),
                .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
                .kern: 0.0
                ])
            titleLbl.attributedText = attributedString
            logoLbl.text = "google"
            contentView.backgroundColor = UIColor(0x4285F4)
        }
    }
    
    override func setHighlighted(_ highlighted: Bool) {
        let alpha: CGFloat = highlighted ? 0.25 : 1.0
        UIView.animate(withDuration: 0.1) {
            self.titleLbl.alpha = alpha
            self.logoLbl.alpha = alpha
        }
    }

}
