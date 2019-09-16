//
//  Article_Related.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/23/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

//Article related
protocol ArticleType {
    //var articleContent: Article? { get set }
    func getArticleContent(articleId: String, completion: @escaping (_ content: Article) -> Void)
    func markRead(articleId: String, user: UserData)
    
    func getAuthor(id: String, completion: @escaping ( _ authorInfo: Author?, _ error: Error?) -> Void)
}




extension ArticleType where Self: FirebaseQueryProtocol {
    func getArticleContent(articleId: String, completion: @escaping (_ content: Article) -> Void) {
        
        self.fetchFirebase(endpoint: ArticleEndpoints.getArticleContent(articleId: articleId)) { (content: Article?, error: Error?) in
            guard let content = content else { return }
            completion(content)
        }
    }
    
    
    func markRead(articleId: String, user: UserData){
        //TODO: figure out firebase endpoint type
        user.readArticleIds?.append(articleId)
        var newArray: [String] = []
        if let readArticleArray = user.readArticleIds {
            newArray = readArticleArray
        }
        newArray.append(articleId)
        user.readArticleIds = newArray
        
        self.fetchFirebase(endpoint: ArticleEndpoints.markRead(user: user, articleArray: newArray)) { (array: [String]?, error: Error?) in
            
        }
    }
    
    func getAuthor(id: String, completion: @escaping ( _ authorInfo: Author?, _ error: Error?) -> Void){
        self.fetchFirebase(endpoint: ArticleEndpoints.getAuthor(id: id)) { (author: Author?, error: Error?) in
            completion(author, error)
        }
    }
}

