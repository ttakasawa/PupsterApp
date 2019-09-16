
//
//  EmailLoginVC.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/10/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import FirebaseAuth
import SCLAlertView

class EmailLoginVC: LoginFlowVC {
    

    fileprivate enum CurrentCell: Int {
        case title
        case email
        case password
        case forgot
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startInputIndex = IndexPath.init(row: CurrentCell.email.rawValue, section: 0)
        tableView.register(UINib.init(nibName: LFTextButtonCell.identifier, bundle: nil), forCellReuseIdentifier: LFTextButtonCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        continueButton.setTitle("LOG IN", for: .normal)
    }
    
    func proceedLogin() {
        view.endEditing(true)
        
        guard let emailCell = tableView.cellForRow(at:
            IndexPath.init(row: CurrentCell.email.rawValue, section: 0))
            as? LFFieldCell else {
                return
        }
        guard let email = emailCell.textField.text else {
            self.showAlert(title: "Error", message: "Email is invalid", completion: {
                emailCell.textField.becomeFirstResponder()
            })
            return
        }
        
        guard let passwordCell = tableView.cellForRow(at:
            IndexPath.init(row: CurrentCell.password.rawValue, section: 0))
            as? LFFieldCell else {
                return
        }
        guard let password = passwordCell.textField.text else {
            self.showAlert(title: "Error", message: "Password is invalid", completion: {
                passwordCell.textField.becomeFirstResponder()
            })
            return
        }
        
        self.showLoading()
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (auth, error) in
            
            guard let uid = auth?.user.uid else {
                self.hideLoading()
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "")
                return
            }
            
//            UserService.shared.getUserFromFirebase(uid: uid, completion: { (user, error) in
//                guard let user = user else {
//                    self.hideLoading()
//                    self.showAlert(title: "Error", message: "Failed to get user")
//                    return
//                }
//                PUser.save(user)
//                DogService.shared.getDogFromFirebase(id: user.dogId, completion: { (dog, error) in
//                    self.hideLoading()
//                    guard let dog = dog else {
//                        self.present(DogNameGenderVC.init(nibName: nil, bundle: nil), animated: true, completion: nil)
//                        return
//                    }
//                    PDog.save(dog)
//                    self.finishLoginFlow()
//                })
//            })
            
            Global.network.queryUser(completion: { (user: UserData?, error: Error?) in
                
                if let user = user {
                    self.hideLoading()
                    if error != nil { return }
                    Global.network.user = user
                    self.finishLoginFlow()
                }else {
                    self.hideLoading()
                    
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alert = SCLAlertView(appearance: appearance)
                    alert.addButton("CONTINUE", action: {
                        
                        self.presentLogIn()
                    })
                    alert.showInfo("Hey there 👋", subTitle: "We’ve upgraded Pupster to improve your experience, update your profile to check it out.")
                    
                }
            })
        })
    }
    
    func presentLogIn(){
        let email = Auth.auth().currentUser?.email
        let uid = Auth.auth().currentUser?.uid
        self.present(SignUpNameVC.init(email: email!, uid: uid!), animated: true, completion: nil)
//        let vc = UIStoryboard.init(name: "LoginFlow", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
//        self.present(vc, animated: true, completion: nil)
    }
    
    /**
     Opens whatever you want to be after login flow
     */
    
//    func finishLoginFlow() {
////        guard let currentUser = PUser.current else { return }
////
////        // -- Here we have our user
////        print(currentUser.fullName)
////        print(currentUser.serialize())
////
////        guard let currentDog = PDog.current else { return }
////
////        // -- Here we have our dog
////
////        print(currentDog.name)
////        print(currentDog.serialize())
////        print(currentDog.age.intervalString)
//
//
//    }
    
    func forgotPasswordTapped() {
        self.present(ForgotPasswordVC.init(nibName: nil, bundle: nil), animated: true, completion: nil)
    }
    
    @objc override func continueButtonTapped() {
        proceedLogin()
    }

}


extension EmailLoginVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentCell.forgot.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = CurrentCell.init(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch cellType {
        case .title:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFTitleCell.identifier, for: indexPath) as? LFTitleCell {
                cell.selectionStyle = .none
                cell.topMarginConstraint.constant = 0
                cell.bottomMarginConstraint.constant = 0
                cell.configure(title: "Enter your email and password\nto log in.", font: UIFont.systemFont(ofSize: 19, weight: .semibold))
                return cell
            }
        case .email:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFFieldCell.identifier, for: indexPath) as? LFFieldCell {
                cell.selectionStyle = .none
                cell.configure(field: .email)
                cell.textField.addTarget(self, action: #selector(inputDidChange), for: .editingChanged)
                cell.textField.delegate = self
                cell.textField.returnKeyType = .continue
                cell.textField.enablesReturnKeyAutomatically = true
                cell.textField.tag = getTag(indexPath: indexPath)
                
                return cell
            }
        case .password:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFFieldCell.identifier, for: indexPath) as? LFFieldCell {
                cell.selectionStyle = .none
                cell.configure(field: .password)
                cell.textField.addTarget(self, action: #selector(inputDidChange), for: .editingChanged)
                cell.textField.delegate = self
                cell.textField.returnKeyType = .continue
                cell.textField.enablesReturnKeyAutomatically = true
                cell.textField.tag = getTag(indexPath: indexPath, lastStep: true)
                
                return cell
            }
        case .forgot:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFTextButtonCell.identifier, for: indexPath) as? LFTextButtonCell {
                
                cell.callback = forgotPasswordTapped
                
                return cell
            }
        }
        
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellType = CurrentCell.init(rawValue: indexPath.row) else { return 0 }
        
        switch cellType {
        case .title:
            return UITableViewAutomaticDimension
        case .email,.password:
            return LFFieldCell.normalHeight
        case .forgot:
            return LFTextButtonCell.normalHeight
        }
    }
    
}

extension EmailLoginVC: LoadingHandling {
    func recovery() {}
}

extension EmailLoginVC: DashBoardPresentable {
    func finishLoginFlow(){
        self.presentDashBoard()
    }
}

