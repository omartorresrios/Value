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
    var reviewSelected: Review!
    var isFrom: Bool!
    
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
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        print("Handling refresh..")
        receivedReviews.removeAll()
        getAllReviews()
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
    
    @objc func tappedFromUserProfile(sender: UIGestureRecognizer) {
        isFrom = true
        let position = sender.location(in: collectionView)
        guard let index = collectionView?.indexPathForItem(at: position) else {
            print("Error, label not in collectionView")
            return
        }
        
        let tappedReview = receivedReviews[index.item]
        reviewSelected = tappedReview
        
        guard let userIdFromKeyChain = Locksmith.loadDataForUserAccount(userAccount: "currentUserId") else { return }
        let loggedUserId = userIdFromKeyChain["id"] as! Int
        
        if tappedReview.fromId != loggedUserId && tappedReview.fromId != userId {
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
        
        guard let userIdToKeyChain = Locksmith.loadDataForUserAccount(userAccount: "currentUserId") else { return }
        let loggedUserId = userIdToKeyChain["id"] as! Int
        
        if tappedReview.toId != loggedUserId && tappedReview.toId != userId {
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
        if isReceiverView {
            let receivedReview = receivedReviews[indexPath.item]
            return calculateElementsSize(review: receivedReview)
        } else {
            let sentReview = sentReviews[indexPath.item]
            return calculateElementsSize(review: sentReview)
        }
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
