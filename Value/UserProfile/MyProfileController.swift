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
        collectionView?.backgroundColor = .white
        
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

        getAllSentReviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: EditProfileController.updateUserHeaderInfo, object: nil)
    }
    
    @objc func handleUpdateUserHeaderInfo(notification: Notification) {
        user.removeAll()
        fetchUser()
    }
    
    func fetchUser() {
        ApiService.shared.fetchUserProfileInfo(userId: loggedUserId) { (user) in
            self.user.append(user)
            self.collectionView?.reloadData()
        }
    }
    
    func getAllReceivedReviews(completion: @escaping Callback) {
        ApiService.shared.fetchUserReceivedReviews(userId: loggedUserId) { (review) in
            self.receivedReviews.append(review)
            self.collectionView?.reloadData()
            completion(true)
        }
    }
    
    func getAllSentReviews() {
        ApiService.shared.fetchUserSentReviews(userId: loggedUserId) { (review) in
            self.sentReviews.append(review)
            self.collectionView?.reloadData()
        }
    }
    
    @objc func senderProfileImageHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = true
        let position = sender.location(in: collectionView)
        guard let index = collectionView?.indexPathForItem(at: position) else {
            print("Error, label not in collectionView")
            return
        }
        
        let tappedReview = receivedReviews[index.item]
        reviewSelected = tappedReview
        
        if let cell = collectionView?.cellForItem(at: index) as? ReviewCell {
            let tintView = UIView()
            if sender.state == .began {
                tintView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                tintView.frame = CGRect(x: 0, y: 0, width: cell.senderProfileImageView.frame.width, height: cell.senderProfileImageView.frame.height)
                cell.senderProfileImageView.addSubview(tintView)
            } else if sender.state == .changed {
                cell.senderProfileImageView.clearSubviews()
            } else if sender.state == .ended {
                cell.senderProfileImageView.clearSubviews()
                if tappedReview.fromId != loggedUserId {
                    showUserProfile()
                }
            }
        } else {
            print("SO SORRY")
        }
    }
    
    @objc func senderFullnameHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = true
        let position = sender.location(in: collectionView)
        guard let index = collectionView?.indexPathForItem(at: position) else {
            print("Error, label not in collectionView")
            return
        }
        
        let tappedReview = receivedReviews[index.item]
        reviewSelected = tappedReview
        
        if let cell = collectionView?.cellForItem(at: index) as? ReviewCell {
            if sender.state == .began {
                cell.senderFullnameLabel.textColor = .red
            } else if sender.state == .changed {
                cell.senderFullnameLabel.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
            } else if sender.state == .ended {
                cell.senderFullnameLabel.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
                if tappedReview.fromId != loggedUserId {
                    showUserProfile()
                }
            }
        } else {
            print("SO SORRY")
        }
    }
    
    @objc func receiverProfileImageHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = false
        let position = sender.location(in: collectionView)
        guard let index = collectionView?.indexPathForItem(at: position) else {
            print("Error, label not in collectionView")
            return
        }
        
        let tappedReview = sentReviews[index.item]
        reviewSelected = tappedReview
        
        if let cell = collectionView?.cellForItem(at: index) as? ReviewCell {
            let tintView = UIView()
            if sender.state == .began {
                tintView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                tintView.frame = CGRect(x: 0, y: 0, width: cell.receiverProfileImageView.frame.width, height: cell.receiverProfileImageView.frame.height)
                cell.receiverProfileImageView.addSubview(tintView)
            } else if sender.state == .changed {
                cell.receiverProfileImageView.clearSubviews()
            } else if sender.state == .ended {
                cell.receiverProfileImageView.clearSubviews()
                if tappedReview.toId != loggedUserId {
                    showUserProfile()
                }
            }
        } else {
            print("SO SORRY")
        }
    }
    
    @objc func receiverFullnameHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = false
        let position = sender.location(in: collectionView)
        guard let index = collectionView?.indexPathForItem(at: position) else {
            print("Error, label not in collectionView")
            return
        }
        
        let tappedReview = sentReviews[index.item]
        reviewSelected = tappedReview
        
        if let cell = collectionView?.cellForItem(at: index) as? ReviewCell {
            if sender.state == .began {
                cell.receiverFullnameLabel.textColor = .red
            } else if sender.state == .changed {
                cell.receiverFullnameLabel.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
            } else if sender.state == .ended {
                cell.receiverFullnameLabel.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
                if tappedReview.toId != loggedUserId {
                    showUserProfile()
                }
            }
        } else {
            print("SO SORRY")
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
