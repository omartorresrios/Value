//
//  UserViewModel.swift
//  Value
//
//  Created by Omar Torres on 12/20/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import Foundation

struct UserViewModel {
    
    var id: Int
    var fullname: String
    var email: String
    var job_description: String
    var position: String
    var companyId: Int
    var companyName: String
    var departmentId: Int
    var departmentName: String
    var profileImageUrl: String
    
    init(user: User) {
        self.id = user.id
        self.fullname = user.fullname
        self.email = user.email
        self.job_description = user.job_description
        self.position = user.position
        
        self.companyId = user.companyId
        self.companyName = user.companyName
        
        self.departmentId = user.departmentId
        self.departmentName = user.departmentName
        
        self.profileImageUrl = user.profileImageUrl
        
    }
}
