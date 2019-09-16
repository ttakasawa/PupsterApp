//
//  WelcomeVC.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/7/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import SnapKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import SafariServices

class WelcomeVC: UIViewController {
    
    fileprivate enum Statements: String {
        case title = "PUPSTER"
        case subtitle = "Dog parenting\nmade simple."
        case first = "Message Pupster Certified\nExperts for help with your dog."
        case second = "Track your pup’s activity and\nreceive personalized advice."
        case third = "Train your dog at home with our\nscience based program."
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    
    @IBOutlet weak var statementsStack: UIStackView!
    @IBOutlet weak var firstStatementLbl: UILabel!
    @IBOutlet weak var secondStatementLbl: UILabel!
    @IBOutlet weak var thirdStatementLbl: UILabel!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var subTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var subTitleBottomConstraint: NSLayoutConstraint!
    
    let authPopup = AuthPopup.init(frame: CGRect.zero)
    var blurEffectView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func configureUI() {
        setupLabels()
        setupButtons()
        configureBlurEffect()
        configureAuthPopup()
    }
    
    func setupButtons() {
        
        signUpBtn.setAttributedTitle(
            NSMutableAttributedString(string: "SIGN UP", attributes:
                [.font: UIFont.systemFont(ofSize: 15, weight: .bold)]), for: .normal)
        signUpBtn.backgroundColor = UIColor(0xFF3266)
        signUpBtn.titleLabel?.textColor = UIColor.white
        signUpBtn.layer.cornerRadius = 24
        loginBtn.setAttributedTitle(
            NSMutableAttributedString(string: "LOG IN", attributes:
                [.font: UIFont.systemFont(ofSize: 15, weight: .bold)]), for: .normal)
        loginBtn.backgroundColor = UIColor.white
        loginBtn.titleLabel?.textColor = UIColor(0x64626F)
        loginBtn.layer.cornerRadius = 24
    }
    
    func setupLabels() {
        var titleFontSize: CGFloat = 31
        var statementFontSize: CGFloat = 18
        
        if height.isLessThan(.eightHeight) {
            titleFontSize = 24
            statementFontSize = 14
            statementsStack.spacing = 20
            subTitleTopConstraint.constant = 20
            subTitleBottomConstraint.constant = 10
        }
        
        titleLbl.attributedText =
            NSMutableAttributedString(string: Statements.title.rawValue, attributes:
                [.font: UIFont.systemFont(ofSize: titleFontSize, weight: .heavy)])
        subtitleLbl.attributedText =
            NSMutableAttributedString(string: Statements.subtitle.rawValue, attributes:
                [.font: UIFont.systemFont(ofSize: titleFontSize, weight: .heavy)])
        
        
        firstStatementLbl.attributedText =
            NSMutableAttributedString(string: Statements.first.rawValue, attributes:
                [.font: UIFont.systemFont(ofSize: statementFontSize, weight: .medium)])
        secondStatementLbl.attributedText =
            NSMutableAttributedString(string: Statements.second.rawValue, attributes:
                [.font: UIFont.systemFont(ofSize: statementFontSize, weight: .medium)])
        thirdStatementLbl.attributedText =
            NSMutableAttributedString(string: Statements.third.rawValue, attributes:
                [.font: UIFont.systemFont(ofSize: statementFontSize, weight: .medium)])
    }
    
    func configureAuthPopup() {
        
        authPopup.emailTappedCallback = emailTappedCallback(_:)
        authPopup.facebookTappedCallback = { _ in
            self.dismissAuthPopup()
            self.facebookLoginTapped()
        }
        authPopup.cancelTappedCallback = dismissAuthPopup
        authPopup.termsOfUseTappedCallback = showTermsAndConditions
        
        self.view.addSubview(authPopup)
        authPopup.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(AuthPopup.normalHeight)
            make.top.equalTo(view.snp.bottom).offset(18.0)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
    
    func emailTappedCallback(_ process: AuthProcess) {
        let flowVC: LoginFlowVC!
        switch process {
        case .login:
            flowVC = EmailLoginVC.init(nibName: nil, bundle: nil)
        case .signup:
            flowVC = SignUpEmailVC.init(nibName: nil, bundle: nil)
        }
        self.present(flowVC, animated: true, completion: { [weak self] in
            self?.dismissAuthPopup()
        })
    }
    
    func showAuthPopup() {
        blurEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.signUpBtn.alpha = 0
            strongSelf.loginBtn.alpha = 0
            strongSelf.blurEffectView.alpha = 0.96
            strongSelf.authPopup.snp.updateConstraints { make in
                make.top.equalTo(strongSelf.view.snp.bottom).offset(-AuthPopup.normalHeight)
            }
            strongSelf.view.layoutIfNeeded()
        }
    }
    
    func dismissAuthPopup() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.signUpBtn.alpha = 1.0
            strongSelf.loginBtn.alpha = 1.0
            strongSelf.blurEffectView.alpha = 0.0
            
            strongSelf.authPopup.snp.updateConstraints { make in
                make.top.equalTo(strongSelf.view.snp.bottom).offset(18.0)
            }
            strongSelf.view.layoutIfNeeded()
        }, completion: { [weak self] (isCompleted) in
            guard let strongSelf = self else { return }
            strongSelf.blurEffectView.isHidden = true
        })
    }
    
    func configureBlurEffect() {
        let effect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: effect)
        blurEffectView.isHidden = true
        blurEffectView.alpha = 0
        self.view.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(view.snp.size)
            make.center.equalTo(view.snp.center)
        }
    }
    
    func showTermsAndConditions() {
        guard let url = URL(string: "https://thepupster.com/terms-of-service/") else {
            return
        }
        
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    
    func facebookLoginTapped() {
        let facebookLogin = FBSDKLoginManager()
        
        if let currentAccessToken = FBSDKAccessToken.current(), currentAccessToken.appID != FBSDKSettings.appID()
        {
            facebookLogin.logOut()
        }
        
        // MARK:- Sign In with facebook.
        facebookLogin.logIn(withReadPermissions: ["email","public_profile"], from: self) { (facebookResult, facebookError) in
            if facebookError != nil {
                
                self.showAlert(title: "Error", message: "Facebook login failed. Error \(facebookError.debugDescription)")
                
            } else if (facebookResult?.isCancelled)! {

                self.showAlert(title: "Error", message: "Facebook login was cancelled")
            } else {
                // Sign in to Firebase with facebook credential.
                self.showLoading()
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
                    if let error = error {
                        self.hideLoading()
                        if let name = (error as NSError).userInfo["error_name"] as? String {
                            if name == "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL" {
                                print("differet strategy")
                                //here
                                if let email = (error as NSError).userInfo["FIRAuthErrorUserInfoEmailKey"] as? String {
                                    Auth.auth().fetchProviders(forEmail: email, completion: { (providers, error) in
                                        if error != nil {
                                            self.showAlert(title: "Error", message: "Failed to get authentication provider.")
                                        }
                                        if let provider = providers?.first, provider == "password" {
                                            self.promptForPassword(completion: { password in
                                                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                                                    if error != nil {
                                                        self.showAlert(title: "Error", message: "Password is not correct.")
                                                    }
                                                    if let authUser = Auth.auth().currentUser {
                                                        authUser.linkAndRetrieveData(with: credential, completion: { (user, error) in
                                                            if let error = error {
                                                                print (error)
                                                                self.showAlert(title: "Error", message: "Password is not correct.")
                                                            }else{
                                                                self.continueFacebookSignIn(firUser: authUser)
                                                            }
                                                        })
                                                    }
                                                })
                                            })
                                        }
                                    })
                                }
                            }
                        }else{
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    } else if let user = result?.user {
                        self.continueFacebookSignIn(firUser: user)
                    } else {
                        self.hideLoading()
                        self.showAlert(title: "Error", message: "Failed to get user.")
                    }
                })
            }
        }
    }
    
    func promptForPassword(completion: @escaping (_ password: String) -> Void) {
        let alert = UIAlertController(title: "Link Your Email", message: "We found an account with the same email address, enter your password below to link these accounts.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter password..."
        }
        alert.addAction(UIAlertAction(title: "Link Email Accounts", style: .default) { action in
            if let password = alert.textFields?.first?.text {
                completion(password)
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func continueFacebookSignIn(firUser: User) {
//        print(firUser)
//
        Global.network.queryUser(completion: { (user: UserData?, error: Error?) in
            
            self.hideLoading()
            

            if let user = user {
                Global.network.user = user
                self.finishLoginFlow()

            }else{
                self.handleFacebookLoginWithNoAccount(firUser: firUser)
            }
        })

    }
    
    func handleFacebookLoginWithNoAccount(firUser: User) {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, id, first_name, last_name, picture.width(300).height(300)"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET").start { (connection, result, error) in
            
            let localUser = PUser(uid: firUser.uid)
            
            if let dict = result as? Dictionary<String,AnyObject> {
                if let firstName = dict["first_name"] as? String,
                    let lastName = dict["last_name"] as? String {
                    localUser.firstName = firstName
                    localUser.lastName = lastName
                }
                // CODE IF YOU WANT TO GET PROFILE PIC
//                if let profilePictureDict = dict["picture"] as? Dictionary<String, AnyObject> {
//                    if let data = profilePictureDict["data"] as? Dictionary<String, AnyObject> {
//                        if let pictureURLString = data["url"] as? String {
//                            let pictureURL = URL.init(string: pictureURLString)
//                            localUser.profileImageURL = pictureURL
//                        }
//                    }
//                }
                
                if let email = dict["email"] as? String {
                    localUser.email = email
                }
            }
            
            PUser.save(localUser)
            
            self.hideLoading()
            self.present(DogNameGenderVC.init(nibName: nil, bundle: nil), animated: true, completion: nil)
        }
        
        
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        authPopup.configure(process: .signup)
        showAuthPopup()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        authPopup.configure(process: .login)
        showAuthPopup()
    }
    
}

extension WelcomeVC: LoadingHandling {
    func recovery() {}
}

extension WelcomeVC: DashBoardPresentable {
    /**
     Opens whatever you want to be after login flow
     */
    func finishLoginFlow() {
        //        guard let currentUser = PUser.current else { return }
        //
        //        // -- Here we have our user
        //        print(currentUser.fullName)
        //        print(currentUser.serialize())
        //
        //        guard let currentDog = PDog.current else { return }
        //
        //        // -- Here we have our dog
        //
        //        print(currentDog.name)
        //        print(currentDog.serialize())
        //        print(currentDog.age.intervalString)
        
        self.presentDashBoard()
    }
}




