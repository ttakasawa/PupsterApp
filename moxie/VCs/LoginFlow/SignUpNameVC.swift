
//
//  SignUpNameVC.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/8/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class SignUpNameVC: LoginFlowVC {
    
    var existingUserEmail: String?
    var existingUserUid: String?
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    init(email: String, uid: String) {
        super.init(nibName: nil, bundle: nil)
        existingUserEmail = email
        existingUserUid = uid
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate enum SignUpNameCell: Int {
        case title
        case firstName
        case lastName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        startInputIndex = IndexPath.init(row: SignUpNameCell.firstName.rawValue, section: 0)
    }
    
    func proceedRegistration() {
        guard let firstNameCell = tableView.cellForRow(at:
            IndexPath.init(row: SignUpNameCell.firstName.rawValue, section: 0))
            as? LFFieldCell else {
                return
        }
        guard let firstName = firstNameCell.textField.text else {
            self.showAlert(title: "Error", message: "First Name is invalid", completion: {
                firstNameCell.textField.becomeFirstResponder()
            })
            return
        }
        
        guard let lastNameCell = tableView.cellForRow(at:
            IndexPath.init(row: SignUpNameCell.lastName.rawValue, section: 0))
            as? LFFieldCell else {
                return
        }
        guard let lastName = lastNameCell.textField.text else {
            self.showAlert(title: "Error", message: "Last Name is invalid", completion: {
                lastNameCell.textField.becomeFirstResponder()
            })
            return
        }
        
        if let current = PUser.current {
            current.firstName = firstName
            current.lastName = lastName
            PUser.save(current)
            continueRegistration()
        }else{
            let defaultUser = PUser(uid: existingUserUid!, email: existingUserEmail!)
            defaultUser.firstName = firstName
            defaultUser.lastName = lastName
            PUser.save(defaultUser)
            continueRegistration()
        }
//        guard let current = PUser.current else { return }
//        current.firstName = firstName
//        current.lastName = lastName
//        PUser.save(current)
//        continueRegistration()
    }
    
    func continueRegistration() {
        let dogButtonVC = UIStoryboard.init(name: "LoginFlow", bundle: nil).instantiateViewController(withIdentifier: "LastStepDogButtonVC") as! LastStepDogButtonVC
        self.present(dogButtonVC, animated: true, completion: nil)
    }
    
    @objc override func continueButtonTapped() {
        proceedRegistration()
    }
    
}


extension SignUpNameVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SignUpNameCell.lastName.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = SignUpNameCell.init(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch cellType {
        case .title:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFTitleCell.identifier, for: indexPath) as? LFTitleCell {
                cell.selectionStyle = .none
                cell.configure(title: "Tell us your name", font: UIFont.systemFont(ofSize: 28, weight: .semibold))
                return cell
            }
        case .firstName:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFFieldCell.identifier, for: indexPath) as? LFFieldCell {
                cell.selectionStyle = .none
                cell.configure(field: .firstName)
                cell.textField.addTarget(self, action: #selector(inputDidChange), for: .editingChanged)
                cell.textField.delegate = self
                cell.textField.returnKeyType = .continue
                cell.textField.enablesReturnKeyAutomatically = true
                cell.textField.tag = getTag(indexPath: indexPath)
                
                return cell
            }
        case .lastName:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFFieldCell.identifier, for: indexPath) as? LFFieldCell {
                cell.selectionStyle = .none
                cell.configure(field: .lastName)
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
        guard let cellType = SignUpNameCell.init(rawValue: indexPath.row) else { return 0 }
        
        switch cellType {
        case .title:
            return UITableViewAutomaticDimension
        case .firstName,.lastName:
            return LFFieldCell.normalHeight
        }
    }
    
}
