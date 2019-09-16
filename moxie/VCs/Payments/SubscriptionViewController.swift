//
//  SubscriptionViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import SCLAlertView

class SubscriptionViewController: UIViewController, Stylable, LoadingHandling {
    
    
    let isInProduction = true
    var isAlertViewShown = false
    
    let appSecret = "12aa85f704174010b7a99d2020a9f0e6"
    
    let appBundleId = "com.pupster.subscription"
    //TODO(low): These info will move
    
    let acceptableCodes = ["Pupster10", "Bestfriends10", "Golden10", "Goldendoodle10", "Labrador10", "Aspca10", "Akc10"]
    
    var network: UserType
    var user: UserData
    
    let basicButton = SubscriptionButton(subscriptionButtonType: .basic)
    let plusButton = SubscriptionButton(subscriptionButtonType: .sixMonth)
    let premiumButton = SubscriptionButton(subscriptionButtonType: .oneYear)
    
    var promoCodeButton: LabelButton!
    let purchaseButton = DashBoardButton(title: "JOIN PUPSTER")
    
    var isDiscountActivated: Bool = false
    var subscriptionType: SubscriptionButtonType?
    
    init(network: UserType, user: UserData){
        self.network = network
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
        self.isDiscountActivated = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configure()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure(){
        
        self.view.backgroundColor = self.getWhiteColor()
        
        let pupsterIconView = UIImageView(image: #imageLiteral(resourceName: "pupsterIcon"))
        pupsterIconView.translatesAutoresizingMaskIntoConstraints = false
        let pupsterTitle = TileLabel(text: "PUPSTER", style: TileLabelStyling(font: self.getTitleFont(), color: self.getTextColor()))
        let planTitle = TileLabel(text: "Choose a plan.", style: TileLabelStyling(font: self.getTitleFont(), color: self.getTextColor()))
        let additionalTitle = TileLabel(text: "No commitment. Cancel anytime.", style: TileLabelStyling(font: self.getSubTitleFont(), color: self.getTextColor()))
        additionalTitle.numberOfLines = 1
        let renewWarningLabel = TileLabel(text: "Plan automatically renews monthly.", style: TileLabelStyling(font: self.getNormalTextFont(), color: self.getTextColor()))
        
        
        let cancelButton = LabelButton(title: "Cancel", labelColor: self.getMainColor(), font: self.getNormalTextFont())
        promoCodeButton = LabelButton(title: "Enter promo code", labelColor: self.getTextColor(), font: self.getSmallFont())
        let privacyPolicyButton = LabelButton(title: "About Pupster and Privacy", labelColor: self.getTextColor(), font: self.getSmallFont())
        
        promoCodeButton.addTarget(self, action: #selector(self.promoCodePressed), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(self.privacyPolicyPressed), for: .touchUpInside)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        promoCodeButton.translatesAutoresizingMaskIntoConstraints = false
        privacyPolicyButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        basicButton.addTarget(self, action: #selector(self.basicSubscriptionPressed), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(self.plusSubscriptionPressed), for: .touchUpInside)
        premiumButton.addTarget(self, action: #selector(self.premiumSubscriptionPressed), for: .touchUpInside)
    
        
        basicButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        premiumButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        purchaseButton.configureStyle(style: DashBoardMainButtonStyle(themeColor: self.getMainColor()))
        purchaseButton.translatesAutoresizingMaskIntoConstraints = false
        
        purchaseButton.addTarget(self, action: #selector(self.purchasePressed), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(self.dismissPressed), for: .touchUpInside)
        
        
        self.view.addSubview(pupsterIconView)
        self.view.addSubview(pupsterTitle)
        self.view.addSubview(cancelButton)
        
        self.view.addSubview(planTitle)
        self.view.addSubview(additionalTitle)
        
        self.view.addSubview(basicButton)
        self.view.addSubview(plusButton)
        self.view.addSubview(premiumButton)
        
        self.view.addSubview(renewWarningLabel)
        self.view.addSubview(promoCodeButton)
        
        self.view.addSubview(purchaseButton)
        
        self.view.addSubview(privacyPolicyButton)
        
        
        pupsterIconView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        pupsterIconView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        pupsterIconView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        pupsterIconView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        pupsterTitle.centerYAnchor.constraint(equalTo: pupsterIconView.centerYAnchor).isActive = true
        pupsterTitle.leftAnchor.constraint(equalTo: pupsterIconView.rightAnchor, constant: 4).isActive = true
        
        cancelButton.centerYAnchor.constraint(equalTo: pupsterIconView.centerYAnchor).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        planTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        planTitle.topAnchor.constraint(equalTo: pupsterTitle.bottomAnchor, constant: 34).isActive = true
        
        additionalTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        additionalTitle.topAnchor.constraint(equalTo: planTitle.bottomAnchor, constant: 2).isActive = true
        
        
        basicButton.topAnchor.constraint(equalTo: additionalTitle.bottomAnchor, constant: 21).isActive = true
        basicButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        basicButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        basicButton.heightAnchor.constraint(equalTo: basicButton.widthAnchor, multiplier: 83.0 / 327.0).isActive = true
        
        plusButton.topAnchor.constraint(equalTo: basicButton.bottomAnchor, constant: 16).isActive = true
        plusButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor, multiplier: 83.0 / 327.0).isActive = true
        
        premiumButton.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 16).isActive = true
        premiumButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        premiumButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        premiumButton.heightAnchor.constraint(equalTo: premiumButton.widthAnchor, multiplier: 83.0 / 327.0).isActive = true
        
        
        renewWarningLabel.topAnchor.constraint(equalTo: premiumButton.bottomAnchor, constant: 16).isActive = true
        renewWarningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        promoCodeButton.topAnchor.constraint(equalTo: renewWarningLabel.bottomAnchor, constant: 26).isActive = true
        promoCodeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        promoCodeButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        promoCodeButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        purchaseButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        purchaseButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        purchaseButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        privacyPolicyButton.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 16).isActive = true
        privacyPolicyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        privacyPolicyButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        privacyPolicyButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.disablePromoCode()
        self.plusSubscriptionPressed()
    }
    
    func purchase(_ purchase: RegisteredPurchase, completion: @escaping (Bool)->Void) {
        self.purchase(purchase, atomically: true, completion: completion)
    }
    
    func getInformation(_ purchase: RegisteredPurchase) {
        getInfo(purchase)
    }
    
//    func activatePromoCode(){
//
//        isDiscountActivated = true
//
//        self.basicButton.setSelected(selected: false)
//        self.plusButton.setSelected(selected: false)
//        self.premiumButton.setSelected(selected: false)
//
//        self.basicButton.discountActivate()
//        self.plusButton.discountActivate()
//        self.premiumButton.discountActivate()
//
//        self.plusSubscriptionPressed()
//    }
    
    func disablePromoCode(){
        self.promoCodeButton.isUserInteractionEnabled = false
        self.promoCodeButton.alpha = 0
    }
    
    func examinePromoCode(code: String){
        //MustDo: verify
        var testResult: Bool = false
        
        
        for i in 0..<self.acceptableCodes.count {
            if code == self.acceptableCodes[i] {
                testResult = true
                break
            }
        }
        
        self.showLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //MustDo: Do the actual fetch
            
            if testResult {
                self.hideLoading()
                //self.activatePromoCode()
                self.promoCodeButton.isUserInteractionEnabled = false
            }else{
                self.hideLoading()
                SCLAlertView().showInfo("Not match", subTitle: "Your promo code seems to be invalid. Please try again.")
            }
        }
    }
    
    func showTransactionComplete(success: Bool){
        self.isAlertViewShown = true
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Done", action: {
            self.dismissAllViewController()
        })
        if success{
            alert.showSuccess("Thank you", subTitle: "You now have access to the entire Pupster Program.")
        }else{
            alert.showWarning("Whoops", subTitle: "Something went wrong. Please inform us at hello@thepupster.com")
        }
        
    }
    
