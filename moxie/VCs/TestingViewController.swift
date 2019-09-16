//
//  TestingViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/1/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

class TestingViewController: UIViewController {
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
//        UserManager.shared.createNewBranch(name: "Authors")
        //UserManager.shared.populateDB()
        //Global.network.fetchFirebase(endpoint: <#T##FirebaseEndpoint#>, completion: <#T##(Decodable?, Error?) -> Void#>)
        
        //Global.network.user?.programs![0] = Program(id: "PupsterProgram", name: "Pupster Original", subPrograms: [], subProgramIds: ["basics", "adventures", "tricks"])
        
        self.view.backgroundColor = .blue
        
    }
}

//"https://embedwistia-a.akamaihd.net/deliveries/107cdbc2a250c23789f8a8ff2f0a1de4a9ca733d.jpg"

//1wwer322x4

//"https://embedwistia-a.akamaihd.net/deliveries/0606060b348247be9f566ebe60586730f7fa08b8.jpg"

//bvugxj1flo
