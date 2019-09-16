//
//  CachedMessages.swift
//  moxie
//
//  Created by Tomoki Takasawa on 10/18/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

class messagesInCache: Codable, Cachable {
    var fileName: String = "latestMessages"
    var messages: [Message]
    var messageCount: Int {
        return messages.count
    }
    var url: URL?
    
    init(messages: [Message]){
        self.messages = messages
    }
    func setURL(url: URL) {
        self.url = url
    }
}