    func dismissAllViewController(){
        if let window = self.view.window {
            window.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func recovery() {
        //TODO: What to do when fetch fails
    }
    
}

@objc
extension SubscriptionViewController {
    
    func basicSubscriptionPressed(){
        self.subscriptionType = .basic
        self.basicButton.setSelected(selected: true)
        self.plusButton.setSelected(selected: false)
        self.premiumButton.setSelected(selected: false)
    }
    
    func plusSubscriptionPressed(){
        self.subscriptionType = .sixMonth
        self.basicButton.setSelected(selected: false)
        self.plusButton.setSelected(selected: true)
        self.premiumButton.setSelected(selected: false)
    }
    
    func premiumSubscriptionPressed(){
        self.subscriptionType = .oneYear
        self.basicButton.setSelected(selected: false)
        self.plusButton.setSelected(selected: false)
        self.premiumButton.setSelected(selected: true)
    }
    
    func dismissPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func purchasePressed(){
        self.purchaseButton.isUserInteractionEnabled = false
        
        //let user = self.user
        
        var registeredSubscriptions: RegisteredPurchase?
        if let type = self.subscriptionType {
            if type == .basic {
                
                registeredSubscriptions = RegisteredPurchase.basic
                
            }else if type == .sixMonth {
                registeredSubscriptions = RegisteredPurchase.sixMonthPremium
            }else if type == .oneYear {
                registeredSubscriptions = RegisteredPurchase.oneYearPremium
            }else{
                //error
                self.showTransactionComplete(success: false)
                self.purchaseButton.isUserInteractionEnabled = true
                return
            }
        }else{
            //prompt to show user to select a plan
            SCLAlertView().showWarning("Error", subTitle: "Please select a plan.")
            self.purchaseButton.isUserInteractionEnabled = true
            return
        }
        
        self.purchase(registeredSubscriptions!) { (success) in
            //self.network.
            if (success == false){
                self.showTransactionComplete(success: false)
                self.purchaseButton.isUserInteractionEnabled = true
                return
            }

            self.network.updateUserSubscription(user: self.user, subscriptionType: registeredSubscriptions!) { (error: Error?) in
                self.purchaseButton.isUserInteractionEnabled = true

                if (self.isAlertViewShown == false){
                    if (error != nil){
                        self.showTransactionComplete(success: false)
                    }else{
                        self.showTransactionComplete(success: true)
                    }
                }
            }
        }
        
        
//        self.network.updateUserSubscription(user: user, subscriptionType: registeredSubscriptions!) { (error: Error?) in
//            self.purchaseButton.isUserInteractionEnabled = true
//
//            if (self.isAlertViewShown == false){
//                if (error != nil){
//                    self.showTransactionComplete(success: false)
//                }else{
//                    self.showTransactionComplete(success: true)
//                }
//            }
//        }
    }
    
    func verifyPressed(){
        //MustDo: figure out what they want to verify.
        //Not in use for now
        self.verifySubscriptions([.basic], completion: { areSubscriptionsPurchased in
            print(areSubscriptionsPurchased)
        })
    }
    
    // MARK -- Restoring purchases
    
    func restorePurchasesTapped(sender: Any) {
        self.restorePurchases()
    }
    
    func verifyReceipt() {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            self.showAlert(self.alertForVerifyReceipt(result))
        }
    }
    
    func privacyPolicyPressed(){
        UIApplication.shared.open(URL(string: "https://thepupster.com/pages/terms-of-service")!, options: [:], completionHandler: nil)
    }
    
    func promoCodePressed(){
        //pop up comes up
        let promoCodePopUp = SCLAlertView()
        let txt = promoCodePopUp.addTextField("Enter your code")
        promoCodePopUp.addButton("Enter") {
            guard let codeEntered = txt.text else { return }
            self.examinePromoCode(code: codeEntered)
        }
        promoCodePopUp.showEdit("Promo Code", subTitle: "Please enter your promo code here!", closeButtonTitle: "Cancel")
    }
    
}


// MARK -- IAP Functions

extension SubscriptionViewController {
    
