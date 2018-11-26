//
//  MyProfileController.swift
//  Value
//
//  Created by Omar Torres on 11/6/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class MyProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    var notificationReviewId: Int!
    var senderFullname: String!
    
    var reviewSelected: Review!
    var isFrom: Bool!
    
    var user = [User]()
    var receivedReviews = [Review]()
    var sentReviews = [Review]()
    
    let userProfileCellId = "userProfileCellId"
    let reviewCellId = "reviewCellId"
    
    var isReceiverView = true
    var isComingFromNotification = false
    var loggedUserId: Int!
    var reviewNotificationPaintedCounter: Int = 0
    
    func didChangeToReceiverView() {
        isReceiverView = true
        collectionView?.reloadData()
    }
    
    func didChangeToSenderView() {
        isReceiverView = false
        collectionView?.reloadData()
    }
    
    func didTapToWriteController() {
        
    }
    
    func didTapToEditProfileController() {
        let editProfileController = EditProfileController()
        
        let navController = UINavigationController(rootViewController: editProfileController)
        present(navController, animated: true, completion: nil)
    }
    var indexPointed = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .brown
        
        guard let userIdFromKeyChain = Locksmith.loadDataForUserAccount(userAccount: "currentUserId") else { return }
        loggedUserId = userIdFromKeyChain["id"] as? Int
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserHeaderInfo(notification:)), name: EditProfileController.updateUserHeaderInfo, object: nil)
        
        collectionView?.register(UserProfileHeader.self, forCellWithReuseIdentifier: "headerId")
        collectionView?.register(ReviewCell.self, forCellWithReuseIdentifier: reviewCellId)
        fetchUser()
        
        getAllReceivedReviews { (success) in
//            if self.isComingFromNotification {
                self.collectionView?.performBatchUpdates(nil, completion: { (result) in
                    if let reviewIndex = self.receivedReviews.index(where: { $0.id == 131 }) {
                        self.indexPointed = reviewIndex
                        print("reviewIndex: ", reviewIndex)
                        let indexPath = IndexPath(item: reviewIndex, section: 1)
                        self.collectionView?.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                        
                    }
                })
//        }
        }
        
        getAllSentReviews { (success) in
            print("Sent reviews loaded")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: EditProfileController.updateUserHeaderInfo, object: nil)
    }
    
    @objc func handleUpdateUserHeaderInfo(notification: Notification) {
        user.removeAll()
        fetchUser()
    }
    
    func fetchUser() {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("Token: \(userToken)")
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            print("THE HEADER: \(header)")
            
            
            
            Alamofire.request("\(BASE_URL)/\(loggedUserId!)/profile", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let JSON):
                    
                    guard let userDictionary = JSON as? [String: Any] else { return }
                    print("userDictionary: \(userDictionary)")
                    
                    let newUser = User(uid: self.loggedUserId!, dictionary: userDictionary)
                    self.user.append(newUser)
                    self.collectionView?.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getAllReceivedReviews(completion: @escaping Callback) {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("Token: \(userToken)")
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            print("THE HEADER: \(header)")
            
            Alamofire.request("\(BASE_URL)/\(loggedUserId!)/received_reviews", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
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
                        completion(true)
                    })
                    
                case .failure(let error):
                    completion(false)
                    print(error)
                }
            }
        }
    }
    
    func getAllSentReviews(completion: @escaping Callback) {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("Token: \(userToken)")
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            print("THE HEADER: \(header)")
            
            Alamofire.request("\(BASE_URL)/\(loggedUserId!)/sent_reviews", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
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
                        completion(true)
                    })
                    
                case .failure(let error):
                    completion(false)
                    print(error)
                }
            }
        }
    }
    
    @objc func tappedFromUserProfile(sender: UIGestureRecognizer) {
        isFrom = true
        let position = sender.location(in: collectionView)
        guard let index = collectionView?.indexPathForItem(at: position) else {
            print("Error, label not in collectionView")
            return
        }
        
        let tappedReview = receivedReviews[index.item]
        reviewSelected = tappedReview
        
        if tappedReview.fromId != loggedUserId {
            showUserProfile()
        }
    }
    
    @objc func tappedToUserProfile(sender: UIGestureRecognizer) {
        isFrom = false
        let position = sender.location(in: collectionView)
        guard let index = collectionView?.indexPathForItem(at: position) else {
            print("Error, label not in collectionView")
            return
        }
        
        let tappedReview = sentReviews[index.item]
        reviewSelected = tappedReview
        
        if tappedReview.toId != loggedUserId {
            showUserProfile()
        }
    }
    
    func showUserProfile() {
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        
        if isFrom {
            userProfileController.userId = reviewSelected.fromId
            userProfileController.userFullname = reviewSelected.fromFullname
            userProfileController.userImageUrl = reviewSelected.fromProfileImageUrl
            userProfileController.userEmail = reviewSelected.fromEmail
            userProfileController.userJobDescription = reviewSelected.fromJobDescription
            userProfileController.userPosition = reviewSelected.fromPosition
            userProfileController.userDepartment = reviewSelected.fromDepartment
        } else {
            userProfileController.userId = reviewSelected.toId
            userProfileController.userFullname = reviewSelected.toFullname
            userProfileController.userImageUrl = reviewSelected.toProfileImageUrl
            userProfileController.userEmail = reviewSelected.toEmail
            userProfileController.userJobDescription = reviewSelected.toJobDescription
            userProfileController.userPosition = reviewSelected.toPosition
            userProfileController.userDepartment = reviewSelected.toDepartment
        }
        
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return user.count
        } else {
            if isReceiverView {
                return receivedReviews.count
            } else {
                return sentReviews.count
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableCell(withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
            header.backgroundColor = .yellow
            header.user = self.user[indexPath.item]
            header.delegate = self
            return header
        } else {
            if isReceiverView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewCell
                
                if reviewNotificationPaintedCounter == 0 {
                    DispatchQueue.main.async {
                        if self.indexPointed == indexPath.item {
                            self.reviewNotificationPaintedCounter += 1
                            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                                cell.contentView.backgroundColor = UIColor.mainGreen()
                                cell.isSelected = true
                            }, completion: { (finished) in
                                UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseIn, animations: {
                                    cell.contentView.backgroundColor = .white
                                    cell.isSelected = false
                                }, completion: nil)
                            })
                        }
                    }
                }
                
                cell.review = receivedReviews[indexPath.item]
                
                cell.senderFullnameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedFromUserProfile(sender:))))
                cell.senderProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedFromUserProfile(sender:))))
                
                cell.senderFullnameLabel.isUserInteractionEnabled = true
                cell.senderProfileImageView.isUserInteractionEnabled = true
                
                cell.receiverFullnameLabel.isUserInteractionEnabled = false
                cell.receiverProfileImageView.isUserInteractionEnabled = false
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewCell
                cell.review = sentReviews[indexPath.item]
                
                cell.receiverFullnameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedToUserProfile(sender:))))
                cell.receiverProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedToUserProfile(sender:))))
                
                cell.receiverFullnameLabel.isUserInteractionEnabled = true
                cell.receiverProfileImageView.isUserInteractionEnabled = true
                
                cell.senderFullnameLabel.isUserInteractionEnabled = false
                cell.senderProfileImageView.isUserInteractionEnabled = false
                
                return cell
            }
        }
    }
        
    func calculateElementsSize(review: Review) -> CGSize {
        let aproximateWidthOfLabel = view.frame.width - 72
        let size = CGSize(width: aproximateWidthOfLabel, height: 1000)
        let fromFullnameAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Semibold", size: 13)]
        let bodyAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Regular", size: 14)]
        
        let fullnameEstimatedFrame = NSString(string: review.fromFullname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: fromFullnameAttributes as [NSAttributedStringKey : Any], context: nil)
        
        let bodyEstimatedFrame = NSString(string: review.body).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: bodyAttributes as [NSAttributedStringKey : Any], context: nil)
        
        return CGSize(width: view.frame.width, height: fullnameEstimatedFrame.height + bodyEstimatedFrame.height + 78)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let user = self.user[indexPath.item]
            
            let aproximateWidthOfLabel = view.frame.width - 16 - 16
            let size = CGSize(width: aproximateWidthOfLabel, height: 1000)
            
            // for job_description
            let jobAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Regular", size: 14)]
            let jobDescEstimatedFrame = NSString(string: user.job_description).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: jobAttributes as [NSAttributedStringKey : Any], context: nil)
            
            // for fullname
            let fullnameAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Bold", size: 20)]
            let fullnameEstimatedFrame = NSString(string: user.fullname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: fullnameAttributes as [NSAttributedStringKey : Any], context: nil)
            
            // for email
            let emailAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Regular", size: 14)]
            let emailEstimatedFrame = NSString(string: user.email).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: emailAttributes as [NSAttributedStringKey : Any], context: nil)
            
            // for position
            let positionAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Regular", size: 14)]
            let positionEstimatedFrame = NSString(string: user.position).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: positionAttributes as [NSAttributedStringKey : Any], context: nil)
            
            // for department
            let departmentAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Regular", size: 14)]
            let departmentEstimatedFrame = NSString(string: user.department).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: departmentAttributes as [NSAttributedStringKey : Any], context: nil)
            
            if user.job_description != "" {
                return CGSize(width: view.frame.width, height: jobDescEstimatedFrame.height + fullnameEstimatedFrame.height + emailEstimatedFrame.height + positionEstimatedFrame.height + departmentEstimatedFrame.height + 191)
            } else {
                return CGSize(width: view.frame.width, height: fullnameEstimatedFrame.height + emailEstimatedFrame.height + positionEstimatedFrame.height + departmentEstimatedFrame.height + 187 + 4) // 4 for fix the excess space
            }
        } else {
            if isReceiverView {
                let receivedReview = receivedReviews[indexPath.item]
                return calculateElementsSize(review: receivedReview)
            } else {
                let sentReview = sentReviews[indexPath.item]
                return calculateElementsSize(review: sentReview)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
