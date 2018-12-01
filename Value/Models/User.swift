//
//  User.swift
//  Value
//
//  Created by Omar Torres on 11/2/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import Foundation

struct User {
    
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
    
    init(uid: Int, dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.job_description = dictionary["job_description"] as? String ?? ""
        self.position = dictionary["position"] as? String ?? ""
        
        var companyData = dictionary["company"] as! [String: Any]
        self.companyId = companyData["id"] as? Int ?? 0
        self.companyName = companyData["name"] as? String ?? ""
        
        var departmentData = dictionary["department"] as! [String: Any]
        self.departmentId = departmentData["id"] as? Int ?? 0
        self.departmentName = departmentData["name"] as? String ?? ""
        
        self.profileImageUrl = dictionary["avatarUrl"]  as? String ?? ""
    }
}
