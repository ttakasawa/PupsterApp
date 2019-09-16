//
//  productView.swift
//  moxie
//
//  Created by Tomoki Takasawa on 5/19/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

//
//  testShop.swift
//  Testing
//
//  Created by Tomoki Takasawa on 5/9/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import SVProgressHUD
import SCLAlertView
import AVFoundation
import AVKit

class productView: UIViewController, isOnline, dropdownSelected {
    
    func dropdownUpdated() {
        if self.colorContainer.colorLabel.text != self.optionTypes[0] {
            if (self.numOfSelectables == 1){
                getVariant()
            }else if(self.colorContainer2.colorLabel.text != self.optionTypes[1]){
                if (self.numOfSelectables == 2){
                    getVariant()
                }else if(self.colorContainer3.colorLabel.text != self.optionTypes[2]){
                    getVariant()
                }
            }
        }
    }
    func updatePrice(price: String){
        print(price)
        let doublePrice = Double(price)
        print(doublePrice)
        let newIntPrice = (doublePrice ?? 0) * 100
        print(newIntPrice)
        let intPrice = Int(lround(newIntPrice))
        print(intPrice)
        self.productPrice = intPrice
        
        self.price.text = self.appendDollarSign(amount: price)
    }
    
    func getVariant(){
        var counter = 0
        for _ in variants{
            let variant: UserManager.productVariants = variants[counter]
            
            switch self.numOfSelectables {
            case 3:
                if((variant.optionVal1 == colorContainer.colorLabel.text) && (variant.optionVal2 == colorContainer2.colorLabel.text) && (variant.optionVal3 == colorContainer3.colorLabel.text)){
                    //variant.Id
                    updatePrice(price: variant.productPrice)
                }
                break
            case 2:
                if((variant.optionVal1 == colorContainer.colorLabel.text!) && (variant.optionVal2 == colorContainer2.colorLabel.text!)){
                     updatePrice(price: variant.productPrice)
                }
                
                break
            case 1:
                if(variant.optionVal1 == colorContainer.colorLabel.text){
                     updatePrice(price: variant.productPrice)
                }
                break
                
            default:
                print("none")
            }
            counter = counter + 1
        }
    }
    
    weak var Offlinepanel: UIView!
    var frameHeight: CGFloat!
    var productName: String = ""
    var productPrice: Int = 0
    var productDescription: String = ""
    var companyInfo: String = ""
    var numOfSelectables: Int = 0
    var imageArray: [UIImage] = []
    var variants: [UserManager.productVariants] = []
    var userId: String = ""
    var prodID: String = ""
    var userAccessToken: String = ""
    var isLoaded: Bool = false
    var isVideo: Bool = false
    
    var playerLayer: AVPlayerLayer?
    var contentModeArray: [String] = []
    var scrollPinch: UIScrollView!
    var imageCurrentIndex: Int = 0
    var newImageView: UIImageView!
    
    
    let vc = AVPlayerViewController()
    
    var videoRef: String = ""
    
    var network: TypeNetwork
    let productImageContainer: UIScrollView = {
        let p = UIScrollView()
        //p.contentMode = .scaleAspectFit
        p.translatesAutoresizingMaskIntoConstraints = false
        p.showsHorizontalScrollIndicator = false
        p.showsVerticalScrollIndicator = false
        p.isPagingEnabled = true
        
        return p
    }()
    
    let pageControl: UIPageControl = {
        let p = UIPageControl()
        p.pageIndicatorTintColor =  UIColor.darkGray
        p.currentPageIndicatorTintColor = UIColor(red:1.00, green:0.37, blue:0.35, alpha:1.0)
        p.translatesAutoresizingMaskIntoConstraints = false
        //p.tintColor = UIColor.red
        p.numberOfPages = 5
        
        return p
    }()
    
    let price: UILabel = {
        let p = UILabel()
        p.translatesAutoresizingMaskIntoConstraints = false
        //p.text = "$3.99"
        p.font = UIFont.init(name: "AvenirNext-DemiBold", size: 18)
        p.textColor = UIColor.black
        p.textAlignment = .right
        
        return p
    }()
    
