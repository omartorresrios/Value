//
//  DataService.swift
//  Value
//
//  Created by Omar Torres on 11/11/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import Foundation
import Alamofire

class DataService {

    static let instance = DataService()
    
    func sendReview(authToken: String, userId: Int, reviewText: String, completion: @escaping (Bool) -> ()) {
        // Set Authorization header
        let header = ["Authorization": "Token token=\(authToken)"]
        
        let parameters = ["body": reviewText]
        
        let url = URL(string: "\(BASE_URL)/\(userId)/write_review")!
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success:
                print("response review: ", response)
                completion(true)
                
            case .failure(let error):
                completion(false)
                print("Failed to sign in with email:", error)
                
                return
            }
        }
    }
}
