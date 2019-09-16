//
//  SettingViewControllerWithHeader.swift
//  moxie
//
//  Created by Tomoki Takasawa on 7/25/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class SettingViewControllerWithHeader: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0), NSAttributedStringKey.font: UIFont.init(name: "AvenirNext-DemiBold", size: 20)!]
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
