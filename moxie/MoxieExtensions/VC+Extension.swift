//
//  VC+Extension.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/9/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: (()->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: { (action) in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    var pupserBase: BaseVC? {
        var par: UIViewController? = self.parent
        while par != nil {
            if let base = par as? BaseVC {
                return base
            } else {
                par = par?.parent
            }
        }
        return nil
    }
}
