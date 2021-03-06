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

    let logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("logout", for: .normal)
        return button
    }()
    
    let reviewCell = "reviewCell"
    
    var reviewViewModels = [ReviewViewModel]()
    var reviewSelected: ReviewViewModel!
    
    var isFrom: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getAllReviews()
    }
    
    func setupCollectionView() {
        collectionView?.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "logout", style: .done, target: self, action: #selector(handleLogout))
        
        collectionView?.register(ReviewCell.self, forCellWithReuseIdentifier: reviewCell)
    }
    
    func getAllReviews() {
        ApiService.shared.fetchAllReviews { (review) in
            
            let finalReview = ReviewViewModel(review: review)
            
            self.reviewViewModels.append(finalReview)
            self.reviewViewModels.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.collectionView?.reloadData()
        }
    }
    
    @objc func senderProfileImageHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = true
        Helpers.shared.highlightItemWhenTapped(isFromHome: true, isFrom: true, sender: sender, collectionView: collectionView!, reviews: reviewViewModels, isUserProfileImage: true) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    @objc func senderFullnameHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = true
        Helpers.shared.highlightItemWhenTapped(isFromHome: true, isFrom: true, sender: sender, collectionView: collectionView!, reviews: reviewViewModels, isUserProfileImage: false) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    @objc func receiverProfileImageHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = false
        Helpers.shared.highlightItemWhenTapped(isFromHome: true, isFrom: false, sender: sender, collectionView: collectionView!, reviews: reviewViewModels, isUserProfileImage: true) { (review) in
            self.reviewSelected = review
            self.showUserProfile()
        }
    }
    
    @objc func receiverFullnameHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = false
        Helpers.shared.highlightItemWhenTapped(isFromHome: true, isFrom: false, sender: sender, collectionView: collectionView!, reviews: reviewViewModels, isUserProfileImage: false) { (review) in
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
        Helpers.shared.logoutUser { (success) in
            if success {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewViewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCell, for: indexPath) as! ReviewCell
        cell.reviewViewModel = reviewViewModels[indexPath.item]
        
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
        let review = reviewViewModels[indexPath.item]
        return Helpers.shared.calculateCellSize(review: review, view: view)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
