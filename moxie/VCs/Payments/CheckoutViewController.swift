//
//  CheckoutViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//


import UIKit
import Stripe
import SCLAlertView

class CheckoutViewController: UIViewController, Stylable {
    
    //let stripePublishableKey = "pk_test_52NkmhZlvxvOgx7v2bCEX8dK"//pk_live_Ja68ebHf36to5Bcnv4cPhS1v
    let stripePublishableKey = "pk_live_Ja68ebHf36to5Bcnv4cPhS1v"
    let backendBaseURL: String? = "https://us-central1-moxie1-7fca0.cloudfunctions.net/app"
    let appleMerchantID: String? = "merchant.com.pupster"
    
    // These values will be shown to the user when they purchase with Apple Pay.
    let companyName = "Emoji Apparel"
    let paymentCurrency = "usd"
    
    let paymentContext: STPPaymentContext
    
    let theme: STPTheme
    let paymentRow: CheckoutRowView
    let shippingRow: CheckoutRowView
    let totalRow: CheckoutRowView
    let buyButton: BuyButton
    let rowHeight: CGFloat = 44
    let variantId: String
    var network: TypeNetwork
    let productName = UILabel()
    let productImg = UIImageView()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let numberFormatter: NumberFormatter
    let shippingString: String
    var product = ""
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    self.buyButton.alpha = 0
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.buyButton.alpha = 1
                }
            }, completion: nil)
        }
    }
    
    init(product: String, price: Int, image: UIImage, variantId: String, network: TypeNetwork) {
        
        self.variantId = variantId
        self.network = network
        
        let stripePublishableKey = self.stripePublishableKey
        let backendBaseURL = self.backendBaseURL
        
        assert(stripePublishableKey.hasPrefix("pk_"), "You must set your Stripe publishable key at the top of CheckoutViewController.swift to run this app.")
        assert(backendBaseURL != nil, "You must set your backend base url at the top of CheckoutViewController.swift to run this app.")
        
        self.product = product
        self.productName.text = product
        self.productImg.image = image
        self.theme = STPTheme()
        
        MyAPIClient.sharedClient.baseURLString = self.backendBaseURL
        
        // This code is included here for the sake of readability, but in your application you should set up your configuration and theme earlier, preferably in your App Delegate.
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = self.stripePublishableKey
        config.appleMerchantIdentifier = self.appleMerchantID
        config.companyName = self.companyName
        config.requiredBillingAddressFields = .full
        config.requiredShippingAddressFields = [.postalAddress, .phoneNumber]
        config.shippingType = .shipping
        config.additionalPaymentMethods = .all
            //self.applePay.enabled ? .all : STPPaymentMethodType()
        
        // Create card sources instead of card tokens
        config.createCardSources = true;
        
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)
        let paymentContext = STPPaymentContext(customerContext: customerContext,
                                               configuration: config,
                                               theme: self.theme)
        let userInformation = STPUserInformation()
        paymentContext.prefilledInformation = userInformation
        paymentContext.paymentAmount = price
        paymentContext.paymentCurrency = self.paymentCurrency
        
        let paymentSelectionFooter = PaymentContextFooterView(text: "You can add custom footer views to the payment selection screen.")
        paymentSelectionFooter.theme = self.theme
        //paymentContext.paymentMethodsViewControllerFooterView = paymentSelectionFooter
        
        let addCardFooter = PaymentContextFooterView(text: "You can add custom footer views to the add card screen.")
        addCardFooter.theme = self.theme
        //paymentContext.addCardViewControllerFooterView = addCardFooter
        
        self.paymentContext = paymentContext
        
        self.paymentRow = CheckoutRowView(title: "Payment", detail: "Select Payment",
                                          theme: self.theme)
        var shippingString = "Contact"
        if config.requiredShippingAddressFields?.contains(.postalAddress) ?? false {
            shippingString = config.shippingType == .shipping ? "Shipping" : "Delivery"
        }
        self.shippingString = shippingString
        self.shippingRow = CheckoutRowView(title: self.shippingString,
                                           detail: "Enter \(self.shippingString) Info",
            theme: self.theme)
        self.totalRow = CheckoutRowView(title: "Total", detail: "", tappable: false,
                                        theme: self.theme)
        self.buyButton = BuyButton(enabled: true, theme: self.theme)
        var localeComponents: [String: String] = [
            NSLocale.Key.currencyCode.rawValue: self.paymentCurrency,
            ]
        localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
        let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeID)
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        self.numberFormatter = numberFormatter
        super.init(nibName: nil, bundle: nil)
        self.paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.theme.secondaryBackgroundColor
        
        theme.primaryBackgroundColor = UIColor(red:0.96, green:0.96, blue:0.95, alpha:1.00)
        theme.secondaryBackgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        theme.primaryForegroundColor = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.00)
        theme.secondaryForegroundColor = UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.00)
        theme.accentColor = UIColor(red:0.09, green:0.81, blue:0.51, alpha:1.00)
        theme.accentColor = self.getMainColor()
        
        theme.errorColor = UIColor(red:0.87, green:0.18, blue:0.20, alpha:1.00)
        //theme.font = UIFont(name: "ChalkboardSE-Light", size: 17)
        theme.font = self.getNormalTextFont()
        theme.emphasisFont = self.getSubTitleFont()
        
        
        var red: CGFloat = 0
        self.theme.primaryBackgroundColor.getRed(&red, green: nil, blue: nil, alpha: nil)
        self.activityIndicator.activityIndicatorViewStyle = red < 0.5 ? .white : .gray
        self.navigationItem.title = "Check out"
        
        self.view.addSubview(self.totalRow)
        self.view.addSubview(self.paymentRow)
        self.view.addSubview(self.shippingRow)
        self.view.addSubview(self.productName)
        self.view.addSubview(self.productImg)
        self.view.addSubview(self.buyButton)
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.alpha = 0
        self.buyButton.addTarget(self, action: #selector(didTapBuy), for: .touchUpInside)
        self.totalRow.detail = self.numberFormatter.string(from: NSNumber(value: Float(self.paymentContext.paymentAmount)/100))!
        self.paymentRow.onTap = { [weak self] in
            self?.paymentContext.pushPaymentMethodsViewController()
        }
        self.shippingRow.onTap = { [weak self]  in
            self?.paymentContext.pushShippingViewController()
        }
        
        let imgWidth = ScreenSize.SCREEN_WIDTH * 9 / 16
        
        self.productImg.contentMode = .scaleAspectFill
        productImg.translatesAutoresizingMaskIntoConstraints = false
        productImg.clipsToBounds = true
        self.productName.translatesAutoresizingMaskIntoConstraints = false
        productName.numberOfLines = 0
        productName.font = self.getTitleFont()
        
        productImg.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        productImg.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        productImg.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        productImg.heightAnchor.constraint(equalToConstant: imgWidth).isActive = true
        
        productName.topAnchor.constraint(equalTo: productImg.bottomAnchor, constant: 10).isActive = true
        productName.centerXAnchor.constraint(equalTo: productImg.centerXAnchor).isActive = true
        productName.leftAnchor.constraint(equalTo: productImg.leftAnchor, constant: 20).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            insets = view.safeAreaInsets
        }
        let width = self.view.bounds.width - (insets.left + insets.right)
        //self.productImage.sizeToFit()
        //self.productImage.center = CGPoint(x: width/2.0, y: self.productImage.bounds.height/2.0 + rowHeight)
        self.paymentRow.frame = CGRect(x: insets.left, y: self.productName.frame.maxY + rowHeight,
                                       width: width, height: rowHeight)
        self.shippingRow.frame = CGRect(x: insets.left, y: self.paymentRow.frame.maxY,
                                        width: width, height: rowHeight)
        self.totalRow.frame = CGRect(x: insets.left, y: self.shippingRow.frame.maxY,
                                     width: width, height: rowHeight)
        self.buyButton.frame = CGRect(x: insets.left, y: 0, width: 88, height: 44)
        self.buyButton.center = CGPoint(x: width/2.0, y: self.totalRow.frame.maxY + rowHeight*1.5)
        self.activityIndicator.center = self.buyButton.center
    }
    
    @objc func didTapBuy() {
        self.paymentInProgress = true
        self.paymentContext.requestPayment()
    }
}

