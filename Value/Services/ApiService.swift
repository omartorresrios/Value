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
    
    func fetchReceivedReviews(userId: Int, completion: @escaping (Review) -> ()) {
        fetchReviews(urlString: "\(BASE_URL)/\(userId)/received_reviews", completion: completion)
    }
    
    func fetchSentReviews(userId: Int, completion: @escaping (Review) -> ()) {
        fetchReviews(urlString: "\(BASE_URL)/\(userId)/sent_reviews", completion: completion)
    }
    
    func fetchAllReviews(completion: @escaping (Review) -> ()) {
        fetchReviews(urlString: GET_ALL_REVIEWS_URL, completion: completion)
    }
    
    func fetchReviews(urlString: String, completion: @escaping (Review) -> ()) {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: employeeKeychainAuthAccount) {
            
            let authToken = userToken["authenticationToken"] as! String
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let JSON):
                    
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
    
    func fetchAllUsers(completion: @escaping (User) -> ()) {
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: employeeKeychainAuthAccount) {
            
            let authToken = userToken["authenticationToken"] as! String
            
            let header = ["Authorization": "Token token=\(authToken)"]
            
            Alamofire.request(GET_ALL_USERS_URL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let JSON):
                    
                    let dataArray = JSON as! NSArray
                    
                    dataArray.forEach({ (value) in
                        guard let userDictionary = value as? [String: Any] else { return }
                        
                        guard let userIdFromKeyChain = Locksmith.loadDataForUserAccount(userAccount: employeeKeychainIdAccount) else { return }
                        
                        let userId = userIdFromKeyChain["id"] as! Int
                        
                        if userDictionary["id"] as! Int == userId {
                            print("Found myself, omit from list")
                            return
                        }
                        let user = User(uid: userDictionary["id"] as! Int, dictionary: userDictionary)
                        completion(user)
                    })
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchUserProfileInfo(userId: Int, completion: @escaping (User) -> ()) {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: employeeKeychainAuthAccount) {
            
            let authToken = userToken["authenticationToken"] as! String
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
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
    
    func sendReview(authToken: String, userId: Int, reviewText: String, value: String, completion: @escaping (Bool) -> ()) {
        let header = ["Authorization": "Token token=\(authToken)"]
        
        let parameters = ["body": reviewText, "value": value]
        
        let url = URL(string: "\(BASE_URL)/\(userId)/write_review")!
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success:
                NotificationCenter.default.post(name: updateUserProfileFeedNotificationName, object: nil)
                completion(true)
                
            case .failure(let error):
                completion(false)
                print("Failed to sign in with email:", error)
                
                return
            }
        }
    }
    
    func updateInfo(position: String, job_description: String, completion: @escaping (Bool) -> ()) {
       
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: employeeKeychainAuthAccount) {
            
            let authToken = userToken["authenticationToken"] as! String
            print("the current user token: \(authToken)")
            
            let header = ["Authorization": "Token token=\(authToken)"]
            
            let parameters = ["position": position, "job_description": job_description]
            
            guard let userIdFromKeyChain = Locksmith.loadDataForUserAccount(userAccount: "currentUserId") else { return }
            let userId = userIdFromKeyChain["id"] as! Int
            
            let url = URL(string: "\(BASE_URL)/\(userId)/edit")!
            
            Alamofire.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    print("response user info: ", JSON)
                    NotificationCenter.default.post(name: updateUserHeaderInfo, object: nil, userInfo: nil)
                    completion(true)
                case .failure(let error):
                    completion(false)
                    print("Failed to edit user info:", error)
                    return
                }
            }
        }
    }
}
