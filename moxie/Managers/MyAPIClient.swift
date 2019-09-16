//
//
//  Created by Tomoki Takasawa on 6/1/18.
//  Copyright © 2018 Pupster. All rights reserved.
//  https://us-central1-moxie1-7fca0.cloudfunctions.net/app is base
//updateProduct
//multi function leash, sleepy air, Winpro Focus Supplements, Winpro Mobility Supplements, Winpro Training Supplements, Copy of Trainer SOS (test?)

import Foundation
import Stripe
import Alamofire
//import Locksmith

struct responseFromServer: Decodable {
    let userId: String
    
    init(json: [String: Any]){
        userId = json["id"] as? String ?? ""
    }
    
}

//STPEphemeralKeyProvider if we would use stripe
class MyAPIClient: NSObject {
    
    static let sharedClient = MyAPIClient()
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func checkoutWithShopify(uid: String, variantID: String, productID: String, price: String, productName: String, accessToken: String, completion: @escaping (_ success: String) -> Void){
        let url = self.baseURL.appendingPathComponent("check_out")
        Alamofire.request(url, method: .post, parameters: [
            "varientId": variantID,
            "productId": productID,
            "price": price,
            "name": productName,
            "userId": uid,
            "access": accessToken
            ])
            .validate(statusCode: 200..<300).responseString(){ response in
                switch response.result {
                case .success:
                    let webUrl: String = response.value ?? "error"
                    if (webUrl != "error"){
                        completion(webUrl)
                    }else{
                        //error
                        completion("none")
                    }
                case .failure:
                    completion("none")
                }
        }
    }
    
    func createShopifyAccount(userID: String, email: String, password: String, firstName: String, lastName: String, completion: @escaping (_ success: Bool) -> Void){

        let url = self.baseURL.appendingPathComponent("create_shopify")
        Alamofire.request(url, method: .post, parameters: [
            "email": email,
            "password": password,
            "first": firstName,
            "last": lastName,
            "userid" : userID
            ])
            .validate(statusCode: 200..<300).responseString(){ response in
                switch response.result {
                case .success:
                    
                    completion(true)
                    
                case .failure:
                    //UserManager.shared.newproblemReport(subject: "shopify account create failed", report: "User already exists?? for " + userID + " - code 500 from Shopify")
                    completion(false)
                }
        }
    }
    
    func reActivateShopifyAccount(userID: String, email: String, password: String, shopifyCustomerID: String, completion: @escaping (_ success: Bool) -> Void){
        /*
         var email = req.body.email;
         var userId = req.body.userId;
         var pass = req.body.pass;
         var shopifyCustomerID = req.body.shopifyCustomerID;
         */
        print("reActivateShopifyAccount")
        print(email)
        print(userID)
        print(password)
        print(shopifyCustomerID)
        let url = self.baseURL.appendingPathComponent("recreateAccessToken")
        Alamofire.request(url, method: .post, parameters: [
            "email": email,
            "userId": userID,
            "pass": password,
            "shopifyCustomerID": shopifyCustomerID
            ])
            .validate(statusCode: 200..<300).responseString(){ response in
                print(response.error ?? "erroe?")
                print(response.result)
                switch response.result {
                    
                case .success:
                    completion(true)
                case .failure:
                    //UserManager.shared.newproblemReport(subject: "reActivateShopifyAccount create failed", report: "User already exists?? for " + userID + " - code 500 from Shopify")
                    completion(false)
                }
        }
    }
    
    func renewShopifyToken(currentToken: String, userId: String, shopifyCustomerID: String, completion: @escaping (_ success: Bool) -> Void){
        /*
         var currentToken = req.body.ct;
         var userId = req.body.userid;
         var shopifyCustomerID = req.body.customerId;
         */
        print(currentToken)
        print(userId)
        print(shopifyCustomerID)
        let url = self.baseURL.appendingPathComponent("renewCustomerToken")
        Alamofire.request(url, method: .post, parameters: [
            "ct": currentToken,
            "userid": userId,
            "customerId": shopifyCustomerID
            ])
            .validate(statusCode: 200..<300).responseString(){ response in
                print(response.error ?? "error?")
                print(response.result)
                switch response.result {
                case .success:
                    completion(true)
                case .failure:
                    //UserManager.shared.newproblemReport(subject: "renewShopifyToken create failed", report: "User already exists?? for " + userId + " - code 500 from Shopify")
                    completion(false)
                }
        }
    }
}



extension MyAPIClient: STPEphemeralKeyProvider {
    
    
    func completeCharge(_ result: STPPaymentResult,
                        amount: Int,
                        shippingAddress: STPAddress?,
                        shippingMethod: PKShippingMethod?,
                        completion: @escaping STPErrorBlock) {
        let url = self.baseURL.appendingPathComponent("charge")
        
        var params: [String: Any] = [
            "customer" : "cus_DsblX1qDKYvq3P",
            //"source": result.source.stripeID,
            "amount": amount,
            "currency": "USD"
        ]
        params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
        //params["products"] = STPAddress.
        print("complete charge")
        print(params)
        
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                print(response)
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    print("request ended up error　in completecharge")
                    print(error.localizedDescription)
                    completion(error)
                }
        }
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")//ephemeral_keys
        guard let user = Global.network.user else { return }
        print("createCustomerKey")
        guard let stripeId = user.stripeId else { return }
        print(stripeId)
        //let dictionary = Locksmith.loadDataForUserAccount(userAccount: "stripeID")
        //let stripeUid: String = dictionary?["id"] as? String ?? ""
        //let customerId = Global.network.user.stri
        
        Alamofire.request(url, method: .post, parameters: [
            "api_version": apiVersion,
            "customer_id": stripeId
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                print("result from key")
                print(responseJSON)
                
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("request ended up error in creating key")
                    print(error)
                    completion(nil, error)
                    
                }
        }
    }
    
    func createCustomer(emailAdress: String, completion: @escaping (_ success: String) -> Void){
        
        let url = self.baseURL.appendingPathComponent("create_customer")
        Alamofire.request(url, method: .post, parameters: [
            "email": emailAdress
            ])
            .validate(statusCode: 200..<300).responseString(){ response in
                
                switch response.result {
                case .success:
                    let uid: String = response.value ?? "error"
                    completion(uid)
                    
                case .failure:
                    print("failure")
                    completion("error")
                }
        }
    }
}


protocol PupsterAPIRequest {
    
    var baseURLString: String { get }
    var baseURL: URL { get }
    func request(endpoint: PupsterAPIRequestEndpoint, param: [String: String], completion: @escaping (_ response: Any?) -> Void)
}

extension PupsterAPIRequest {
    var baseURL: URL {
        if let url = URL(string: self.baseURLString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func request(endpoint: PupsterAPIRequestEndpoint, param: [String: String], completion: @escaping (_ response: Any?) -> Void) {
        
        let url = self.baseURL.appendingPathComponent(endpoint.path)
        //cus_DsYRwCYrJW3D6T
        
        Alamofire.request(url, method: .post, parameters: param).validate(statusCode: 200..<300).responseString() { response in
            print(response)
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print("request ended")
                print(error)
                completion(false)
            }
        }
    }
}


enum PupsterAPIRequestEndpoint{
    case charge
    case getEphemeralKey
    case createAccount
    case createOrder
    
    var path: String {
        switch self {
        case .charge:
            return "charge"
        case .getEphemeralKey:
            return "ephemeral_keys"
        case .createAccount:
            return "create_customer"
        case .createOrder:
            return "create_order"
        }
    }
}
