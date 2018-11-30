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
    
    var user = [User]()
    var receivedReviews = [Review]()
    var sentReviews = [Review]()
    var reviewSelected: Review!
    var isFrom: Bool!
    var isInfoUpdated: Bool! = false
    
    var userId: Int?
    var userFullname: String?
    var userImageUrl: String?
    
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
    
    func didTapToEditProfileController() {
        let editProfileController = EditProfileController()
        
        let navController = UINavigationController(rootViewController: editProfileController)
        present(navController, animated: true, completion: nil)
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "back_button"), for: .normal)
        button.backgroundColor = UIColor.mainBlue()
        button.addTarget(self, action: #selector(backToRootVC), for: .touchUpInside)
        return button
    }()
    
    let reviewCell = "reviewCell"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white

        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserProfileFeed), name: WriteReviewController.updateUserProfileFeedNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserHeaderInfo(notification:)), name: EditProfileController.updateUserHeaderInfo, object: nil)
        
        collectionView?.register(UserProfileHeader.self, forCellWithReuseIdentifier: headerId)
        collectionView?.register(ReviewCell.self, forCellWithReuseIdentifier: reviewCell)
        
        fetchUser()
        getAllReviews()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: WriteReviewController.updateUserProfileFeedNotificationName, object: nil)
        NotificationCenter.default.removeObserver(self, name: EditProfileController.updateUserHeaderInfo, object: nil)
    }
    
    func fetchUser() {
        ApiService.shared.fetchUserProfileInfo(userId: userId!) { (user) in
            self.user.append(user)
            self.userFullname = user.fullname
            self.userImageUrl = user.profileImageUrl
            self.collectionView?.reloadData()
        }
    }
    
    @objc func handleUpdateUserProfileFeed() {
        receivedReviews.removeAll()
        getAllReviews()
    }
    
    @objc func handleUpdateUserHeaderInfo(notification: Notification) {
        user.removeAll()
        fetchUser()
    }
    
    @objc func backToRootVC() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func getAllReviews() {
        
        ApiService.shared.fetchUserReceivedReviews(userId: userId!) { (review) in
            self.receivedReviews.append(review)
            self.collectionView?.reloadData()
        }
        
        ApiService.shared.fetchUserSentReviews(userId: userId!) { (review) in
            self.sentReviews.append(review)
            self.collectionView?.reloadData()
        }
        
    }
    
    @objc func senderProfileImageHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = true
        Helpers.shared.highlightItemWhenTapped(isFromHome: false, userId: userId!, isFrom: true, sender: sender, collectionView: self.collectionView!, receivedReviews: receivedReviews, isUserProfileImage: true) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    @objc func senderFullnameHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = true
        Helpers.shared.highlightItemWhenTapped(isFromHome: false, userId: userId!, isFrom: true, sender: sender, collectionView: self.collectionView!, receivedReviews: receivedReviews, isUserProfileImage: false) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    @objc func receiverProfileImageHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = false
        Helpers.shared.highlightItemWhenTapped(isFromHome: false, userId: userId!, isFrom: false, sender: sender, collectionView: self.collectionView!, sentReviews: sentReviews, isUserProfileImage: true) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    @objc func receiverFullnameHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = false
        Helpers.shared.highlightItemWhenTapped(isFromHome: false, userId: userId!, isFrom: false, sender: sender, collectionView: self.collectionView!, sentReviews: sentReviews, isUserProfileImage: false) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    func showUserProfile() {
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        
        if isFrom {
            userProfileController.userId = reviewSelected.fromId
        } else {
            userProfileController.userId = reviewSelected.toId
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
            let header = collectionView.dequeueReusableCell(withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
            header.user = self.user[indexPath.item]
            header.delegate = self
            return header
        } else {
            if isReceiverView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCell, for: indexPath) as! ReviewCell
                cell.review = receivedReviews[indexPath.item]
                
                let senderProfileImageTap = UILongPressGestureRecognizer(target: self, action: #selector(senderProfileImageHighlightWhentapped(_:)))
                senderProfileImageTap.minimumPressDuration = 0
                cell.senderProfileImageView.addGestureRecognizer(senderProfileImageTap)
                cell.senderProfileImageView.isUserInteractionEnabled = true
                
                let senderFullnameTap = UILongPressGestureRecognizer(target: self, action: #selector(senderFullnameHighlightWhentapped(_:)))
                senderFullnameTap.minimumPressDuration = 0
                cell.senderFullnameLabel.addGestureRecognizer(senderFullnameTap)
                cell.senderFullnameLabel.isUserInteractionEnabled = true
                
                cell.receiverFullnameLabel.isUserInteractionEnabled = false
                cell.receiverProfileImageView.isUserInteractionEnabled = false
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCell, for: indexPath) as! ReviewCell
                cell.review = sentReviews[indexPath.item]
                
                let receiverProfileImageTap = UILongPressGestureRecognizer(target: self, action: #selector(receiverProfileImageHighlightWhentapped(_:)))
                receiverProfileImageTap.minimumPressDuration = 0
                cell.receiverProfileImageView.addGestureRecognizer(receiverProfileImageTap)
                cell.receiverProfileImageView.isUserInteractionEnabled = true
                
                let receiverFullnameTap = UILongPressGestureRecognizer(target: self, action: #selector(receiverFullnameHighlightWhentapped(_:)))
                receiverFullnameTap.minimumPressDuration = 0
                cell.receiverFullnameLabel.addGestureRecognizer(receiverFullnameTap)
                cell.receiverFullnameLabel.isUserInteractionEnabled = true
                
                cell.senderFullnameLabel.isUserInteractionEnabled = false
                cell.senderProfileImageView.isUserInteractionEnabled = false
                
                return cell
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let user = self.user[indexPath.item]
            return Helpers.shared.calculateHeaderSize(user: user, view: view)
        } else {
            if isReceiverView {
                let receivedReview = receivedReviews[indexPath.item]
                return Helpers.shared.calculateCellSize(review: receivedReview, view: view)
            } else {
                let sentReview = sentReviews[indexPath.item]
                return Helpers.shared.calculateCellSize(review: sentReview, view: view)
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
