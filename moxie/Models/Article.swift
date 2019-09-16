//
//  Article.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/22/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

struct Article: Codable {
    var id: String
    var title: String
    var authorID: String
    var content: String
    var imageUrl: String
    var thumbnail: String?
    var videoUrl: String?
    var heading: String
    var sharableUrl: String?
    var productRecommendations: [ProductRecommendation]?
}

struct Author: Codable {
    var id: String
    var name: String
    var position: String
    var imageUrl: String?
}

struct ProductRecommendation: Codable {
    var recommendationId: String
    var recommendationImage: String
    var recommendationTitle: String
    var recommendationType: String
}
