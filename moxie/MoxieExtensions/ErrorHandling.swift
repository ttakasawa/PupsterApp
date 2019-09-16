//
//  ErrorHandling.swift
//  moxie
//
//  Created by ZacharyH on 2/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

protocol ErrorHandling {
    var errorBlock:(_ error: Error?) -> Void { get }
    func showAlert(title: String, message: String)
}

extension ErrorHandling where Self:UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Fix", style: .cancel, handler: nil)
        alert.addAction(okay)
        self.present(alert, animated: true, completion: nil)
    }
}
