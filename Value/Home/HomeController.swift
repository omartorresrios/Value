//
//  HomeController.swift
//  Value
//
//  Created by Omar Torres on 11/14/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let homeReviewCell = "homeReviewCell"
    var reviews = [Review]()
    var reviewSelected: Review!
    var isFrom: Bool!
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("logout", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "logout", style: .done, target: self, action: #selector(handleLogout))
        
        collectionView?.register(HomeReviewCell.self, forCellWithReuseIdentifier: homeReviewCell)
        
        getAllReviews()
        
    }
    
    func getAllReviews() {
        ApiService.shared.fetchAllReviews { (review) in
            self.reviews.append(review)
            self.reviews.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.collectionView?.reloadData()
        }
    }
    
    @objc func senderProfileImageHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = true
        Helpers.shared.highlightItemWhenTapped(isFromHome: true, isFrom: true, sender: sender, collectionView: collectionView!, reviews: reviews, isUserProfileImage: true) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    @objc func senderFullnameHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = true
        Helpers.shared.highlightItemWhenTapped(isFromHome: true, isFrom: true, sender: sender, collectionView: collectionView!, reviews: reviews, isUserProfileImage: false) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    @objc func receiverProfileImageHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = false
        Helpers.shared.highlightItemWhenTapped(isFromHome: true, isFrom: false, sender: sender, collectionView: collectionView!, reviews: reviews, isUserProfileImage: true) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    @objc func receiverFullnameHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = false
        Helpers.shared.highlightItemWhenTapped(isFromHome: true, isFrom: false, sender: sender, collectionView: collectionView!, reviews: reviews, isUserProfileImage: false) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    func showUserProfile() {
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        
        if isFrom == true {
            userProfileController.userId = reviewSelected.fromId
        } else {
            userProfileController.userId = reviewSelected.toId
        }
        
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    @objc func handleLogout() {
        clearLoggedinFlagInUserDefaults()
        clearAPITokensFromKeyChain()
        
        DispatchQueue.main.async {
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    // Clear the NSUserDefaults flag
    func clearLoggedinFlagInUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userLoggedIn")
        defaults.synchronize()
    }
    
    // Clear API Auth token from Keychain
    func clearAPITokensFromKeyChain() {
        // clear API Auth Token
        try! Locksmith.deleteDataForUserAccount(userAccount: "AuthToken")
        try! Locksmith.deleteDataForUserAccount(userAccount: "currentUserId")
        try! Locksmith.deleteDataForUserAccount(userAccount: "currentUserName")
        try! Locksmith.deleteDataForUserAccount(userAccount: "currentUserEmail")
        try! Locksmith.deleteDataForUserAccount(userAccount: "currentUserAvatar")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeReviewCell, for: indexPath) as! HomeReviewCell
        cell.review = reviews[indexPath.item]
        
        let senderProfileImageTap = UILongPressGestureRecognizer(target: self, action: #selector(senderProfileImageHighlightWhentapped(_:)))
        senderProfileImageTap.minimumPressDuration = 0
        cell.senderProfileImageView.addGestureRecognizer(senderProfileImageTap)
        cell.senderProfileImageView.isUserInteractionEnabled = true
        
        let senderFullnameTap = UILongPressGestureRecognizer(target: self, action: #selector(senderFullnameHighlightWhentapped(_:)))
        senderFullnameTap.minimumPressDuration = 0
        cell.senderFullnameLabel.addGestureRecognizer(senderFullnameTap)
        cell.senderFullnameLabel.isUserInteractionEnabled = true
        
        let receiverProfileImageTap = UILongPressGestureRecognizer(target: self, action: #selector(receiverProfileImageHighlightWhentapped(_:)))
        receiverProfileImageTap.minimumPressDuration = 0
        cell.receiverProfileImageView.addGestureRecognizer(receiverProfileImageTap)
        cell.receiverProfileImageView.isUserInteractionEnabled = true
        
        let receiverFullnameTap = UILongPressGestureRecognizer(target: self, action: #selector(receiverFullnameHighlightWhentapped(_:)))
        receiverFullnameTap.minimumPressDuration = 0
        cell.receiverFullnameLabel.addGestureRecognizer(receiverFullnameTap)
        cell.receiverFullnameLabel.isUserInteractionEnabled = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let review = reviews[indexPath.item]
        
        let aproximateWidthOfLabel = view.frame.width - 72
        let size = CGSize(width: aproximateWidthOfLabel, height: 1000)
        
        let fromFullnameAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Semibold", size: 13)]
        let fullnameEstimatedFrame = NSString(string: review.fromFullname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: fromFullnameAttributes as [NSAttributedStringKey : Any], context: nil)
        
        let fromEmailAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Regular", size: 13)]
        let emailEstimatedFrame = NSString(string: review.fromEmail).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: fromEmailAttributes as [NSAttributedStringKey : Any], context: nil)
        
        let bodyAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Regular", size: 14)]
        let bodyEstimatedFrame = NSString(string: review.body).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: bodyAttributes as [NSAttributedStringKey : Any], context: nil)
        
        return CGSize(width: view.frame.width, height: fullnameEstimatedFrame.height + emailEstimatedFrame.height + bodyEstimatedFrame.height + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