    func getInfo(_ purchase: RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        print(appBundleId + "." + purchase.rawValue)
        SwiftyStoreKit.retrieveProductsInfo([appBundleId + "." + purchase.rawValue]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(self.alertForProductRetrievalInfo(result))
        }
    }
    
    func purchase(_ purchase: RegisteredPurchase, atomically: Bool, completion: @escaping (Bool)->Void) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.purchaseProduct(appBundleId + "." + purchase.rawValue, atomically: atomically) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if case .success(let purchase) = result {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
            switch result {
            case .success:
                completion(true)
            case .error:
                completion(false)
            }
        }
    }
    
    func restorePurchases() {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for purchase in results.restoredPurchases {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                } else if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            self.showAlert(self.alertForRestorePurchases(results))
        }
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        
        let appleValidator = AppleReceiptValidator(service: isInProduction ? .production : .sandbox, sharedSecret: appSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    func verifyPurchase(_ purchase: RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                
                let productId = self.appBundleId + "." + purchase.rawValue
                
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: productId,
                    inReceipt: receipt)
                self.showAlert(self.alertForVerifySubscriptions(purchaseResult, productIds: [productId]))
                
            case .error:
                self.showAlert(self.alertForVerifyReceipt(result))
            }
        }
    }
    
    func verifySubscriptions(_ purchases: Set<RegisteredPurchase>, completion: @escaping (Bool)->Void) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                let productIds = Set(purchases.map { self.appBundleId + "." + $0.rawValue })
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                self.showAlert(self.alertForVerifySubscriptions(purchaseResult, productIds: productIds))
                completion(true)
            case .error:
                self.showAlert(self.alertForVerifyReceipt(result))
                completion(false)
            }
        }
    }
    
}

