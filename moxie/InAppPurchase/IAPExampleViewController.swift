//
//  IAPExampleViewController.swift
//  moxie
//
//  Created by Tymofii Dolenko on 8/31/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

enum RegisteredPurchase: String, Codable {
    
    // in use
    case trial
    case basic
    case sixMonthPremium
    case oneYearPremium
    
    // not in use, but should not be removed
    case plus
    case premium
    case basicDiscounted
    case plusDiscounted
    case premiumDiscounted
}

class IAPExampleViewController: UIViewController {
    
    let isInProduction = false
    
    let appSecret = "12aa85f704174010b7a99d2020a9f0e6"
    
    let appBundleId = "com.pupster.subscription"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let purchaseButton = UIButton()
        purchaseButton.backgroundColor = UIColor.red
        purchaseButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(purchaseButton)
        
        purchaseButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        purchaseButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        purchaseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        purchaseButton.addTarget(self, action: #selector(self.purchasePressed), for: .touchUpInside)
        
        let verifyButton = UIButton()
        verifyButton.backgroundColor = UIColor.blue
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(verifyButton)
        
        verifyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        verifyButton.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor).isActive = true
        verifyButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        verifyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        verifyButton.addTarget(self, action: #selector(self.verifyPressed), for: .touchUpInside)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc func purchasePressed(){
        self.purchase(.basic) { (success) in
            print(success)
        }
    }
    
    @objc func verifyPressed(){
        self.verifySubscriptions([.basic], completion: { areSubscriptionsPurchased in
            print(areSubscriptionsPurchased)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK -- Get information about IAP
    
    func getInformation(_ purchase: RegisteredPurchase) {
        getInfo(purchase)
    }
    
    // MARK -- Purchase IAP
    
    func purchase(_ purchase: RegisteredPurchase, completion: @escaping (Bool)->Void) {
        self.purchase(purchase, atomically: true, completion: completion)
    }
    
    @IBAction func exampleVerifyBasic(sender: Any) {
        self.verifySubscriptions([.basic], completion: { areSubscriptionsPurchased in
            // We can do something here depending on areSubscriptionsPurchased variable
        })
    }
    
    // MARK -- Example for purchasing basic
    
    @IBAction func examplePurchaseBasic(sender: Any) {
        self.purchase(.basic, completion: { wasPurchaseSuccessfull in
            //We can do something here depending on wasPurchaseSuccessfull variable
        })
    }
    
    // MARK -- Restoring purchases
    
    @IBAction func restorePurchasesTapped(sender: Any) {
        self.restorePurchases()
    }
    
    // MARK -- Verifying local receipt
    
    @IBAction func verifyReceipt() {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            self.showAlert(self.alertForVerifyReceipt(result))
        }
    }
}

// MARK -- IAP Functions

extension IAPExampleViewController {
    
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

extension IAPExampleViewController {
    
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