extension Stylable where Self: CheckoutViewController {
    func getSubTitleFont() -> UIFont {
        return UIFont(name: "SFProText-SemiBold", size: 13)!
    }
    
    func getTitleFont() -> UIFont {
        return UIFont(name: "SFProDisplay-Bold", size: 36)!
    }
}





extension CheckoutViewController: STPPaymentContextDelegate{
    // MARK: STPPaymentContextDelegate
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
        let shopifyParam: [String : String] = [
            "variantId" : self.variantId,
            "email" : (self.network.user?.email)!,
            "firstName" : (self.network.user?.firstName)!,
            "lastName" : (self.network.user?.lastName)!,
            "firstLine" : paymentContext.shippingAddress?.line1 ?? "",
            "secondLine" : paymentContext.shippingAddress?.line2 ?? "",
            "city" : paymentContext.shippingAddress?.city ?? "",
            "state" : paymentContext.shippingAddress?.state ?? "",
            "country" : paymentContext.shippingAddress?.country ?? "",
            "zip" : paymentContext.shippingAddress?.postalCode ?? ""
        ]
        
        self.network.request(endpoint: PupsterAPIRequestEndpoint.createOrder, param: shopifyParam) { (result) in
            print(result)
            guard let result = result as? Bool else{ return }
            if result {
                MyAPIClient.sharedClient.completeCharge(paymentResult,
                                                        amount: self.paymentContext.paymentAmount,
                                                        shippingAddress: self.paymentContext.shippingAddress,
                                                        shippingMethod: self.paymentContext.selectedShippingMethod,
                                                        completion: completion)
            }else{
                self.paymentInProgress = false
            }
            
        }
        
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        self.paymentInProgress = false
        
