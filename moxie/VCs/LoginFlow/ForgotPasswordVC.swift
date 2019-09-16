//
//  ForgotPasswordVC.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/10/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordVC: LoginFlowVC {

    fileprivate enum CurrentCell: Int {
        case title
        case email
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startInputIndex = IndexPath.init(row: CurrentCell.email.rawValue, section: 0)
        tableView.delegate = self
        tableView.dataSource = self
        continueButton.setTitle("FORGOT PASSWORD", for: .normal)
    }
    
    func forgotPasswordTapped() {
        view.endEditing(true)
        
        guard let emailCell = tableView.cellForRow(at:
            IndexPath.init(row: CurrentCell.email.rawValue, section: 0))
            as? LFFieldCell else {
                return
        }
        guard let email = emailCell.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            self.showAlert(title: "Error", message: "Email is invalid", completion: {
                emailCell.textField.becomeFirstResponder()
            })
            return
        }
        
        self.showLoading()
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            self.hideLoading()
            guard let error = error else {
                self.showAlert(title: "", message: "Check your email for instructions on how to reset your password.", completion: {
                    let welcomeVC = UIStoryboard.init(name: "LoginFlow", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                    self.present(welcomeVC, animated: true, completion: nil)
                })
                return
            }
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    @objc override func continueButtonTapped() {
        forgotPasswordTapped()
    }

}

extension ForgotPasswordVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentCell.email.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = CurrentCell.init(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch cellType {
        case .title:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFTitleCell.identifier, for: indexPath) as? LFTitleCell {
                cell.selectionStyle = .none
                cell.configure(title: "Forgot your password? We get it.", font: UIFont.systemFont(ofSize: 19, weight: .semibold))
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
        }
        
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellType = CurrentCell.init(rawValue: indexPath.row) else { return 0 }
        
        switch cellType {
        case .title:
            return UITableViewAutomaticDimension
        case .email:
            return LFFieldCell.normalHeight
        }
    }
    
}

extension ForgotPasswordVC: LoadingHandling {
    func recovery() {}
}
