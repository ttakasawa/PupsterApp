//
//  ProductViewPayments.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import Stripe

extension productView {
    
    func checkingout(vid: String){
        MyAPIClient.sharedClient.baseURLString = "https://us-central1-moxie1-7fca0.cloudfunctions.net/app"
        let variantid = String(describing: vid)
        MyAPIClient.sharedClient.checkoutWithShopify(uid: self.userId, variantID: variantid, productID: prodID, price: self.price.text!, productName: productName, accessToken: self.userAccessToken){ webUrl in
            
            
            if let navigator = self.navigationController {
                let checkingout = checkoutWebViewController(webUrl: webUrl)
                navigator.pushViewController(checkingout, animated: true)
            }
        }
    }
    
    
    func askPaymentInfo(){
        let theme = STPTheme.default()
        theme.primaryBackgroundColor = UIColor(red:230.0/255.0, green:235.0/255.0, blue:241.0/255.0, alpha:255.0/255.0)
        theme.secondaryBackgroundColor = UIColor.white
        theme.primaryForegroundColor = UIColor(red:55.0/255.0, green:53.0/255.0, blue:100.0/255.0, alpha:255.0/255.0)
        theme.secondaryForegroundColor = UIColor(red:148.0/255.0, green:163.0/255.0, blue:179.0/255.0, alpha:255.0/255.0)
        theme.accentColor = UIColor(red:101.0/255.0, green:101.0/255.0, blue:232.0/255.0, alpha:255.0/255.0)
        theme.errorColor = UIColor(red:240.0/255.0, green:2.0/255.0, blue:36.0/255.0, alpha:255.0/255.0)
        
        //let themeViewController = ThemeViewController()
        let config = STPPaymentConfiguration()
        //let theme = themeViewController.theme.stpTheme
        config.requiredBillingAddressFields = .full
        let viewController = STPAddCardViewController(configuration: config, theme: theme)
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.stp_theme = theme
        present(navigationController, animated: true, completion: nil)
        
//        if let navigator = self.navigationController {
//            let vc = CreditCardInfoViewController()
//            navigator.pushViewController(vc, animated: true)
//        }
    }
    
    func askShippingInfo(){
        let theme = STPTheme.default()
        theme.primaryBackgroundColor = UIColor(red:230.0/255.0, green:235.0/255.0, blue:241.0/255.0, alpha:255.0/255.0)
        theme.secondaryBackgroundColor = UIColor.white
        theme.primaryForegroundColor = UIColor(red:55.0/255.0, green:53.0/255.0, blue:100.0/255.0, alpha:255.0/255.0)
        theme.secondaryForegroundColor = UIColor(red:148.0/255.0, green:163.0/255.0, blue:179.0/255.0, alpha:255.0/255.0)
        theme.accentColor = UIColor(red:101.0/255.0, green:101.0/255.0, blue:232.0/255.0, alpha:255.0/255.0)
        theme.errorColor = UIColor(red:240.0/255.0, green:2.0/255.0, blue:36.0/255.0, alpha:255.0/255.0)
        
        //let themeViewController = ThemeViewController()
        let config = STPPaymentConfiguration()
        
        config.requiredShippingAddressFields = [.postalAddress]
        let viewController = STPShippingAddressViewController(configuration: config,
                                                              theme: theme,
                                                              currency: "usd",
                                                              shippingAddress: nil,
                                                              selectedShippingMethod: nil,
                                                              prefilledInformation: nil)
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.stp_theme = theme
        present(navigationController, animated: true, completion: nil)
    }
    
