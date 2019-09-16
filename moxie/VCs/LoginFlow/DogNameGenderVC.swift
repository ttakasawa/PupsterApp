//
//  DogNameGenderVC.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/9/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class DogNameGenderVC: LoginFlowVC {

    fileprivate enum DogNameGenderCell: Int {
        case title
        case name
        case gender
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: LFSelectionCell.identifier, bundle: nil), forCellReuseIdentifier: LFSelectionCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        startInputIndex = IndexPath.init(row: DogNameGenderCell.name.rawValue, section: 0)
    }
    
    func proceedRegistration() {
        guard let nameCell = tableView.cellForRow(at:
            IndexPath.init(row: DogNameGenderCell.name.rawValue, section: 0))
            as? LFFieldCell else {
                return
        }
        guard let name = nameCell.textField.text, !name.isEmpty else {
            self.showAlert(title: "Error", message: "Dog's Name is invalid", completion: {
                nameCell.textField.becomeFirstResponder()
            })
            return
        }
        
        guard let genderCell = tableView.cellForRow(at:
            IndexPath.init(row: DogNameGenderCell.gender.rawValue, section: 0))
            as? LFSelectionCell else {
                return
        }
        guard let gender = genderCell.currentSelection else {
            self.showAlert(title: "Error", message: "Dog's  Gender is invalid", completion: nil)
            return
        }
        
        let dog = PDog()
        dog.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        dog.gender = gender
        PDog.save(dog)
        continueRegistration()
    }
    
    func continueRegistration() {
        self.present(DogBreedAgeVC.init(nibName: nil, bundle: nil), animated: true, completion: nil)
    }
    
    @objc override func continueButtonTapped() {
        proceedRegistration()
    }

}


extension DogNameGenderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DogNameGenderCell.gender.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = DogNameGenderCell.init(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch cellType {
        case .title:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFTitleCell.identifier, for: indexPath) as? LFTitleCell {
                cell.selectionStyle = .none
                cell.topMarginConstraint.constant = 0
                cell.bottomMarginConstraint.constant = 0
                cell.configure(title: "Tell us about your dog to\ncustomize Pupster.", font: UIFont.systemFont(ofSize: 28, weight: .semibold))
                return cell
            }
        case .name:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFFieldCell.identifier, for: indexPath) as? LFFieldCell {
                cell.selectionStyle = .none
                cell.configure(field: .dogsName)
                cell.textField.addTarget(self, action: #selector(inputDidChange), for: .editingChanged)
                cell.textField.delegate = self
                cell.textField.returnKeyType = .continue
                cell.textField.enablesReturnKeyAutomatically = true
                cell.textField.tag = getTag(indexPath: indexPath)
                
                return cell
            }
        case .gender:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFSelectionCell.identifier, for: indexPath) as? LFSelectionCell {
                cell.selectionStyle = .none
                cell.selectionChangedCallback = { gender in
                    self.inputDidChange()
                }
                
                return cell
            }
        }
        
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellType = DogNameGenderCell.init(rawValue: indexPath.row) else { return 0 }
        
        switch cellType {
        case .title:
            return UITableViewAutomaticDimension
        case .name:
            return LFFieldCell.normalHeight
        case .gender:
            return LFSelectionCell.normalHeight
        }
    }
    
}
