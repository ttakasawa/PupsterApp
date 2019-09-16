//
//  SignupViewController.swift
//  moxie
//
//  Created by ZacharyH on 1/28/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, ErrorHandling, LoginHandling {

    var user: UserDataDepricated?
    
    @IBOutlet weak var firstNameField: RoundedView!
    @IBOutlet weak var lastNameField: RoundedView!
    @IBOutlet weak var emailField: RoundedView!
    @IBOutlet weak var passwordField: RoundedView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    var errorBlock: (_ error: Error?) -> Void = { error in
        print("error")
    }

    @IBAction func dismissLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountPressed(_ sender: ShadowButton) {
        guard let firstName = self.firstNameField.validText() else {
            self.showAlert(title: "Required Field", message: "Invalid First Name")
            return
        }

        guard let lastName = self.lastNameField.validText() else {
            self.showAlert(title: "Required Field", message: "Invalid Last Name")
            return
        }

        guard let email = self.emailField.validText() else {
            self.showAlert(title: "Invalid Value", message: "Please enter valid email")
            return
        }
        
        guard let password = self.passwordField.validText() else {
            self.showAlert(title: "Minimum Length", message: "Password min length 8 characters")
            return
        }
        
        self.user = UserDataDepricated()
        self.user?.email = email
        self.user?.password = password
        self.user?.firstName = firstName
        self.user?.lastName = lastName
        
        //self.loginSuccess()
        self.loginSuccess()
        self.saveInfo()
    }
    
    @IBAction func facebookSignup(_ sender: ShadowButton) {
//        if let _ = FBSDKAccessToken.current() {
//            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email"])
//            let _ = request?.start(completionHandler: { (_, result, error) in
//                if let error = error {
//                    print(error)
//                }
//                self.user = UserDataDepricated()
//                if let result = result as? Dictionary<String, String> {
//                    self.user?.email = result["email"]
//                    self.emailField.field?.text = result["email"]
//                }
//                self.saveInfo()
//            })
//        }
    }

    @IBAction func termsOfServicePressed(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TermsPolicy")
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func privacyPolicyPressed(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TermsPolicy")
        present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        if let doginfo = segue.destination as? DogInfoViewController {
//            doginfo.user = self.user
//        }
    }
    
}