    let name: UILabel = {
        let n = UILabel()
        n.translatesAutoresizingMaskIntoConstraints = false
        //n.text = "..."
        n.font = UIFont.init(name: "AvenirNext-Medium", size: 18)
        n.textColor = UIColor.black
        n.textAlignment = .left
        n.adjustsFontSizeToFitWidth = true
        
        return n
    }()
    
    let companyName: UILabel = {
        let n = UILabel()
        n.translatesAutoresizingMaskIntoConstraints = false
        //n.text = "..."
        n.font = UIFont.init(name: "AvenirNext-Medium", size: 15)
        n.textColor = UIColor.black
        n.textAlignment = .left
        n.adjustsFontSizeToFitWidth = true
        
        return n
    }()
    
    let colorContainer: DropDownMenu = {
        let c = DropDownMenu()
        return c
    }()
    
    let colorContainer2: DropDownMenu = {
        let c = DropDownMenu()
        return c
    }()
    
    let colorContainer3: DropDownMenu = {
        let c = DropDownMenu()
        return c
    }()
    
    let productDescriptionText: UILabel = {
        let d = UILabel()
        d.translatesAutoresizingMaskIntoConstraints = false
        d.text = ""
        d.font = UIFont.init(name: "AvenirNext-Medium", size: 18)
        d.textColor = UIColor.black
        d.textAlignment = .left
        d.numberOfLines = 0
        
        return d
    }()
    
    
    let purchaseButton: ShadowButton = {
        let p = ShadowButton()
        p.setTitle("Purchase", for: .normal)
        p.translatesAutoresizingMaskIntoConstraints = false
        p.backgroundColor = UIColor(red:0.48, green:0.78, blue:0.05, alpha:1.0)
        p.titleLabel?.font = UIFont.init(name: "AvenirNext-Bold", size: 20)
        
        return p
    }()
    
    let goBackButton: UIButton = {
        let g = UIButton()
        g.setTitle("go back", for: .normal)
        g.translatesAutoresizingMaskIntoConstraints = false
        g.backgroundColor = UIColor.red
        
        return g
    }()
    
    let scroll: UIScrollView = {
        let s = UIScrollView()
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
    }()
    
    let scrollableView: UIView = {
        let s = UIView()
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
    }()
    
