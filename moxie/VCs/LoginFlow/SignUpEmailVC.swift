//
//  SignUpEmailVC.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/8/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import Firebase

class SignUpEmailVC: LoginFlowVC {
    
    fileprivate enum SignUpEmailCell: Int {
        case title
        case email
        case password
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startInputIndex = IndexPath.init(row: SignUpEmailCell.email.rawValue, section: 0)
        tableView.delegate = self
        tableView.dataSource = self
        continueButton.setTitle("SIGN UP", for: .normal)
    }
    
    func proceedRegistration() {
        view.endEditing(true)
        
        guard let emailCell = tableView.cellForRow(at:
            IndexPath.init(row: SignUpEmailCell.email.rawValue, section: 0))
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
            IndexPath.init(row: SignUpEmailCell.password.rawValue, section: 0))
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
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.hideLoading()
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (auth, error) in
                self.hideLoading()
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
                
                if let uid = auth?.user.uid {
                    
                    let defaultUser = PUser(uid: uid, email: email)
                    PUser.save(defaultUser)
                    
                    self.continueRegistration()
                    
                } else {
                    self.showAlert(title: "Error", message: "Failed to get uid")
                }
            })
            
        }
    }
    
    func continueRegistration() {
        self.present(SignUpNameVC.init(), animated: true, completion: nil)
    }

    @objc override func continueButtonTapped() {
        proceedRegistration()
    }
}

extension SignUpEmailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SignUpEmailCell.password.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = SignUpEmailCell.init(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch cellType {
        case .title:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFTitleCell.identifier, for: indexPath) as? LFTitleCell {
                cell.selectionStyle = .none
                cell.configure(title: "Enter your email and password to create an account.", font: UIFont.systemFont(ofSize: 19, weight: .semibold))
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
        }
        
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellType = SignUpEmailCell.init(rawValue: indexPath.row) else { return 0 }
        
        switch cellType {
        case .title:
            return UITableViewAutomaticDimension
        case .email,.password:
            return LFFieldCell.normalHeight
        }
    }
    
}

extension SignUpEmailVC: LoadingHandling {
    func recovery() {}
}
