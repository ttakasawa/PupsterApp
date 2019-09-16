//
//  LoginHandling.swift
//  moxie
//
//  Created by ZacharyH on 2/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import LocalAuthentication
import KeychainItemWrapper

protocol LoginHandling : class {
    var user: UserDataDepricated? { get set }

    func loadInfo()
    func saveInfo()
    func loginSuccess()
    
    //func configureTouchId()
}

extension LoginHandling where Self:UIViewController {
    func loadInfo() {
        self.user = UserDataDepricated()
        let keyChain = KeychainItemWrapper(identifier: "LoginData", accessGroup: "group.mymoxiedog")
        if let username = keyChain?.object(forKey: kSecAttrAccount) as? String {
            self.user?.email = username
        }
    }
    
    func saveInfo() {
        let keyChain = KeychainItemWrapper(identifier: "LoginData", accessGroup: "group.mymoxiedog")
        if let email = self.user?.email {
            keyChain?.setObject(email, forKey: kSecAttrAccount)
        }
    }
    
    func loginSuccess() {
        let keyChain = KeychainItemWrapper(identifier: "LoginData", accessGroup: "group.mymoxiedog")
        if let email = self.user?.email {
            keyChain?.setObject(email, forKey: kSecAttrAccount)
        }
        if let password = self.user?.password {
            keyChain?.setObject(password, forKey: kSecValueData)
        }
    }
    
    /*func configureTouchId() {
        let context = LAContext()
        
        var errorPointer: NSError?
        let reason = NSLocalizedString("Log into Pupster!", comment: "authReason")
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &errorPointer) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        let keyChain = KeychainItemWrapper(identifier: "LoginData", accessGroup: "group.mymoxiedog")
                        if let username = keyChain?.object(forKey: kSecAttrAccount) as? String {
                            self.user?.email = username
                        }
                        if let password = keyChain?.object(forKey: kSecValueData) as? String {
                            self.user?.password = password
                        }
                    }
                } else {
                    print(error?.localizedDescription ?? "Touch Id Error")
                }
            })
        } else {
            //Touch ID is not available on Device, use password.
        }
    }*/
}
