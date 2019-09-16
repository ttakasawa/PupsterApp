//
//  AuthPopup.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/8/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

enum AuthProcess {
    case login
    case signup
}

class AuthPopup: UIView {
    
    static let normalHeight: CGFloat = 291.0
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var termsOfUserView: TermsOfUseView!
    @IBOutlet weak var facebookLoginBtn: BNLoginBtn!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var termsOfUseTappedCallback: (()->())?
    var facebookTappedCallback: ((AuthProcess)->())?
    var emailTappedCallback: ((AuthProcess)->())?
    var cancelTappedCallback: (()->())?
    
    var currentProcess: AuthProcess = .signup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AuthPopup", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        configureUI()
    }
    
    func configure(process: AuthProcess) {
        self.currentProcess = process
        switch process {
        case .signup:
            UIView.performWithoutAnimation {
                signUpBtn.setTitle("SIGN UP WITH EMAIL", for: .normal)
                layoutIfNeeded()
            }
            termsOfUserView.isHidden = false
        case .login:
            UIView.performWithoutAnimation {
                signUpBtn.setTitle("LOG IN WITH EMAIL", for: .normal)
                layoutIfNeeded()
            }
            termsOfUserView.isHidden = true
        }
    }
    
    func configureUI() {
        termsOfUserView.tappedCallback = { [weak self] in
            self?.termsOfUseTappedCallback?()
        }
        setupButtons()
    }
    
    func setupButtons() {
        facebookLoginBtn.configure(type: .facebook)
        facebookLoginBtn.tappedCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.facebookTappedCallback?(strongSelf.currentProcess)
        }
        configureSignUpBtn()
    }
    
    func configureSignUpBtn() {
        signUpBtn.layer.cornerRadius = signUpBtn.frame.height / 2
        signUpBtn.layer.masksToBounds = true
        signUpBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
        signUpBtn.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.2).cgColor
        signUpBtn.layer.shadowOpacity = 1
        signUpBtn.layer.shadowRadius = 2
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        cancelTappedCallback?()
    }
    
    @IBAction func emailTapped(_ sender: Any) {
        emailTappedCallback?(currentProcess)
    }
    

}
