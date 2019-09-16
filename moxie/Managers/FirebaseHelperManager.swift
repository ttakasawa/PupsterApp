//
//  FirebaseHelperManager.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/7/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase
import Alamofire
import FirebaseAuth

extension UserManager {
    func createNewBranch(name: String){
        
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        if (currentUser?.uid) != nil {
            print("should append" + name)
            let UserReference = ref.child(name).child("sdvd")
            UserReference.updateChildValues(["junk": "junk"])
            print(UserReference.updateChildValues(["junk": "junk"]))
        }
    }
    
    func populateDatabase(){
        
        var objArray: [SubProgram] = []
        var pathArray: [String] = []
        
        let basicProgram = SubProgram(id: "basics", name: "The Basics", globalLessonIds: ["sitLesson", "touchLesson", "shakeLesson", "laydownLesson", "crateLesson"], recommendedArticleIds: ["Bringing-home-a-new-dog", "Puppy-Socialization", ""])
        objArray.append(basicProgram)
        pathArray.append("SubPrograms/0")
        
        let adventureProgram = SubProgram(id: "adventures", name: "Adventures", globalLessonIds: ["watchmeLesson", "comeLesson", "leashwalkingLesson", "dropitLesson"], recommendedArticleIds: ["", "Car-Safety-for-Your-Dog", "Dog-Travel-Part-1:-Planning-Your-Trip", "Dog-Travel-Part-2:-Safe-Transportation", "Dog-Travel-Part-3:-What-To-Pack"])
        objArray.append(adventureProgram)
        pathArray.append("SubPrograms/1")
        
        let trickProgram = SubProgram(id: "tricks", name: "Tricks", globalLessonIds: ["circleLesson", "hoopjumpLesson", "footsiesLesson", "bowLesson"], recommendedArticleIds: ["", ""])
        objArray.append(trickProgram)
        pathArray.append("SubPrograms/2")
        
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        
        for i in 0..<objArray.count {
            let obj = self.toData(object: objArray[i])
            ref.child(pathArray[i]).setValue(obj)
        }
    }
    
    func populateSingleObj(articleObj: Article, path: String){
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        let obj = self.toData(object: articleObj)
        ref.child(path).setValue(obj)
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
    
    func replicateArticle(){
        for i in 0..<7 {
            self.sortOutArticle(id: String(describing: i))
        }
    }
    
    
    func sortOutArticle(id: String){
        let ref = Database.database().reference(fromURL: "https://moxie1-7fca0.firebaseio.com/")
        let articleRef = ref.child("articles").child(id)
        var newArticleStuff: [Article] = []
        var newPathStuff: [String] = []
        
        articleRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let title = value?[Data2.article.title] as? String ?? "none"
            let heading = value?[Data2.article.heading] as? String ?? "none"
            let author = value?[Data2.article.author] as? String ?? "none"
            let authorPosition = value?[Data2.article.authorPosition] as? String ?? "none"
            let authorImage = value?[Data2.article.authorImage] as? String ?? "none"
            let content = value?[Data2.article.content] as? String ?? "none"
            let articleUrl = value?[Data2.article.url] as? String ?? "none"
            var contentImage = value?[Data2.article.contentImage] as? String ?? "none"
            
            let videoRef = value?[Data2.article.videoRef] as? String ?? "none"
            let videoThumbNail = value?[Data2.article.thubmnail] as? String ?? "none"
            
            var articleHeaderTile: articleHeaderData
            var recommendationTiles: [recommending] = []
            
            articleHeaderTile = articleHeaderData.init(title: title, header: heading, author: author, authorAddition: authorPosition, authorImage: authorImage)
            
            var newRecommendations: [ProductRecommendation] = []
            
            let recommendations = value?[Data2.article.recommendations] as? NSArray ?? []
            var counter: Int = 0
            for _ in recommendations{
                
                let recommendation = recommendations[counter] as? [String: Any]
                
                let recommendationType = recommendation?[Data2.article.recommendationType] as? String ?? "none"
                let recommendationId = recommendation?[Data2.article.recommendation] as? String ?? "none"
                let reccomendationImage = recommendation?[Data2.article.recommendationimgSrc] as? String ?? "none"
                let recommendationTitle = recommendation?[Data2.article.recommendationTitle] as? String ?? "none"
                
                let r = ProductRecommendation(recommendationId: recommendationId, recommendationImage: reccomendationImage, recommendationTitle: recommendationTitle, recommendationType: recommendationType)
                
                newRecommendations.append(r)
                
                counter = counter + 1
            }
            
            
            var newAuthorId: String = ""
            if author == "Nicole Ellis" {
                newAuthorId = "NicoleEllis"
            }else{
                newAuthorId = "PupsterTeam"
            }
            
            if videoThumbNail != "none" {
                contentImage = videoThumbNail
            }
            
            //let id = title.stringByReplacingOccurrencesOfString(" ", withString: "-")
            let id = title.replacingOccurrences(of: " ", with: "-")
            
            let path = "Articles/\(id)"
            //let newArticle = Article(id: id, title: title, authorID: newAuthorId, content: content, imageUrl: contentImage, videoUrl: videoRef, heading: heading, sharableUrl: articleUrl, productRecommendations: newRecommendations)
            
//            newArticleStuff.append(newArticle)
//            newPathStuff.append(path)
            
            //self.populateSingleObj(articleObj: newArticle, path: path)
        })
    }
}
