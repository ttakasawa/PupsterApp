//
//  DogBreedAgeVC.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/9/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import SnapKit

enum PDurationType: String {
    case year
    case month
    case week
    
    static var all: [PDurationType] {
        return [.year, .month, .week]
    }
}

class PDuration {
    
    var number: TimeInterval
    var type: PDurationType
    
    var description: String {
        return "\(Int(number)) \(type.rawValue)\(number > 1 ? "s" : "")"
    }
    
    var timeInterval: TimeInterval {
        switch type {
        case .year:
            return number * UNIX.year
        case .month:
            return number * UNIX.month
        case .week:
            return number * UNIX.week
        }
    }
    
    init(number: TimeInterval, type: PDurationType) {
        self.number = number
        self.type = type
    }
    
}

class DogBreedAgeVC: LoginFlowVC {

    fileprivate enum DogBreedAgeCell: Int {
        case breed
        case age
        case ownershipDuration
    }
    
    var durationPickerView = UIPickerView()
    
    var durationClasses = PDurationType.all.map({$0.rawValue + "(s)"})
    var numbers = Array(1...30)
    
    var age = PDuration(number: 1, type: .year)
    var ownershipDuration = PDuration(number: 1, type: .year)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        startInputIndex = IndexPath.init(row: DogBreedAgeCell.breed.rawValue, section: 0)
        
        durationPickerView.delegate = self
        durationPickerView.dataSource = self
        
        continueButton.setTitle("COMPLETE", for: .normal)
        
        configureLastStepTitle()
    }
    
    func configureLastStepTitle() {
        let textLayer = UILabel(frame: CGRect.zero)
        textLayer.textColor = UIColor.white
        textLayer.textAlignment = .right
        let textContent = "Last Step!"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            .font: UIFont.systemFont(ofSize: 28.0, weight: .semibold)
            ])
        textLayer.attributedText = textString
        self.view.addSubview(textLayer)
        textLayer.snp.makeConstraints { make in
            make.width.equalTo(240.0)
            make.height.equalTo(32.0)
            make.right.equalTo(view.snp.right).offset(-24.0)
            make.top.equalTo(view.snp.top).offset(32.0)
        }
    }
    
    func proceedRegistration() {
        guard let breedCell = tableView.cellForRow(at:
            IndexPath.init(row: DogBreedAgeCell.breed.rawValue, section: 0))
            as? LFFieldCell else {
                return
        }
        guard let breed = breedCell.textField.text, !breed.isEmpty else {
            self.showAlert(title: "Error", message: "Breed is empty", completion: {
                breedCell.textField.becomeFirstResponder()
            })
            return
        }
        
        guard let current = PDog.current else { return }
        current.breed = breed
        current.age = age.timeInterval
        current.ownershipDuration = ownershipDuration.timeInterval
        
        self.showLoading()
        DogService.shared.uploadDogToDatabase { (error) in
            self.hideLoading()
            guard error == nil else {
                self.showAlert(title: "Error", message: "Failed uploading dog to database")
                return
            }
            self.continueRegistration()
        }
    }
    
    func continueRegistration() {
        let notificationsVC = UIStoryboard.init(name: "LoginFlow", bundle: nil).instantiateViewController(withIdentifier: "SetupNotificationsVC") as! SetupNotificationsVC
        self.present(notificationsVC, animated: true, completion: nil)
    }
    
    @objc override func continueButtonTapped() {
        proceedRegistration()
    }

}

extension DogBreedAgeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DogBreedAgeCell.ownershipDuration.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = DogBreedAgeCell.init(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch cellType {
        case .breed:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFFieldCell.identifier, for: indexPath) as? LFFieldCell {
                cell.selectionStyle = .none
                cell.configure(title: "\(PDog.current?.name.uppercased() ?? "DOG")'S BREED")
                cell.textField.addTarget(self, action: #selector(inputDidChange), for: .editingChanged)
                cell.textField.delegate = self
                cell.textField.returnKeyType = .continue
                cell.textField.enablesReturnKeyAutomatically = true
                cell.textField.tag = getTag(indexPath: indexPath)
                
                return cell
            }
        case .age:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFFieldCell.identifier, for: indexPath) as? LFFieldCell {
                cell.selectionStyle = .none
                cell.configure(title: "\(PDog.current?.name.uppercased() ?? "DOG")'S AGE")
                cell.textField.addTarget(self, action: #selector(inputDidChange), for: .editingChanged)
                cell.textField.delegate = self
                cell.textField.inputView = durationPickerView
                cell.textField.tag = getTag(indexPath: indexPath)
                
                return cell
            }
        case .ownershipDuration:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LFFieldCell.identifier, for: indexPath) as? LFFieldCell {
                cell.selectionStyle = .none
                cell.configure(title: "HOW LONG HAVE HAD \(PDog.current?.name.uppercased() ?? "DOG")?")
                cell.textField.addTarget(self, action: #selector(inputDidChange), for: .editingChanged)
                cell.textField.delegate = self
                cell.textField.inputView = durationPickerView
                cell.textField.tag = getTag(indexPath: indexPath)
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LFFieldCell.normalHeight
    }
    
}

extension DogBreedAgeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        durationPickerView.tag = textField.tag
        guard let rowType = DogBreedAgeCell.init(rawValue: getIndexPath(tag: textField.tag).row) else { return }
        var duration: PDuration = age
        if rowType == .ownershipDuration {
            duration = ownershipDuration
        }
        durationPickerView.selectRow(numbers.index(of: Int(duration.number)) ?? 0, inComponent: 0, animated: false)
        durationPickerView.selectRow(durationClasses.index(of: duration.type.rawValue + "(s)") ?? 0, inComponent: 1, animated: false)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return numbers.count
        }
        return durationClasses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let rowType = DogBreedAgeCell.init(rawValue: getIndexPath(tag: pickerView.tag).row) else { return }
        
        if rowType == .age {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: DogBreedAgeCell.age.rawValue, section: 0)) as? LFFieldCell {
                
                if component == 0 {
                    age.number = TimeInterval(numbers[row])
                } else {
                    age.type = PDurationType.all[row]
                }
                cell.textField.text = age.description
                inputDidChange()
            }
        } else if rowType == .ownershipDuration {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: DogBreedAgeCell.ownershipDuration.rawValue, section: 0)) as? LFFieldCell {
                
                if component == 0 {
                    ownershipDuration.number = TimeInterval(numbers[row])
                } else {
                    ownershipDuration.type = PDurationType.all[row]
                }
                cell.textField.text = ownershipDuration.description
                inputDidChange()
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(numbers[row])"
        }
        return durationClasses[row]
    }
}

extension DogBreedAgeVC: LoadingHandling {
    func recovery() {}
}
