//
//  CreditCardInfoViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
import CreditCardForm
import Stripe

class CreditCardInfoViewController: UIViewController {
    
    var creditCardForm = CreditCardFormView()
    let paymentTextField = STPPaymentCardTextField()
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        paymentTextField.delegate = self
        
        // Set up stripe textfield
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.borderWidth = 0
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        
        
        creditCardForm.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(creditCardForm)
        view.addSubview(paymentTextField)
        
        NSLayoutConstraint.activate([
            
            creditCardForm.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            creditCardForm.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            creditCardForm.widthAnchor.constraint(equalToConstant: 300),
            creditCardForm.heightAnchor.constraint(equalToConstant: 200),
            
            
            paymentTextField.topAnchor.constraint(equalTo: creditCardForm.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
}


extension CreditCardInfoViewController: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationMonth, cvc: textField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidEndEditingCVC()
    }
}