    func paymentOption(){
        let theme = STPTheme.default()
        theme.primaryBackgroundColor = UIColor(red:230.0/255.0, green:235.0/255.0, blue:241.0/255.0, alpha:255.0/255.0)
        theme.secondaryBackgroundColor = UIColor.white
        theme.primaryForegroundColor = UIColor(red:55.0/255.0, green:53.0/255.0, blue:100.0/255.0, alpha:255.0/255.0)
        theme.secondaryForegroundColor = UIColor(red:148.0/255.0, green:163.0/255.0, blue:179.0/255.0, alpha:255.0/255.0)
        theme.accentColor = UIColor(red:101.0/255.0, green:101.0/255.0, blue:232.0/255.0, alpha:255.0/255.0)
        theme.errorColor = UIColor(red:240.0/255.0, green:2.0/255.0, blue:36.0/255.0, alpha:255.0/255.0)
        
        let customerContext = MockCustomerContext()
        
        let config = STPPaymentConfiguration()
        //config.requiredBillingAddressFields = .full
        config.additionalPaymentMethods = .all
        config.requiredBillingAddressFields = .none
        config.appleMerchantIdentifier = "dummy-merchant-id"
        let viewController = STPPaymentMethodsViewController(configuration: config,
                                                             theme: theme,
                                                             customerContext: customerContext,//MustDo: get this back to self.customerContext
                                                             delegate: self)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.stp_theme = theme
        present(navigationController, animated: true, completion: nil)
    }
    
    func purchase(variantId: String) {
        if let navigator = self.navigationController {
            navigator.pushViewController(CheckoutViewController(product: self.productName, price: self.productPrice, image: self.imageArray[0], variantId: variantId, network: self.network), animated: true)
        }
    }
    
    @objc func purchasePressed(){
        self.network.logFirebaseEvents(logEventsName: "PurchasePressed", parameterd: ["name" : "PurchasePressed"])
        
        var counter: Int = 0
        
        for _ in variants{
            let variant: UserManager.productVariants = variants[counter]
            
            switch self.numOfSelectables {
            case 3:
                
                if((colorContainer.colorLabel.text == self.optionTypes[0]) || (colorContainer2.colorLabel.text == self.optionTypes[1]) || (colorContainer3.colorLabel.text == self.optionTypes[2])){
                    self.showAlert()
                    return
                }else{
                    self.showLoad()
                    if((variant.optionVal1 == colorContainer.colorLabel.text) && (variant.optionVal2 == colorContainer2.colorLabel.text) && (variant.optionVal3 == colorContainer3.colorLabel.text)){
                        
                        //self.checkingout(vid: variant.Id)
                        self.purchase(variantId: variant.Id)
                    }
                }
                break
            case 2:
                
                if((colorContainer.colorLabel.text == self.optionTypes[0]) || (colorContainer2.colorLabel.text == self.optionTypes[1])){
                    self.showAlert()
                    return
                }else{
                    self.showLoad()
                    if((variant.optionVal1 == colorContainer.colorLabel.text!) && (variant.optionVal2 == colorContainer2.colorLabel.text!)){
                        
                        //self.checkingout(vid: variant.Id)
                        self.purchase(variantId: variant.Id)
                    }
                }
                
                break
            case 1:
                if(colorContainer.colorLabel.text == self.optionTypes[0]){
                    self.showAlert()
                    return
                }else{
                    self.showLoad()
                    if(variant.optionVal1 == colorContainer.colorLabel.text){
                        //self.checkingout(vid: variant.Id)
                        self.purchase(variantId: variant.Id)
                    }
                }
                
                break
                
            default:
                self.showLoad()
                //self.checkingout(vid: variant.Id)
                self.purchase(variantId: variant.Id)
            }
            
            counter = counter + 1
        }
        
    }
}


