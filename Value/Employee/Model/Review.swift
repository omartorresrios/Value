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
    let fromJobDescription: String
    let fromPosition: String
    let fromDepartment: String
    
    let toId: Int
    let toProfileImageUrl: String
    let toFullname: String
    let toEmail: String
    let toJobDescription: String
    let toPosition: String
    let toDepartment: String
    
    let body: String
    let value: String
    let creationDate: String
    
    init(reviewDictionary: [String: Any]) {
        
        self.id = reviewDictionary["id"] as? Int ?? 0
        
        var senderData = reviewDictionary["sender"] as! [String: Any]
        self.fromId = senderData["id"] as? Int ?? 0
        self.fromProfileImageUrl = senderData["avatar_url"] as? String ?? ""
        self.fromFullname = senderData["fullname"] as? String ?? ""
        self.fromEmail = senderData["email"] as? String ?? ""
        self.fromJobDescription = senderData["job_description"] as? String ?? ""
        self.fromPosition = senderData["position"] as? String ?? ""
        self.fromDepartment = senderData["department"] as? String ?? ""
        
        var receiverData = reviewDictionary["receiver"] as! [String: Any]
        self.toId = receiverData["id"] as? Int ?? 0
        self.toProfileImageUrl = receiverData["avatar_url"] as? String ?? ""
        self.toFullname = receiverData["fullname"] as? String ?? ""
        self.toEmail = receiverData["email"] as? String ?? ""
        self.toJobDescription = receiverData["job_description"] as? String ?? ""
        self.toPosition = receiverData["position"] as? String ?? ""
        self.toDepartment = receiverData["department"] as? String ?? ""
        
        self.body = reviewDictionary["body"] as? String ?? ""
        self.value = reviewDictionary["value"] as? String ?? ""
        self.creationDate = reviewDictionary["created_at"] as? String ?? ""
        
    }
}
