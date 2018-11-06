//
//  Review.swift
//  Value
//
//  Created by Omar Torres on 11/2/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import Foundation

struct Review {
    
    var id: String?
    
    let user: User
    let fromFullname: String
    let content: String
    let fromId: String
    let fromProfileImageUrl: String
    let creationDate: Date
    let isPositive: Bool
    
    var hasLiked = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.fromFullname = dictionary["fromFullname"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.fromProfileImageUrl = dictionary["fromProfileImageUrl"] as? String ?? ""
        self.isPositive = dictionary["isPositive"] as? Bool ?? false
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
