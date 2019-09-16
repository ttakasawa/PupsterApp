//
//  ArticleDisplayable.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

protocol ArticleDisplayable: ImageProtocol, TileDisplayable {
    var readableTitle: String { get }
    var readableImageUrl: String { get }
}

extension Article: ArticleDisplayable {
    //MustDo
    var readableTitle: String {
        return self.title
    }
    
    var readableImageUrl: String {
        return self.imageUrl
    }
}

class ArticleDisplaying {
    var articleId: String
    var network: ArticleType
    
    init(id: String, network: TypeNetwork){
        self.network = network
        self.articleId = id
    }
    
    func getArticle(completion: @escaping( _ article: Article) -> Void){
        
        self.network.getArticleContent(articleId: self.articleId) { (content) in
            completion(content)
        }
        
    }
}

struct dummyArticle: ArticleDisplayable {
    var title: String { return " "}
    
    //MustDo
    var readableTitle: String {
        return "How to keep your dog happy when you’re at work"
    }
    
    var readableImageUrl: String {
        return "https://cdn.shopify.com/s/files/1/0090/0841/4778/files/Bringing_a_new_dog_home.png?v=1529955241"
    }
}

