//
//  SettingsViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/21/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//


import UIKit
import SafariServices
import FirebaseAuth
import SCLAlertView

enum SettingsType {
    case setting
    case dogManagement
}


enum editableDogInfo {
    case name
    case age
    case breed
}

struct Setting {
    static let sectionTitleArray = ["Profile", "Pupster", "Other"]
    static let titleArray = [
        [
            "Dog profile"
        ],
        [
            "Terms and Conditions",
            "Privacy Policy",
        ],
        [
            "Log out"
        ]
    ]
}

struct DogProfile {
    static let sectionTitleArray = ["Profile", "Action"]
    static let titleArray = [
        ["Name", "Age", "Breed"],
        ["Cancel"]
    ]
}

class SettingsViewController: UITableViewController, Stylable {
    
    //var tableView = UITableView()
    var network: TypeNetwork
    var user: UserData
    var settingsType: SettingsType
    
    init(settingsType: SettingsType, network: TypeNetwork, user: UserData){
        self.network = network
        self.user = user
        self.settingsType = settingsType
        super.init(nibName: nil, bundle: nil)
        
        //titleArray[0][0] = "\(user.firstName)'s profile"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(white: 245.0 / 255.0, alpha: 1.0)
        if self.settingsType == .setting {
            self.navigationItem.title = "Settings"
        }else{
            self.navigationItem.title = "Dog Profile"
        }
        
    }
    
    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.settingsType == .setting {
            return Setting.sectionTitleArray.count
        }else{
            return DogProfile.sectionTitleArray.count
        }
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.settingsType == .setting {
            return Setting.titleArray[section].count
        }else{
            return DogProfile.titleArray[section].count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42.0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.settingsType == .setting {
            return Setting.sectionTitleArray[section]
        }else{
            if section == 0 {
                return DogProfile.sectionTitleArray[section] + " (Tap to edit)"
            }
            return DogProfile.sectionTitleArray[section]
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") ?? UITableViewCell.init(style: .subtitle, reuseIdentifier: "UITableViewCell")
        
        cell.textLabel?.textColor = UIColor.init(white: 0.0, alpha: 0.6)
        cell.textLabel?.font = self.getNormalTextFont()
        cell.textLabel?.lineBreakMode = .byCharWrapping
        cell.textLabel?.numberOfLines = 2
        if self.settingsType == .setting {
            cell.textLabel?.text = "\(Setting.titleArray[indexPath.section][indexPath.row])"
        }else{
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    cell.textLabel?.text = self.user.dogs![0].name
                }else if indexPath.row == 1 {
                    let time = Date().timeIntervalSince(self.user.dogs![0].birthTime)
                    let ageDouble = time / (60 * 60 * 24 * 365)
                    cell.textLabel?.text = String(describing: Int(ageDouble))
                }else if indexPath.row == 2 {
                    cell.textLabel?.text = self.user.dogs![0].breed
                }
                
                
                
                cell.detailTextLabel?.textColor = UIColor.init(white: 0.0, alpha: 0.5)
                cell.detailTextLabel?.font = self.getSmallFont()
                cell.detailTextLabel?.text = "\(DogProfile.titleArray[indexPath.section][indexPath.row])"
                cell.detailTextLabel?.numberOfLines = 2
            }else{
                cell.textLabel?.text = "\(DogProfile.titleArray[indexPath.section][indexPath.row])"
            }
            
        }
        
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.settingsType == .setting {
            
            tableView.deselectRow(at: indexPath, animated: true)
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    if let navigator = self.navigationController {
                        navigator.pushViewController(SettingsViewController(settingsType: .dogManagement, network: self.network, user: self.user), animated: true)
                    }
                default:
                    break
                }
            case 1:
                switch indexPath.row {
                case 0:
                    let vc = PupsterPolicyViewController(type: .termsConditions)
                    if let navigator = self.navigationController {
                        navigator.pushViewController(vc, animated: true)
                    }
//                    guard let url = URL(string: "https://thepupster.com/pages/terms-of-service") else { return }
//                    let vc = SFSafariViewController(url: url)
//                    self.present(vc, animated: true, completion: nil)
                case 1:
                    let vc = PupsterPolicyViewController(type: .privacyPolicy)
                    if let navigator = self.navigationController {
                        navigator.pushViewController(vc, animated: true)
                    }
                
                default:
                    break
                }
            case 2:
                switch indexPath.row {
                case 0:
                    
                    self.network.logout { (error) in
                        if error != nil {
                            return
                        }
                        let vc = UIStoryboard.init(name: "LoginFlow", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                default:
                    break
                }
            default:
                break
            }
        }else {
            
            tableView.deselectRow(at: indexPath, animated: true)
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    self.editDogInfo(type: .name)
                case 1:
                    self.editDogInfo(type: .age)
                case 2:
                    self.editDogInfo(type: .breed)
                default:
                    break
                }
            case 1:
                switch indexPath.row {
                case 0:
                    self.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            default:
                break
            }
        }
    }
    
    func editDogInfo(type: editableDogInfo){
        guard let dogs = self.user.dogs else { return }
        let dog = dogs[0]
        let popUp = SCLAlertView()
        let txt = popUp.addTextField("Enter your info here")
        popUp.addButton("Enter") {
            guard let text = txt.text else { return }
            var newDog: Dog?
            if type == .name {
                newDog = Dog(id: dog.id, name: text, gender: dog.gender, birthTime: dog.birthTime, ownershipStart: dog.ownershipStart, breed: dog.breed, profileImageUrl: dog.profileImageUrl)
            }else if type == .age {
                if Double(text) != nil {
                    let dogBirthDate = Date().addingTimeInterval(-(Double(text)! * 60 * 60 * 24 * 365))//60 * 60 * 24 * 365
                    
                    newDog = Dog(id: dog.id, name: dog.name, gender: dog.gender, birthTime: dogBirthDate, ownershipStart: dog.ownershipStart, breed: dog.breed, profileImageUrl: dog.profileImageUrl)
                }else {
                    //do nothing
                }
            }else{
                newDog = Dog(id: dog.id, name: dog.name, gender: dog.gender, birthTime: dog.birthTime, ownershipStart: dog.ownershipStart, breed: text, profileImageUrl: dog.profileImageUrl)
            }
            
            if newDog != nil {
                self.network.updateDogInfo(user: self.user, dog: newDog!) { succes in
                    self.showSuccess()
                }
            }
            
            
        }
        //var : String = ""
        if type == .name {
            popUp.showEdit("Enter \(dog.name)'s new name!", subTitle: "", closeButtonTitle: "Cancel")
        }else if type == .age {
            popUp.showEdit("Enter \(dog.name)'s age!", subTitle: "Please enter the age", closeButtonTitle: "Cancel")
        }else{
            popUp.showEdit("Enter \(dog.name)'s breed!", subTitle: "", closeButtonTitle: "Cancel")
        }
    }
    
    func showSuccess(){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Okay", action: {
            if let navigator = self.navigationController {
                navigator.popViewController(animated: true)
            }
        })
        
        alert.showSuccess("", subTitle: "Success!")
    }
    
}


