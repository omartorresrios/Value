//
//  ApiService.swift
//  Value
//
//  Created by Omar Torres on 11/29/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import Foundation
import Locksmith
import Alamofire

class ApiService: NSObject {
    
    static let shared = ApiService()
    
    func fetchUserProfileInfo(userId: Int, completion: @escaping (User) -> ()) {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("Token: \(userToken)")
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            print("THE HEADER: \(header)")
            
            Alamofire.request("\(BASE_URL)/\(userId)/profile", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let JSON):
                    
                    guard let userDictionary = JSON as? [String: Any] else { return }
                    print("userDictionary: \(userDictionary)")
                    
                    let newUser = User(uid: userId, dictionary: userDictionary)
                    DispatchQueue.main.async {
                        completion(newUser)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchUserReceivedReviews(userId: Int, completion: @escaping (Review) -> ()) {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("Token: \(userToken)")
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            print("THE HEADER: \(header)")
            
            Alamofire.request("\(BASE_URL)/\(userId)/received_reviews", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let JSON):
                    
                    print("THE USER RECEIVED REVIEWS: \(JSON)")
                    
                    let jsonArray = JSON as! NSArray
                    
                    jsonArray.forEach({ (value) in
                        guard let reviewDictionary = value as? [String: Any] else { return }
                        print("reviewDictionary: \(reviewDictionary)")
                        let newReview = Review(reviewDictionary: reviewDictionary)
                        DispatchQueue.main.async {
                            completion(newReview)
                        }
                    })
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchUserSentReviews(userId: Int, completion: @escaping (Review) -> ()) {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("Token: \(userToken)")
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            print("THE HEADER: \(header)")
            
            Alamofire.request("\(BASE_URL)/\(userId)/sent_reviews", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let JSON):
                    
                    print("THE USER SENT REVIEWS: \(JSON)")
                    
                    let jsonArray = JSON as! NSArray
                    
                    jsonArray.forEach({ (value) in
                        guard let reviewDictionary = value as? [String: Any] else { return }
                        print("reviewDictionary: \(reviewDictionary)")
                        let newReview = Review(reviewDictionary: reviewDictionary)
                        DispatchQueue.main.async {
                            completion(newReview)
                        }
                    })
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchAllReviews(completion: @escaping (Review) -> ()) {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("the current user token: \(userToken)")
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            let url = URL(string: "\(BASE_URL)/all_reviews")!
            
            Alamofire.request(url, headers: header).responseJSON { response in
                
                print("request: \(response.request!)") // original URL request
                print("response: \(response.response!)") // URL response
                print("response data: \(response.data!)") // server data
                print("result: \(response.result)") // result of response serialization
                
                switch response.result {
                case .success(let JSON):
                    print("THE ALL REVIEWS JSON: \(JSON)")
                    
                    let dataArray = JSON as! NSArray
                    
                    dataArray.forEach({ (value) in
                        guard let reviewDictionary = value as? [String: Any] else { return }
                        print("this is reviewDictionary: \(reviewDictionary)")
                        
                        let newReview = Review(reviewDictionary: reviewDictionary)
                        
                        completion(newReview)
                        
                    })
                    
                    
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
}
