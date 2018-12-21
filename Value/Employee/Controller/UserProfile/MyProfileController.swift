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
    
    var user = [UserViewModel]()
    var receivedReviews = [ReviewViewModel]()
    var sentReviews = [ReviewViewModel]()
    var reviewSelected: ReviewViewModel!
    
    let userProfileCellId = "userProfileCellId"
    let userHeaderId = "headerId"
    let reviewCellId = "reviewCellId"
    
    var isFrom: Bool!
    var isReceiverView = true
    var isComingFromNotification = false
    
    var notificationReviewId: Int!
    var senderFullname: String!
    var loggedUserId: Int!
    var reviewNotificationPaintedCounter: Int = 0
    var indexPointed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getLoggedUserId()
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
        
        getAllSentReviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: updateUserHeaderInfo, object: nil)
    }
    
    func setupCollectionView() {
        collectionView?.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserHeaderInfo(notification:)), name: updateUserHeaderInfo, object: nil)
        
        collectionView?.register(UserProfileHeader.self, forCellWithReuseIdentifier: userHeaderId)
        collectionView?.register(ReviewCell.self, forCellWithReuseIdentifier: reviewCellId)
    }
    
    func getLoggedUserId() {
        guard let userIdFromKeyChain = Locksmith.loadDataForUserAccount(userAccount: "currentUserId") else { return }
        loggedUserId = userIdFromKeyChain["id"] as? Int
    }
    
    func fetchUser() {
        ApiService.shared.fetchUserProfileInfo(userId: loggedUserId) { (user) in
            let finalUser = UserViewModel(user: user)
            self.user.append(finalUser)
            self.collectionView?.reloadData()
        }
    }
    
    func getAllReceivedReviews(completion: @escaping Callback) {
        ApiService.shared.fetchReceivedReviews(userId: loggedUserId) { (review) in
            let finalReview = ReviewViewModel(review: review)
            self.receivedReviews.append(finalReview)
            self.collectionView?.reloadData()
        }
    }
    
    func getAllSentReviews() {
        ApiService.shared.fetchSentReviews(userId: loggedUserId) { (review) in
            let finalReview = ReviewViewModel(review: review)
            self.sentReviews.append(finalReview)
            self.collectionView?.reloadData()
        }
    }
    
    @objc func handleUpdateUserHeaderInfo(notification: Notification) {
        user.removeAll()
        fetchUser()
    }
    
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
    
    @objc func senderProfileImageHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = true
        Helpers.shared.highlightItemWhenTapped(isFromHome: false, userId: loggedUserId, isFrom: true, sender: sender, collectionView: self.collectionView!, receivedReviews: receivedReviews, isUserProfileImage: true) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    @objc func senderFullnameHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = true
        Helpers.shared.highlightItemWhenTapped(isFromHome: false, userId: loggedUserId, isFrom: true, sender: sender, collectionView: self.collectionView!, receivedReviews: receivedReviews, isUserProfileImage: false) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    @objc func receiverProfileImageHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = false
        Helpers.shared.highlightItemWhenTapped(isFromHome: false, userId: loggedUserId, isFrom: false, sender: sender, collectionView: self.collectionView!, sentReviews: sentReviews, isUserProfileImage: true) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    @objc func receiverFullnameHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = false
        Helpers.shared.highlightItemWhenTapped(isFromHome: false, userId: loggedUserId, isFrom: false, sender: sender, collectionView: self.collectionView!, sentReviews: sentReviews, isUserProfileImage: false) { (review) in
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableCell(withReuseIdentifier: userHeaderId, for: indexPath) as! UserProfileHeader
            header.backgroundColor = .yellow
            header.userViewModel = self.user[indexPath.item]
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
                
                cell.reviewViewModel = receivedReviews[indexPath.item]
                
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewCell
                cell.reviewViewModel = sentReviews[indexPath.item]
                
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
