//
//  UserManager.swift
//  moxie
//
//  Created by Tomoki Takasawa on 1/24/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import FirebaseAuth
import CodableFirebase

class UserManager: NSObject {
    
    struct Data2 {
        struct Fields {
            
            static var email = "email"
            static var firstName = "firstName"
            static var lastName = "lastName"
            static var lastLog = "lastLog"
            static var firstDog = "firstDog"
            static var profileImage = "profileImageUrl"
            struct dog {
                static var dogName = "dogName"
                static var dogSize = "dogSize"
                static var dogType = "dogType"
                static var isDeleted = "isDeleted"
                static var next = "nextDog"
                static var prev = "prevDog"
                static var index = "index"
                
                
                struct Lesson {
                    static var trainer = "TrainerIntro"
                    static var intro = "Intro"
                    static var sit = "Sit"
                    static var come = "Come"
                    static var lay = "Lay"
                    static var leash = "Leash"
                    static var crate = "Crate"
                    static var trick = "Trick"
                    static var touch = "Touch"
                    static var shake = "Shake"
                    static var jump = "HoopJump"
                    static var footsies = "Footsies"
                    static var circle = "Circle"
                    static var final = "Final"
            
                }
            
                struct InProgress{
                    static var trainer = "TrainerIntro"
                    static var intro = "Intro"
                    static var sit = "Sit"
                    static var come = "Come"
                    static var lay = "Lay"
                    static var leash = "Leash"
                    static var crate = "Crate"
                    static var trick = "Trick"
                    static var touch = "Touch"
                    static var shake = "Shake"
                    static var jump = "HoopJump"
                    static var footsies = "Footsies"
                    static var circle = "Circle"
                    static var final = "Final"
                }
                struct CertificationStatus{
                    static var sit = "Sit"
                    static var lay = "Lay"
                    static var stay = "Stay"
                    static var come = "Come"
                    static var jump = "HoopJump"
                    static var footsies = "Footsies"
                }
            }
            
            static var existingDogNumber = "existingDogNumber"
            static var dogNumber = "dogNumber"
            static var currentDog = "currentDog"
            
            static var notification = "notification"
            static var secondaryNotification = "secondaryNotification"
            static var PaidQuestion = "paidQuestion"
            static var Passward = "password"
            static var payLesson = "payLesson"
            static var isFirstTime = "isFirstTime"
            static var numSession = "numSession"
            static var streak = "streak"
            static var versionNumber = "version"
            static var notificationSubscription = "notificationSubscription"
        }
        struct parentNodes{
            static var user = "users"
            static var Lesson = "Lesson"
            static var InProgress = "InProgress"
            static var certStatus = "CertificateStatus"
            static var payments = "payments"
            static var plan1 = "plan1"
            static var plan2 = "plan2"
            static var question = "question"
            static var dog1 = "dog1"
            static var dog2 = "dog2"
            static var dog3 = "dog3"
            static var dog4 = "dog4"
            static var dog5 = "dog5"
        }
        struct products{
            static var vendor = "vendor"
            static var productId = "id"
            static var productName = "title"
            static var productDescription = "body_html"
            static var productImages = "images"
            static var imageUrl = "src"
            static var options = "options"
            static var optionName = "name"
            static var optionValues = "values"
            static var price = "price"
            static var variants = "variants"
            static var variantId = "id"
            static var videoRef = "videoRef"
            static var thumbnail = "thumbnail"
        }
        struct shopify{
            static var accessToken = "accessToken"
            static var expiration = "expiration"
            static var id = "customerID"
        }
        struct collection{
            static var collectionId = "id"
            static var collectionDescription = "description"
            static var collectionProdIds = "productIds"
            static var collectionProdPrices = "productPrices"
            static var collectionProdTitles = "productTitles"
            static var collectionProdImgSrc = "productImages"
        }
        struct article{
            static var title = "title"
            static var heading = "heading"
            static var author = "author"
            static var authorImage = "authorImage"
            static var authorPosition = "authorPosition"
            static var content = "content"
            static var url = "url"
            static var contentImage = "contentImage"
            static var videoRef = "videoRef"
            static var thubmnail = "thubmnail"
            
            static var recommendations = "recommendations"
            static var recommendationType = "recommendationType"
            static var recommendation = "recommendationId"
            static var recommendationTitle = "recommendationTitle"
            static var recommendationimgSrc = "recommendationImage"
            
        }

    }

