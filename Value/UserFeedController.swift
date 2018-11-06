//
//  UserFeedController.swift
//  Value
//
//  Created by Omar Torres on 11/2/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith

class UserFeedController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .green
        
        getAllReviews()
    }
    
    func getAllReviews() {
        
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
                    print("THE ALL_REVIEWS JSON: \(JSON)")
                    
//                    let jsonArray = JSON as! NSDictionary
//
//                    let dataArray = jsonArray["reviews"] as! NSArray
//
//                    dataArray.forEach({ (value) in
//                        guard let reviewDictionary = value as? [String: Any] else { return }
//                        print("this is reviewDictionary: \(reviewDictionary)")
//
//                        let review = ReviewAll(reviewDictionary: reviewDictionary)
//
//                        self.reviewsAll.append(review)
//
//                    })
                    
//                    self.reviewsAll.sort(by: { (p1, p2) -> Bool in
//                        return p1.createdAt?.compare(p2.createdAt!) == .orderedDescending
//                    })
                    
//                    self.collectionView.reloadData()
//                    
//                    self.loader.stopAnimating()
//                    self.searchingReviewsLabel.removeFromSuperview()
                    
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
    
}