// MARK - IAP Alerts

extension SubscriptionViewController {
    
    func showAlert(_ alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func alertForProductRetrievalInfo(_ result: RetrieveResults) -> UIAlertController {
        
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        } else if let invalidProductId = result.invalidProductIDs.first {
            return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
        } else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            return alertWithTitle("Could not retrieve product info", message: errorString)
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            return nil
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error.code {
            case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            }
        }
    }
    
    func alertForRestorePurchases(_ results: RestoreResults) -> UIAlertController {
        
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
        } else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            return alertWithTitle("Purchases Restored", message: "All purchases have been restored")
        } else {
            print("Nothing to Restore")
            return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
        }
    }
    
    func alertForVerifyReceipt(_ result: VerifyReceiptResult) -> UIAlertController {
        
        switch result {
        case .success(let receipt):
            print("Verify receipt Success: \(receipt)")
            return alertWithTitle("Receipt verified", message: "Receipt verified remotely")
        case .error(let error):
            print("Verify receipt Failed: \(error)")
            switch error {
            case .noReceiptData:
                return alertWithTitle("Receipt verification", message: "No receipt data. Try again.")
            case .networkError(let error):
                return alertWithTitle("Receipt verification", message: "Network error while verifying receipt: \(error)")
            default:
                return alertWithTitle("Receipt verification", message: "Receipt verification failed: \(error)")
            }
        }
    }
    
    func alertForVerifySubscriptions(_ result: VerifySubscriptionResult, productIds: Set<String>) -> UIAlertController {
        
        switch result {
        case .purchased(let expiryDate, let items):
            print("\(productIds) is valid until \(expiryDate)\n\(items)\n")
            return alertWithTitle("Product is purchased", message: "Product is valid until \(expiryDate)")
        case .expired(let expiryDate, let items):
            print("\(productIds) is expired since \(expiryDate)\n\(items)\n")
            return alertWithTitle("Product expired", message: "Product is expired since \(expiryDate)")
        case .notPurchased:
            print("\(productIds) has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
    
    func alertForVerifyPurchase(_ result: VerifyPurchaseResult, productId: String) -> UIAlertController {
        
        switch result {
        case .purchased:
            print("\(productId) is purchased")
            return alertWithTitle("Product is purchased", message: "Product will not expire")
        case .notPurchased:
            print("\(productId) has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
    
}




extension Stylable where Self: SubscriptionViewController {
    func getTitleFont() -> UIFont {
        return UIFont(name: "SFProDisplay-Bold", size: 21)!
    }
    
    func getSubTitleFont() -> UIFont {
        return UIFont(name: "SFProDisplay-Semibold", size: 21)!
    }
    
    func getSmallFont() -> UIFont {
        return UIFont(name: "SFProText-Regular", size: 12)!
    }
    
    func getButtonTitleFont() -> UIFont {
        return UIFont(name: "SFProText-Bold", size: 15)!
    }
    
    func getNormalTextFont() -> UIFont {
        return UIFont(name: "SFProText-Regular", size: 17)!
    }
    
    func getWhiteColor() -> UIColor {
        return UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    }
}
