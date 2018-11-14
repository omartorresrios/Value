//
//  Review.swift
//  Value
//
//  Created by Omar Torres on 11/2/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import Foundation

struct Review {
    
    let id: Int
    
    let fromId: Int
    let fromProfileImageUrl: String
    let fromFullname: String
    let fromEmail: String
    
    let toId: Int
    let toProfileImageUrl: String
    let toFullname: String
    let toEmail: String
    
    let body: String
    let creationDate: String
    
    init(reviewDictionary: [String: Any]) {
        
        self.id = reviewDictionary["id"] as? Int ?? 0
        
        var senderData = reviewDictionary["sender"] as! [String: Any]
        self.fromId = senderData["id"] as? Int ?? 0
        self.fromProfileImageUrl = senderData["avatar_url"] as? String ?? ""
        self.fromFullname = senderData["fullname"] as? String ?? ""
        self.fromEmail = senderData["email"] as? String ?? ""
        
        var receiverData = reviewDictionary["receiver"] as! [String: Any]
        self.toId = receiverData["id"] as? Int ?? 0
        self.toProfileImageUrl = receiverData["avatar_url"] as? String ?? ""
        self.toFullname = receiverData["fullname"] as? String ?? ""
        self.toEmail = senderData["email"] as? String ?? ""
        
        self.body = reviewDictionary["body"] as? String ?? ""
        self.creationDate = reviewDictionary["created_at"] as? String ?? ""
        
    }
}
