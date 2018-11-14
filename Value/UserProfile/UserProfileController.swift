//
//  UserProfileController.swift
//  Value
//
//  Created by Omar Torres on 11/6/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    var user: User?
    var receivedReviews = [Review]()
    var sentReviews = [Review]()
    
    var userId: Int?
    var userFullname: String?
    var userImageUrl: String?
    var userEmail: String?
    var userJobDescription: String?
    var userPosition: String?
    var userDepartment: String?
    
    var isReceiverView = true
    
    func didChangeToReceiverView() {
        isReceiverView = true
        collectionView?.reloadData()
    }
    
    func didChangeToSenderView() {
        isReceiverView = false
        collectionView?.reloadData()
    }
    
    func didTapToWriteController() {
        let writeReviewController = WriteReviewController()
        
        writeReviewController.userReceiverId = userId
        writeReviewController.userReceiverFullname = userFullname
        writeReviewController.userReceiverImageUrl = userImageUrl
        
        let navController = UINavigationController(rootViewController: writeReviewController)
        present(navController, animated: true, completion: nil)
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "back_button"), for: .normal)
        button.backgroundColor = UIColor.mainBlue()
        button.addTarget(self, action: #selector(backToRootVC), for: .touchUpInside)
        return button
    }()
    
    let userProfileCellId = "userProfileCellId"
    let reviewCellId = "reviewCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white

        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserProfileFeed), name: WriteReviewController.updateUserProfileFeedNotificationName, object: nil)
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(ReviewCell.self, forCellWithReuseIdentifier: reviewCellId)
        
        fetchUser()
        
        getAllReviews()
        
    }
    
    func fetchUser() {
        let dict = ["id": userId!, "fullname": userFullname!, "email": userEmail!, "job_description": userJobDescription!, "position": userPosition!, "department": userDepartment!, "avatar_url": userImageUrl!] as [String : Any]
        let userFromUserSearch = User(uid: userId!, dictionary: dict)
        
        self.user = userFromUserSearch
    }
    
    @objc func handleUpdateUserProfileFeed() {
        collectionView?.reloadData()
    }
    
    @objc func backToRootVC() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func getAllReviews() {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("Token: \(userToken)")
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            print("THE HEADER: \(header)")
            
            Alamofire.request("\(BASE_URL)/\(userId!)/received_reviews", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let JSON):
                    
                    print("THE USER RECEIVED REVIEWS: \(JSON)")
                    
                    let jsonArray = JSON as! NSArray
                    
                    jsonArray.forEach({ (value) in
                        guard let reviewDictionary = value as? [String: Any] else { return }
                        print("reviewDictionary: \(reviewDictionary)")
                        let newReview = Review(reviewDictionary: reviewDictionary)
                        self.receivedReviews.append(newReview)
                        self.collectionView?.reloadData()
                    })
                    
                case .failure(let error):
                    print(error)
                }
            }
            
            Alamofire.request("\(BASE_URL)/\(userId!)/sent_reviews", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let JSON):
                    
                    print("THE USER SENT REVIEWS: \(JSON)")
                    
                    let jsonArray = JSON as! NSArray
                    
                    jsonArray.forEach({ (value) in
                        guard let reviewDictionary = value as? [String: Any] else { return }
                        print("reviewDictionary: \(reviewDictionary)")
                        let newReview = Review(reviewDictionary: reviewDictionary)
                        self.sentReviews.append(newReview)
                        self.collectionView?.reloadData()
                    })
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isReceiverView {
            return receivedReviews.count
        } else {
            return sentReviews.count
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isReceiverView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewCell
            cell.review = receivedReviews[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewCell
            cell.review = sentReviews[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let review = receivedReviews[indexPath.item]
        
        let aproximateWidthOfLabel = view.frame.width - 72
        let size = CGSize(width: aproximateWidthOfLabel, height: 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        let fullnameEstimatedFrame = NSString(string: review.fromFullname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let bodyEstimatedFrame = NSString(string: review.body).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: view.frame.width, height: fullnameEstimatedFrame.height + bodyEstimatedFrame.height + 68)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        header.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let user = self.user!
        
        let aproximateWidthOfLabel = view.frame.width - 16 - 16
        let size = CGSize(width: aproximateWidthOfLabel, height: 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        
        // for job_description
        let jobDescEstimatedFrame = NSString(string: user.job_description).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        // for fullname
        let fullnameEstimatedFrame = NSString(string: user.fullname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        // for email
        let emailEstimatedFrame = NSString(string: user.email).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        // for position
        let positionEstimatedFrame = NSString(string: user.position).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        // for department
        let departmentEstimatedFrame = NSString(string: user.department).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        if user.job_description != "" {
            return CGSize(width: view.frame.width, height: jobDescEstimatedFrame.height + fullnameEstimatedFrame.height + emailEstimatedFrame.height + positionEstimatedFrame.height + departmentEstimatedFrame.height + 191)
        } else {
            return CGSize(width: view.frame.width, height: fullnameEstimatedFrame.height + emailEstimatedFrame.height + positionEstimatedFrame.height + departmentEstimatedFrame.height + 187 + 4) // 4 for fix the excess space
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
