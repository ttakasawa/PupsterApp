//
//  IconTextField.swift
//  moxie
//
//  Created by ZacharyH on 1/28/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView, FieldValidating {
    
    enum FieldType {
        case email
        case password
        case nonEmpty
        case none
    }
    
    var type: FieldType = .none
    @IBOutlet weak var field: UITextField?
    
    @IBInspectable var fieldType: String? = nil {
        didSet {
            if let fieldType = fieldType {
                switch fieldType {
                case "Email":
                    self.type = .email
                    break
                case "Password":
                    self.type = .password
                    break
                case "NonEmpty":
                    self.type = .nonEmpty
                    break
                default:
                    self.type = .none
                    break
                }
            }
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    func validText() -> String? {
        var string: String? = nil
        if self.type == .none {
            string = self.field?.text
        }
        if self.type == .email, let field = self.field {
            string = self.validEmail(field: field)
        }
        if self.type == .password, let field = self.field {
            string = self.validPassword(field: field)
        }
        if self.type == .nonEmpty, let field = self.field {
            string = self.validNonEmpty(field: field)
        }
        return string
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        field?.autocorrectionType = .no
    }
}

@IBDesignable
class RoundedButton: UIControl {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var selectedColor: UIColor = UIColor.clear

    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureAnimation()
    }
    
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if self.isSelected {
            self.backgroundColor = self.selectedColor
        } else {
            self.backgroundColor = UIColor.white
        }
    }
    
    func getSelected() -> Bool{
        return self.isSelected
    }

    func configureAnimation() {
        self.addTarget(self, action: #selector(RoundedButton.animatePress), for: .touchDown)
    }
    
    @objc func animatePress() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (completed) in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = .identity
            })
        }
    }

}