    static let shared: UserManager = UserManager()
    var currentUser: User?
    
    private override init() {
        super.init()
        Auth.auth().addStateDidChangeListener { (_, user) in
            self.currentUser = user
        }
    }
    
    func isAuthenticated() -> Bool {
        return false
    }
    
    func anotherOne(one: String, two: String){
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        
        if let userID = currentUser?.uid {
            let UserReference = ref.child("users").child(userID)
            UserReference.child(one).updateChildValues([Data2.Fields.dog.index: two])
        }
    }
    
    func authenticate() {
        
    }
    
    func authenticate(email: String, password: String, completion: @escaping (_ success: Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error{
                completion(false)
                return
            }else{
                completion(true)
                return
            }
        }
    }
    
    func forgotPasswordHandling(email: String, completion: @escaping (_ success: Bool) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            // ...
            if let error = error{
                
                completion(false)
                return
            }else{
                completion(true)
                return
            }
        }
    }

    func signinout(){
        try! Auth.auth().signOut()
    }
    
    
    
    
    
    func updateShopifyAccessToken(email: String, pass: String){
        print("updateShopifyAccessToken")
        
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        if let userID = currentUser?.uid {
            ref.child("users").child(userID).child("shopifyInfo").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let currentToken = value?["accessToken"] as? String ?? "none"
                let currentExpiration = value?["expiration"] as? Int ?? 0
                let shopifyCusId = value?["customerID"] as? String ?? "none"
                let currentTime: Int = Int(NSDate().timeIntervalSince1970)
                
                if (currentToken != "none" && currentExpiration != 0 && shopifyCusId != "none"){
                    let daylong:Int = 86400
                    let timeLeft = currentExpiration - currentTime
                    let dayLeft = timeLeft / daylong
                    MyAPIClient.sharedClient.baseURLString = "https://us-central1-moxie1-7fca0.cloudfunctions.net/app"
                    //dayLeft = 4
                    print(dayLeft)
                    if (dayLeft > 7){
                        //nothing
                        //print("sufficient time - no happen")
                    }else{
                        //print("update on shopify token")
                        let currentUser = Auth.auth().currentUser
                        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                            if let error = error {
                                return
                            }
                            let uid = idToken ?? "none"
                            if (dayLeft > 0){
                                MyAPIClient.sharedClient.renewShopifyToken(currentToken: currentToken, userId: uid, shopifyCustomerID: shopifyCusId){ success in
                                    if (success){
                                    }
                                }
                                //renewShopifyToken
                            }else{
                                //completely new one
                                MyAPIClient.sharedClient.reActivateShopifyAccount(userID: uid, email: email, password: pass, shopifyCustomerID: shopifyCusId){ success in
                                    if (success){
                                    }
                                }
                            }
                        }
                        
                    }
                    
                }
            
            })
            
        }
        
        
    }

    
    
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    
    func getUserID(completion: @escaping (_ success: String) -> Void){
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                return
            }
            
            let uid = idToken ?? "none"
            completion(uid)
        }
        
    }
    
    
    class productVariants: NSObject{
        var Id: String = ""
        var productPrice: String = ""
        var optionVal1: String = ""
        var optionVal2: String = ""
        var optionVal3: String = ""
        init (variantId: String, price: String, option1: String, option2: String, option3:String){
            self.Id = variantId
            self.productPrice = price
            self.optionVal1 = option1
            self.optionVal2 = option2
            self.optionVal3 = option3
        }
    }
    
    
    func getProductSpecific(productId: String, completion: @escaping(_ success: String, String, String, String, String, String, [String], [String], [String], [UserManager.productVariants], [String], Int, [String])->Void){
        
        
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        let productNode = ref.child("products").child(productId)
        productNode.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if(value == nil){
                completion("", "", "", "", "", "", [], [], [], [], [], 0, [])
                return
            }

            let productDescription = value?[Data2.products.productDescription] as? String ?? ""
            let productName = value?[Data2.products.productName] as? String ?? ""
            let productVendor = value?[Data2.products.vendor] as? String ?? ""
            let options: NSArray = value?[Data2.products.options] as? NSArray ?? []
            
            var option1Arr: [String] = []
            var option2Arr: [String] = []
            var option3Arr: [String] = []
            var variantsArr: [productVariants] = []
            var imageArr: [String] = []
            
            var optionTypeArray: [String] = []
            
            var count = 0
            for _ in options{
                let option = options[count] as? [String: Any]
                let optionName = option?["name"] ?? "none?"
                let optionValues = option?["values"] as? NSArray
                
                for item in optionValues ?? []{
                    let itemStr = item as? String ?? ""
                    if (count == 0){
                        option1Arr.append(itemStr)
                    }else if (count == 1){
                        option2Arr.append(itemStr)
                    }else if (count == 2){
                        option3Arr.append(itemStr)
                    }
                }
                count = count+1
                
                let optionNameStr = optionName as? String ?? ""
                
                if(optionNameStr == "Title"){
                    count = count - 1
                }else{
                    optionTypeArray.append(optionNameStr)
                }
            }
            
            var priceStr: String = "100000.00"
            let variants: NSArray = value?[Data2.products.variants] as? NSArray ?? []
            var countVariants = 0
            for _ in variants{
                let variant = variants[countVariants] as? [String: Any]
                //print(option)
                let option1Val = variant?["option1"] as? String ?? ""
                let option2Val = variant?["option2"] as? String ?? ""
                let option3Val = variant?["option3"] as? String ?? ""
                let id = variant?["GraphId"] as? String ?? "error"
                
                let price = variant?["price"] as? String ?? ""
                //priceStr = price
                
                if price.compare(priceStr, options: .numeric) == .orderedAscending {
                    priceStr = price
                }
                
                let variantStruct = productVariants.init(variantId: id, price: price, option1: option1Val, option2: option2Val, option3: option3Val)
                
                variantsArr.append(variantStruct)
                
                countVariants = countVariants+1
                
                
            }
            
            let images: NSArray = value?[Data2.products.productImages] as? NSArray ?? []
            var countImages = 0
            for _ in images{
                let image = images[countImages] as? [String: Any]
                let imageSource = image?["src"] as? String ?? ""
                imageArr.append(imageSource)
                countImages = countImages+1
            }
            
            
            self.getProductVideo(ref: ref, prodID: productId){ productVideoURL, VideoThumbNail in
                completion(productName, productDescription, priceStr, productVendor, productVideoURL, VideoThumbNail, option1Arr, option2Arr, option3Arr, variantsArr, imageArr, count, optionTypeArray)
            }
            
        })
        
    }
    
    func getProductVideo(ref: DatabaseReference, prodID: String, completion: @escaping (_ video: String, String) -> Void){
        //let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        let productNode = ref.child("Videos").child("products").child(prodID)
        productNode.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let video = value?["videoRef"] as? String ?? "none"
            let thumbnail = value?["thumbnail"] as? String ?? "none"
            
            completion(video, thumbnail)
        })
            
    }
    
    func getUserShopifyInfo(completion: @escaping(_ token: String) -> Void){
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        if let userID = currentUser?.uid {
            let UserReference = ref.child("users").child(userID).child("shopifyInfo")
            UserReference.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let accessToken = value?[Data2.shopify.accessToken] as? String ?? "none"
                
                if (accessToken == "none"){
                    return 
                }
                
                completion(accessToken)

            })
        }
    }
    
    func getCollectionVideo(name: String, completion: @escaping (_ success: String, String, String) -> Void){
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        let productNode = ref.child("Videos").child("collections").child(name)
        productNode.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let title = value?["title"] as? String ?? "none"
            let video = value?["videoRef"] as? String ?? "none"
            let thumbnail = value?["thumbnail"] as? String ?? "none"
            
            completion(title, video, thumbnail)
        })
    }
    
    func getCollection(name: String, completion: @escaping (_ success: [MarketAndCollectionsData], Bool) -> Void){
        
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        let allCollectionRef = ref.child("collection")
        let collectionRef = allCollectionRef.child(name)
        
        var collectionProdArray: [MarketAndCollectionsData] = []
        var prodCounter: Int = 0
        
        collectionRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let selectedCollection = snapshot.value as? NSDictionary
            if(selectedCollection == nil){
                let prod = MarketAndCollectionsData.init(dataId: "", title: "", price: "", panelType: "", buttonTitle: "", imageSrc: "")
                collectionProdArray.append(prod)
                completion(collectionProdArray, true)
                return
            }
            
            let productsIdArr = selectedCollection?[Data2.collection.collectionProdIds] as? NSArray ?? []
            let productsNameArr = selectedCollection?[Data2.collection.collectionProdTitles] as? NSArray ?? []
            let productsImagesArr = selectedCollection?[Data2.collection.collectionProdImgSrc] as? NSArray ?? []
            let productsPriceArr = selectedCollection?[Data2.collection.collectionProdPrices] as? NSArray ?? []
            
            if (productsIdArr == []){
                let prod = MarketAndCollectionsData.init(dataId: "", title: "", price: "", panelType: "", buttonTitle: "", imageSrc: "")
                collectionProdArray.append(prod)
                completion(collectionProdArray, true)
                return
            }
            for _ in productsIdArr{
                
                let prodId = productsIdArr[prodCounter] as? String ?? ""
                let prodName = productsNameArr[prodCounter] as? String ?? ""
                let prodPrice = productsPriceArr[prodCounter] as? String ?? ""
                let prodImage = productsImagesArr[prodCounter] as? String ?? ""
                
                let prod = MarketAndCollectionsData.init(dataId: prodId, title: prodName, price: prodPrice, panelType: "product", buttonTitle: "Shop", imageSrc: prodImage)
                collectionProdArray.append(prod)
                prodCounter = prodCounter + 1
            }
            
            completion(collectionProdArray, false)
        })
    }
    
    
    
    func getMarketData(completion: @escaping (_ success: [MarketAndCollectionsData], Bool) -> Void){
        
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        let marketRef = ref.child("market")
        
        var tableCellArray: [MarketAndCollectionsData] = []
        var tileCounter: Int = 0
        marketRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let tiles = snapshot.value as? NSArray ?? []
            
            if(tiles == []){
                let tileItem = MarketAndCollectionsData.init(dataId: "", title: "", price: "none", panelType: "", buttonTitle: "", imageSrc: "")
                tableCellArray.append(tileItem)
                completion (tableCellArray, true)
                return
            }
            for _ in tiles{
                let tileData = tiles[tileCounter] as? [String: Any]
                let itemActionType = tileData?["actionType"] as? String ?? ""
                let itemId = tileData?["id"] as? String ?? "0"
                let itemImage = tileData?["imageSrc"] as? String ?? ""
                let itemTitle = tileData?["title"] as? String ?? ""
                let itemType = tileData?["type"] as? String ?? ""
                
                let tileItem = MarketAndCollectionsData.init(dataId: itemId, title: itemTitle, price: "none", panelType: itemType, buttonTitle: itemActionType, imageSrc: itemImage)
                
                tableCellArray.append(tileItem)
                tileCounter = tileCounter + 1
            }
            completion (tableCellArray, false)
            
        })
        
    }
    
    func getArticle(identifier: String, completion: @escaping (_ contents: articleHeaderData, String, [recommending], String) -> Void){
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        let articleRef = ref.child("articles").child(identifier)
        
        articleRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let title = value?[Data2.article.title] as? String ?? "none"
            let heading = value?[Data2.article.heading] as? String ?? "none"
            let author = value?[Data2.article.author] as? String ?? "none"
            let authorPosition = value?[Data2.article.authorPosition] as? String ?? "none"
            let authorImage = value?[Data2.article.authorImage] as? String ?? "none"
            let content = value?[Data2.article.content] as? String ?? "none"
            let articleUrl = value?[Data2.article.url] as? String ?? "none"
            
            var articleHeaderTile: articleHeaderData
            var recommendationTiles: [recommending] = []
            
            articleHeaderTile = articleHeaderData.init(title: title, header: heading, author: author, authorAddition: authorPosition, authorImage: authorImage)
            
            
            
            let recommendations = value?[Data2.article.recommendations] as? NSArray ?? []
            var counter: Int = 0
            for _ in recommendations{
                
                let recommendation = recommendations[counter] as? [String: Any]
                
                let recommendationType = recommendation?[Data2.article.recommendationType] as? String ?? "none"
                let recommendationId = recommendation?[Data2.article.recommendation] as? String ?? "none"
                let reccomendationImage = recommendation?[Data2.article.recommendationimgSrc] as? String ?? "none"
                let recommendationTitle = recommendation?[Data2.article.recommendationTitle] as? String ?? "none"
                
                recommendationTiles.append(recommending.init(imageSrc: reccomendationImage, title: recommendationTitle, panelType: recommendationType, actionType: "open", id: recommendationId))
                
                counter = counter + 1
            }
            
            completion(articleHeaderTile, content, recommendationTiles, articleUrl)
          
            
        })
    }
    
    func getArticleWithIndex(identifier: String, completion: @escaping (_ contents: articleHeaderData, String, [recommending], String, String, String, String) -> Void){
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        
        let articleRef = ref.child("articles").child(identifier)
        
        articleRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let title = value?[Data2.article.title] as? String ?? "none"
            let heading = value?[Data2.article.heading] as? String ?? "none"
            let author = value?[Data2.article.author] as? String ?? "none"
            let authorPosition = value?[Data2.article.authorPosition] as? String ?? "none"
            let authorImage = value?[Data2.article.authorImage] as? String ?? "none"
            let content = value?[Data2.article.content] as? String ?? "none"
            let articleUrl = value?[Data2.article.url] as? String ?? "none"
            let contentImage = value?[Data2.article.contentImage] as? String ?? "none"
            
            let videoRef = value?[Data2.article.videoRef] as? String ?? "none"
            let videoThumbNail = value?[Data2.article.thubmnail] as? String ?? "none"
            
            var articleHeaderTile: articleHeaderData
            var recommendationTiles: [recommending] = []
            
            articleHeaderTile = articleHeaderData.init(title: title, header: heading, author: author, authorAddition: authorPosition, authorImage: authorImage)
            
            let recommendations = value?[Data2.article.recommendations] as? NSArray ?? []
            var counter: Int = 0
            for _ in recommendations{
                
                let recommendation = recommendations[counter] as? [String: Any]
                
                let recommendationType = recommendation?[Data2.article.recommendationType] as? String ?? "none"
                let recommendationId = recommendation?[Data2.article.recommendation] as? String ?? "none"
                let reccomendationImage = recommendation?[Data2.article.recommendationimgSrc] as? String ?? "none"
                let recommendationTitle = recommendation?[Data2.article.recommendationTitle] as? String ?? "none"
                
                recommendationTiles.append(recommending.init(imageSrc: reccomendationImage, title: recommendationTitle, panelType: recommendationType, actionType: "open", id: recommendationId))
                
                counter = counter + 1
            }
            
            completion(articleHeaderTile, content, recommendationTiles, articleUrl, contentImage, videoRef, videoThumbNail)
            
        })
    }
    
    
    func getAllArticles(completion: @escaping (_ success: [MarketAndCollectionsData], Bool) -> Void){

        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        let articleArrayref = ref.child("articles")
        var articlesInfo: [MarketAndCollectionsData] = []
        
        
        articleArrayref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let articles = snapshot.value as? NSArray ?? []
            if(articles == []){
                let oneArticle = MarketAndCollectionsData.init(dataId: "", title: "", price: "", panelType: "", buttonTitle: "", imageSrc: "")
                articlesInfo.append(oneArticle)
                completion(articlesInfo, true)
                return
            }
            
            var articleCounter: Int = 0
            for _ in articles{
                let tileData = articles[articleCounter] as? [String: Any]
                let title = tileData?["title"] as? String ?? ""
                let image = tileData?["contentImage"] as? String ?? ""
                let oneArticle = MarketAndCollectionsData.init(dataId: String(describing: articleCounter), title: title, price: "none", panelType: "article", buttonTitle: "Open", imageSrc: image)
                
                articlesInfo.append(oneArticle)
                articleCounter = articleCounter + 1
            }
            completion(articlesInfo, false)
        })
        
    }
    


    
    
    ///////////////////////lesson/////////
    func getRecommendationCollection(name: String, completion: @escaping(_ collection: String) -> Void){
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        if let userID = currentUser?.uid {
            let UserReference = ref.child("collectionRecommendation")
            
            UserReference.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let collection = value?[name] as? String ?? "none"
                
                completion (collection)
            })
        }
    }
    
    
    
    ////////make new branch///////
    func populateDB(){
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        
        if let userID = currentUser?.uid {
            let newRef = ref.child("Ranking")
            let array = [1,2,3,4,5,6,7,8,9, 10]
            
            newRef.setValue(self.toData(object: array))
        }
    }
    
    func toData<T: Encodable>(object: T) -> Any? {
        let encoder = FirebaseEncoder()
        do{
            let jsonData = try encoder.encode(object)
            return jsonData // json body
        }catch{
            return nil
        }
        //return try encoder.encode(object)
    }
    
}