    let blur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        
        return blurredEffectView
    }()
    
    let videoButton: UIButton = {
        let v = UIButton()
        v.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        
        return v
    }()
    
    let scroller: scrollButton = {
        let s = scrollButton()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    
    var downloadCount: Int = 0
    var optionTypes: [String] = []
    
    init(productId: String, network: TypeNetwork) {
        self.network = network
        
        
        self.isVideo = false
        self.prodID = productId
        super.init(nibName: nil, bundle: nil)
        frameHeight = ScreenSize.SCREEN_WIDTH * 9 / 16
        self.fetchBackEnd()
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(productImageContainer)
        self.view.addSubview(scroll)
        self.scroll.addSubview(scrollableView)
        self.scrollableView.addSubview(name)
        self.scrollableView.addSubview(companyName)
        self.scrollableView.addSubview(price)
        self.scrollableView.addSubview(productDescriptionText)
        self.scrollableView.addSubview(self.purchaseButton)
        self.scrollableView.addSubview(self.scroller)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        print("product view deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.loadDismiss()
        self.vc.player?.pause()
        //stop video here
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        if(isConnectedToNetworkFunc()){
            if (isLoaded == false) {
                self.showLoad()
            }
        }
        //isConnectedToNetwork()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.purchaseButton.addTarget(self, action: #selector(self.purchasePressed), for: .touchUpInside)
        self.goBackButton.addTarget(self, action: #selector(self.viewDismissPressed), for: .touchUpInside)
        self.scroller.addTarget(self, action: #selector(self.scrollViewToDescription), for: .touchUpInside)
    }
    
    @objc func scrollViewToDescription(){
        let currentPos = self.scroll.contentOffset.y
        let destPos = currentPos + CGFloat(150)
        self.scroll.setContentOffset(CGPoint(x: 0, y: destPos), animated: true)
    }
    
    var imageUrlStrArray: [String] = []
    
    func fetchBackEnd(){
        UserManager.shared.getProductSpecific(productId: self.prodID){ [unowned self] productName, productDescription, price, productVendor, videoRef, videoThumbNail, option1Arr, option2Arr, option3Arr, variantsArr, imageArr, count, optionTypeArray in
            self.isLoaded = true

            if (productName == "") && (price == ""){
                self.noCollectionAvailable()
            }

            var counterTemp: Int = 0
            for _ in optionTypeArray{
                let optionTypeStr = "Select your " + optionTypeArray[counterTemp]
                self.optionTypes.append(optionTypeStr)
                counterTemp = counterTemp + 1
            }


            self.setNavigationBar(title: productName)
            self.productName = productName
            self.variants = variantsArr
            self.numOfSelectables = count

            if count > 0 {
                self.colorContainer.delegate = self
            }
            if count > 1 {
                self.colorContainer2.delegate = self
            }
            if count > 2 {
                self.colorContainer3.delegate = self
            }

            let tok =  productDescription.components(separatedBy:"</div>")
            let trimmedToken = tok[tok.count - 1].trimmingCharacters(in: .whitespacesAndNewlines)
            let scriptStripped = trimmedToken.replacingOccurrences(of: "<\\s*script[^>]*>(.*?)<\\s*/\\s*script>", with: "", options: .regularExpression   , range: nil)
            let emptyPStripped = scriptStripped.replacingOccurrences(of: "(?i)<p\\b[^<]*>\\s*</p>", with: "", options: .regularExpression   , range: nil)
            let allStripped = emptyPStripped.replacingOccurrences(of: "(?i)<h4\\b[^<]*>\\s*</h4>", with: "", options: .regularExpression   , range: nil)

            self.productDescription = allStripped

            let cents = price.replacingOccurrences(of: ".", with: "", options: .literal , range: nil)

            self.productPrice = Int(cents) ?? 0
            self.companyInfo = productVendor

            var tempImageArray: [String] = imageArr
            if (videoRef != "none") && (videoThumbNail != "none"){
                tempImageArray.insert(videoThumbNail, at: 0)
                self.isVideo = true
                self.videoRef = videoRef
            }

            self.imageUrlStrArray.append(contentsOf: tempImageArray)



            if (count > 0) {
                self.colorContainer.setSelectables(arrayOfSelectables: option1Arr)
                self.colorContainer.addTarget(self, action: #selector(self.presentColorSelection), for: .touchUpInside)
                self.colorContainer.colorLabel.text = self.optionTypes[0]
            }
            if (count > 1) {

                self.colorContainer2.setSelectables(arrayOfSelectables: option2Arr)
                self.colorContainer2.addTarget(self, action: #selector(self.presentColorSelection2), for: .touchUpInside)
                self.colorContainer2.colorLabel.text = self.optionTypes[1]
            }
            if (count > 2) {
                self.colorContainer3.setSelectables(arrayOfSelectables: option3Arr)
                self.colorContainer3.addTarget(self, action: #selector(self.presentColorSelection3), for: .touchUpInside)
                self.colorContainer3.colorLabel.text = self.optionTypes[2]
            }


            self.loadDismiss()


            self.setProductSpecifics()
            self.setImages()
            self.getUserID()
        }

        productImageContainer.delegate = self
        
        
        UserManager.shared.getUserShopifyInfo(){ token in
            self.userAccessToken = token
        }
    }
    
    func recovery(){
        self.downloadCount = 0
        showLoad()
        fetchBackEnd()
    }
    
    func noCollectionAvailable(){
        SVProgressHUD.dismiss()
        blur.frame = self.view.bounds
        view.addSubview(blur)
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false // hide default button
        )
        let alert = SCLAlertView(appearance: appearance) // create alert with appearance
        alert.addButton("OK", action: { // create button on alert
            self.navigationController?.popViewController(animated: true)
        })
        alert.showWarning("Sorry..", subTitle: "This product is currently unavailable. Please come back soon!")
    }
    
    func convertCentsToDollars(amount: Int) -> String {
        let remainder = amount % 100
        let dollars = (amount - remainder) / 100
        
        var cents: String = "00"
        if (remainder < 10){
            cents = "0" + String(describing: remainder)
        }else{
            cents = String(describing: remainder)
        }
        return appendDollarSign(amount: String(describing: dollars) + "." + cents)
    }
    
    
    func appendDollarSign(amount: String) -> String{
        return "$" + amount
    }
    
    func setProductSpecifics(){
        self.name.text = self.productName
        self.price.text = convertCentsToDollars(amount: self.productPrice)
        //self.productDescriptionText.text = self.productDescription
        
        self.productDescriptionText.attributedText = self.productDescription.htmlToAttributed
        self.productDescriptionText.font = UIFont.init(name: "AvenirNext-Medium", size: 16)
        
        self.companyName.text = self.companyInfo

        setproductImageContainer()
        setLabels()
        setScrollable()
        
    }
    
    
    func showLoad(){
        SVProgressHUD.show(withStatus: "Loading...")
        blur.frame = self.view.bounds
        view.addSubview(blur)
    }
    
    func loadDismiss(){
        SVProgressHUD.dismiss()
        if self.blur.isDescendant(of: self.view) {
            self.blur.removeFromSuperview()
        }
    }
    
    func showAlert(){
        SCLAlertView().showWarning("Whoops", subTitle: "Please select your preference!")
    }
    
    @objc func viewDismissPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func getUserID(){
        UserManager.shared.getUserID(){ result in
            self.userId = result
        }
    }
    
}


extension productView {
    //video related
    @objc func playPressed(sender: UIButton){
        self.PlayButtonIsEnabled(isOn: false)
        self.addChildViewController(vc)
        vc.willMove(toParentViewController: self)
        vc.view.frame = (sender.superview?.bounds)!
        let videoURL = URL(string: "https://thepupster.wistia.com/embed/medias/\(self.videoRef).m3u8")!
        let avPlayer = AVPlayer(url: videoURL)
        vc.player = avPlayer
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            // report for an error
        }
        vc.player?.play()
        sender.superview?.addSubview(vc.view)
    }
    
    func PlayButtonIsEnabled(isOn: Bool){
        if (isOn){
            videoButton.isHidden = false
            videoButton.isUserInteractionEnabled = true
        }else{
            videoButton.isHidden = true
            videoButton.isUserInteractionEnabled = false
        }
    }
    
    
    @objc func stopVideo(){
        vc.player?.pause()
    }
}


extension productView: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        if (scrollView == scrollPinch){
            if (scrollView.subviews[0].isKind(of: UIImageView.self)){
                let imageViewSize = scrollView.subviews[0].frame.size
                let scrollViewSize = scrollView.bounds.size
                
                let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
                let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
                
                scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if (scrollView == scrollPinch){
            if (scrollView.subviews[0].isKind(of: UIImageView.self)){
                return scrollView.subviews[0]
            }
        }
        return nil
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        print("scrollViewWillBeginZooming")
        //view?.frame = scrollView.bounds
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == productImageContainer){
            pageControl.currentPage = Int(productImageContainer.contentOffset.x / self.view.frame.width)
            
            if (pageControl.currentPage == 1){
                self.stopVideo()
            }
        }
    }
    
}





@objc
extension productView {
    //button pressed
    func presentColorSelection() {
        if let actionViewPopup: UIAlertController = self.colorContainer.actionview{
            self.present(actionViewPopup, animated: true, completion: nil)
        }
    }
    
    func presentColorSelection2() {
        if let actionViewPopup: UIAlertController = self.colorContainer2.actionview{
            self.present(actionViewPopup, animated: true, completion: nil)
        }
    }
    
    func presentColorSelection3() {
        if let actionViewPopup: UIAlertController = self.colorContainer3.actionview{
            self.present(actionViewPopup, animated: true, completion: nil)
        }
    }
}
