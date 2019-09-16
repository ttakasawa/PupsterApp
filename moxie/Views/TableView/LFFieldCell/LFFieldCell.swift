//
//  LFFieldCell.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/8/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

protocol LFFillable {
    var isFilled: Bool {get}
}

enum LFField: String {
    case email
    case password
    case firstName = "First Name"
    case lastName = "Last Name"
    case dogsName = "Dog's Name"
    case universal
}

class LFFieldCell: UITableViewCell, LFFillable {
    
    static let identifier = "LFFieldCell"
    static let normalHeight: CGFloat = 89
    
    @IBOutlet weak var fieldNameLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fieldSeparatorView: UIView!
    
    var type: LFField = .email
    
    var isFilled: Bool {
        switch type {
        case .email:
            return textField.text!.isValid(regex: .email)
        case .password:
            return textField.text!.count > 5
        default:
            return !textField.text!.isEmpty
        }
    }
    
    func configure(title: String) {
        type = .universal
        fieldNameLbl.text = title
        textField.autocapitalizationType = .words
    }
    
    func configure(field: LFField) {
        type = field
        fieldNameLbl.text = field.rawValue.uppercased()
        
        switch field {
        case .email:
            textField.textContentType = .emailAddress
            textField.keyboardType = .emailAddress
        case .password:
            textField.isSecureTextEntry = true
            textField.textContentType = .password
        case .firstName:
            textField.textContentType = .namePrefix
            textField.autocapitalizationType = .words
        case .lastName:
            textField.textContentType = .nameSuffix
            textField.autocapitalizationType = .words
        default:
            textField.autocapitalizationType = .words
        }
        
        textField.autocorrectionType = .no
    }
    
}
