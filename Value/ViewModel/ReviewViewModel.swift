//
//  ReviewViewModel.swift
//  Value
//
//  Created by Omar Torres on 12/20/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import Foundation

struct ReviewViewModel {
    
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
    
    init(review: Review) {
        self.id = review.id
        
        self.fromId = review.fromId
        self.fromProfileImageUrl = review.fromProfileImageUrl
        self.fromFullname = review.fromFullname
        self.fromEmail = review.fromEmail
        self.fromJobDescription = review.fromJobDescription
        self.fromPosition = review.fromPosition
        self.fromDepartment = review.fromDepartment
        
        self.toId = review.toId
        self.toProfileImageUrl = review.toProfileImageUrl
        self.toFullname = review.toFullname
        self.toEmail = review.toEmail
        self.toJobDescription = review.toJobDescription
        self.toPosition = review.toPosition
        self.toDepartment = review.toDepartment
        
        self.body = review.body
        self.value = review.value
        self.creationDate = review.creationDate
    }
    
}