extension productView: STPAddCardViewControllerDelegate, STPPaymentMethodsViewControllerDelegate, STPShippingAddressViewControllerDelegate {
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: STPPaymentMethodsViewControllerDelegate
    
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        paymentMethodsViewController.navigationController?.popViewController(animated: true)
    }
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: STPShippingAddressViewControllerDelegate
    
    func shippingAddressViewControllerDidCancel(_ addressViewController: STPShippingAddressViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didFinishWith address: STPAddress, shippingMethod method: PKShippingMethod?) {
        let customerContext = MockCustomerContext()
        customerContext.updateCustomer(withShippingAddress: address, completion: nil)
        dismiss(animated: true, completion: nil)
//        self.customerContext.updateCustomer(withShippingAddress: address, completion: nil)
//        dismiss(animated: true, completion: nil)
    }
    
    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didEnter address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        let upsWorldwide = PKShippingMethod()
        upsWorldwide.amount = 10.99
        upsWorldwide.label = "UPS Worldwide Express"
        upsWorldwide.detail = "Arrives in 1-3 days"
        upsWorldwide.identifier = "ups_worldwide"
        let fedEx = PKShippingMethod()
        fedEx.amount = 5.99
        fedEx.label = "FedEx"
        fedEx.detail = "Arrives tomorrow"
        fedEx.identifier = "fedex"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if address.country == nil || address.country == "US" {
                completion(.valid, nil, [upsGround, fedEx], fedEx)
            }
            else if address.country == "AQ" {
                let error = NSError(domain: "ShippingError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Invalid Shipping Address",
                                                                                   NSLocalizedFailureReasonErrorKey: "We can't ship to this country."])
                completion(.invalid, error, nil, nil)
            }
            else {
                fedEx.amount = 20.99
                completion(.valid, nil, [upsWorldwide, fedEx], fedEx)
            }
        }
    }
}








class MockCustomer: STPCustomer {
    var mockSources: [STPSourceProtocol] = []
    var mockDefaultSource: STPSourceProtocol? = nil
    var mockShippingAddress: STPAddress?
    
    override init() {
        /**
         Preload the mock customer with saved cards.
         last4 values are from test cards: https://stripe.com/docs/testing#cards
         Not using the "4242" and "4444" numbers, since those are the easiest
         to remember and fill.
         */
        let visa = [
            "id": "preloaded_visa",
            "exp_month": "10",
            "exp_year": "2020",
            "last4": "1881",
            "brand": "visa",
            ]
        if let card = STPCard.decodedObject(fromAPIResponse: visa) {
            mockSources.append(card)
        }
        let masterCard = [
            "id": "preloaded_mastercard",
            "exp_month": "10",
            "exp_year": "2020",
            "last4": "8210",
            "brand": "mastercard",
            ]
        if let card = STPCard.decodedObject(fromAPIResponse: masterCard) {
            mockSources.append(card)
        }
        let amex = [
            "id": "preloaded_amex",
            "exp_month": "10",
            "exp_year": "2020",
            "last4": "0005",
            "brand": "american express",
            ]
        if let card = STPCard.decodedObject(fromAPIResponse: amex) {
            mockSources.append(card)
        }
    }
    
    override var sources: [STPSourceProtocol] {
        get {
            return mockSources
        }
        set {
            mockSources = newValue
        }
    }
    
    override var defaultSource: STPSourceProtocol? {
        get {
            return mockDefaultSource
        }
        set {
            mockDefaultSource = newValue
        }
    }
    
    override var shippingAddress: STPAddress? {
        get {
            return mockShippingAddress
        }
        set {
            mockShippingAddress = newValue
        }
    }
}

class MockCustomerContext: STPCustomerContext {
    
    let customer = MockCustomer()
    
    override func retrieveCustomer(_ completion: STPCustomerCompletionBlock? = nil) {
        if let completion = completion {
            completion(customer, nil)
        }
    }
    
    override func attachSource(toCustomer source: STPSourceProtocol, completion: @escaping STPErrorBlock) {
        if let token = source as? STPToken, let card = token.card {
            customer.sources.append(card)
        }
        completion(nil)
    }
    
    override func selectDefaultCustomerSource(_ source: STPSourceProtocol, completion: @escaping STPErrorBlock) {
        if customer.sources.contains(where: { $0.stripeID == source.stripeID }) {
            customer.defaultSource = source
        }
        completion(nil)
    }
    
    override func updateCustomer(withShippingAddress shipping: STPAddress, completion: STPErrorBlock?) {
        customer.shippingAddress = shipping
        if let completion = completion {
            completion(nil)
        }
    }
    
    override func detachSource(fromCustomer source: STPSourceProtocol, completion: STPErrorBlock?) {
        if let index = customer.sources.index(where: { $0.stripeID == source.stripeID }) {
            customer.sources.remove(at: index)
        }
        if let completion = completion {
            completion(nil)
        }
    }
}
