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
    
    let reviewCellId = "reviewCellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white

        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserProfileFeed), name: WriteReviewController.updateUserProfileFeedNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserHeaderInfo(notification:)), name: EditProfileController.updateUserHeaderInfo, object: nil)
        
        collectionView?.register(UserProfileHeader.self, forCellWithReuseIdentifier: headerId)
        collectionView?.register(ReviewCell.self, forCellWithReuseIdentifier: reviewCellId)
        
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
                if tappedReview.fromId != userId {
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
                if tappedReview.fromId != userId {
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
                if tappedReview.toId != userId {
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
                if tappedReview.toId != userId {
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
            let header = collectionView.dequeueReusableCell(withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
            header.user = self.user[indexPath.item]
            header.delegate = self
            return header
        } else {
            if isReceiverView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewCell
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