        switch status {
        case .error:
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("DONE", action: {
                self.navigationController?.popViewController(animated: true)
            })
            alert.showWarning("Whoops", subTitle: "Something went wrong. Please try again later.")
        case .success:
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("DONE", action: {
                self.navigationController?.popToRootViewController(animated: true)
            })
            alert.showSuccess("Thank you", subTitle: "You have successfullu purchased \(self.product)")
        case .userCancellation:
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("DONE", action: {
                self.navigationController?.popViewController(animated: true)
            })
            alert.showWarning("Whoops", subTitle: "Something went wrong. Please try again later.")
        }
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        self.paymentRow.loading = paymentContext.loading
        if let paymentMethod = paymentContext.selectedPaymentMethod {
            self.paymentRow.detail = paymentMethod.label
        }
        else {
            self.paymentRow.detail = "Select Payment"
        }
        if let shippingMethod = paymentContext.selectedShippingMethod {
            self.shippingRow.detail = shippingMethod.label
        }
        else {
            self.shippingRow.detail = "Enter \(self.shippingString) Info"
        }
        self.totalRow.detail = self.numberFormatter.string(from: NSNumber(value: Float(self.paymentContext.paymentAmount)/100))!
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Note: this delegate method is optional. If you do not need to collect a
    // shipping method from your user, you should not implement this method.
//    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
//        let upsGround = PKShippingMethod()
//        upsGround.amount = 0
//        upsGround.label = "UPS Ground"
//        upsGround.detail = "Arrives in 3-5 days"
//        upsGround.identifier = "ups_ground"
//        let upsWorldwide = PKShippingMethod()
//        upsWorldwide.amount = 10.99
//        upsWorldwide.label = "UPS Worldwide Express"
//        upsWorldwide.detail = "Arrives in 1-3 days"
//        upsWorldwide.identifier = "ups_worldwide"
//        let fedEx = PKShippingMethod()
//        fedEx.amount = 5.99
//        fedEx.label = "FedEx"
//        fedEx.detail = "Arrives tomorrow"
//        fedEx.identifier = "fedex"
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            if address.country == nil || address.country == "US" {
//                completion(.valid, nil, [upsGround, fedEx], fedEx)
//            }
//            else if address.country == "AQ" {
//                let error = NSError(domain: "ShippingError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Invalid Shipping Address",
//                                                                                   NSLocalizedFailureReasonErrorKey: "We can't ship to this country."])
//                completion(.invalid, error, nil, nil)
//            }
//            else {
//                fedEx.amount = 20.99
//                completion(.valid, nil, [upsWorldwide, fedEx], fedEx)
//            }
//        }
//    }
}
