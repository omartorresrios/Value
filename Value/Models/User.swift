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
    var profileImageUrl: String
    
    init(uid: Int, dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageUrl = dictionary["avatarUrl"]  as? String ?? ""
    }
}
