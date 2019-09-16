//
//  checkoutWebViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 6/11/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class checkoutWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, isOnline {
    
    var Offlinepanel: UIView!
    var web: WKWebView!
    var isLoaded: Bool = false
    let blur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        
        return blurredEffectView
    }()
    var testLan: String = ""
    var urlToLoad: String = ""
    
    init(webUrl: String){
        super.init(nibName: nil, bundle: nil)
        let webConfiguration = WKWebViewConfiguration()
        web = WKWebView(frame: .zero, configuration: webConfiguration)
        self.urlToLoad = webUrl
        let myURL = URL(string: webUrl)
        let myRequest = URLRequest(url: myURL!)
        web.load(myRequest)
        
        
        web.uiDelegate = self
        web.translatesAutoresizingMaskIntoConstraints = false
        view = web
        
        
        self.testLan = "hi"
        self.web.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func action (sender:UIButton) {
        if let navigator = self.navigationController {
            navigator.popToRootViewController(animated: true)
        }
    }
    
    func recovery(){
        self.isLoaded = false
        showLoad()
        let myURL = URL(string: self.urlToLoad)
        let myRequest = URLRequest(url: myURL!)
        web.load(myRequest)
    }
    
    func setNavigation(){
        let test: UIBarButtonItem = {
            let t = UIBarButtonItem()
            t.title = "Done"
            t.target = self
            t.action = #selector(action)
            //t.addTarge
            return t
        }()
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        //navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = test
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("view did load")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool){
        setNavigation()
        isConnectedToNetwork()
        if(isConnectedToNetworkFunc()){
            if (isLoaded == false) {
                self.showLoad()
                //self.isLoaded = true
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(self.web.estimatedProgress)
        if (Float(self.web.estimatedProgress) >= 0.85){
            if (isLoaded == false){
                //isLoaded = false
                self.isLoaded = true
                hideLoad()
            }
        }
    }
    
    func showLoad(){
        SVProgressHUD.show(withStatus: "Just a moment, we are preparing your order.")
        blur.frame = self.view.bounds
        view.addSubview(blur)
    }
    
    func hideLoad(){
        SVProgressHUD.dismiss()
        
        if self.blur.isDescendant(of: self.view) {
            self.blur.removeFromSuperview()
        }
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
