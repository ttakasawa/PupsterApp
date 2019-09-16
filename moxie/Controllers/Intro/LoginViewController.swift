//
//  LoginViewController.swift
//  moxie
//
//  Created by ZacharyH on 1/28/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import SCLAlertView

class LoginViewController: UIViewController, ErrorHandling, LoginHandling {
    
    @IBOutlet weak var emailView: RoundedView!
    @IBOutlet weak var passwordView: RoundedView!
    
    @IBOutlet weak var ForgotPassword: UILabel!
    var user: UserDataDepricated?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInfo()
        //self.configureTouchId()
        
        self.emailView.field?.text = self.user?.email
        self.passwordView.field?.text = self.user?.password
        
        let tapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.showEmail(recognizer:)))
        
        tapped.numberOfTapsRequired = 1
        ForgotPassword.addGestureRecognizer(tapped)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if let _ = FBSDKAccessToken.current() {
//            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email"])
//            let _ = request?.start(completionHandler: { (_, result, error) in
//                if let error = error {
//                    print(error)
//                }
//                self.user = UserDataDepricated()
//                if let result = result as? Dictionary<String, String> {
//                    self.emailView.field?.text = result["email"]
//                    self.user?.email = result["email"]
//                }
//                self.saveInfo()
//            })
//        }
        self.loadInfo()
    }

    var errorBlock: (_ error: Error?) -> Void = { error in
        print("error")
    }

    @IBAction func dismissLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: ShadowButton) {
        sender.isUserInteractionEnabled = false
        guard let email = self.emailView.validText() else {
            self.showAlert(title: "Email", message: "Invalid Email")
            sender.isUserInteractionEnabled = true
            return
        }
        
        guard let password = self.passwordView.validText() else {
            self.showAlert(title: "Password", message: "Password min length 8 characters")
            sender.isUserInteractionEnabled = true
            return
        }
        
        self.user?.email = email
        self.user?.password = password

        UserManager.shared.authenticate(email: email, password: password) { (success) in
            if success {
                self.loginSuccess()
                self.saveInfo()
                self.dismiss(animated: true, completion: nil)
                //MustDo
//                UserManager.shared.setUserLogInStatus(){ last in
//                    print("background updated from loginviewcontroller.swift")
//
//                    //CHECK: login done
//                    if (last == 0){
//                        print("impossible, I think.. But just in case")
//                        let sb = UIStoryboard(name: "Main", bundle: nil)
//                        let vc = sb.instantiateViewController(withIdentifier: "tabBar")
//                        if let window = UIApplication.shared.keyWindow {
//                            window.rootViewController = vc
//                        }
//                    }else{
//                        let sb = UIStoryboard(name: "Main", bundle: nil)
//                        let vc = sb.instantiateViewController(withIdentifier: "tabBar")
//                        if let window = UIApplication.shared.keyWindow {
//                            window.rootViewController = vc
//                        }
//                    }
//                }
            }else{
                sender.isUserInteractionEnabled = true
                let authFailed = UIAlertController(title: "Authentication failed.", message: "Either email or password is wrong!", preferredStyle: UIAlertControllerStyle.alert)
                authFailed.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(authFailed, animated: true, completion: nil)
            }
        }
    }

    @IBAction func facebookPressed(_ sender: UIButton) {
        
    }
    
    @objc func showEmail(recognizer: UITapGestureRecognizer){
        
        
        let alert = SCLAlertView()
        let txt = alert.addTextField("Enter your email")
        alert.addButton("Confirm") {
            
            let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
            
            let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
            if emailTest.evaluate(with: txt.text) == false{
                print("not an email")
                self.showAlert(title: "Email", message: "Invalid Email")
                return
            }else{
                print("email confirmed")
                if let emailAddress: String = txt.text {
                    UserManager.shared.forgotPasswordHandling(email: emailAddress){
                        success in
                        
                        if success {
                            print("email should have been sent")
                            let confirmPopup = SCLAlertView()
                            confirmPopup.showSuccess("success!", subTitle: "Please check out your email!!")
                            
                        }else{
                            let show = UIAlertController(title: "Forgot your password?", message: "Email us at hello@thepupster.com to reset your password", preferredStyle: UIAlertControllerStyle.alert)
                            show.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(show, animated: true, completion: nil)
                        }
                    }
                }
                
            }
            
        }
        alert.showEdit("Reset password", // Title of view
            subTitle: "We will sed you an email with a link that enables you to create a new password.", closeButtonTitle: "Cancel")
        
        
        
    }
}
