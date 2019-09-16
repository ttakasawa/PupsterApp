//
//  LastStepDogButtonVC.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/9/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class LastStepDogButtonVC: UIViewController {
    
    @IBOutlet weak var dogButton: DogButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dogButton.tappedCallback = dogButtonTapped
    }
    
    func dogButtonTapped() {
        self.present(DogNameGenderVC.init(nibName: nil, bundle: nil), animated: true, completion: nil)
    }

}
