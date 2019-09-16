//
//  UpgradeViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class UpgradeViewController: UIViewController {
    var network: UserType
    var 
    init(network: TypeNetwork) {
        self.network = network
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
