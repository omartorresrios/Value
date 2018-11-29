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
                    print("THE ALL REVIEWS JSON: \(JSON)")
                    
                    //                    let jsonArray = JSON as! NSDictionary
                    //
                                        let dataArray = JSON as! NSArray
                    //
                                        dataArray.forEach({ (value) in
                                            guard let reviewDictionary = value as? [String: Any] else { return }
                                            print("this is reviewDictionary: \(reviewDictionary)")
                    
                                            let newReview = Review(reviewDictionary: reviewDictionary)
                    
                                            self.reviews.append(newReview)
                                            
                                            self.collectionView?.reloadData()
                    
                                        })
                    
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
    
    @objc func senderProfileImageHighlightWhentapped(_ sender: UITapGestureRecognizer) {
        isFrom = true
        let position = sender.location(in: collectionView)
        guard let index = collectionView?.indexPathForItem(at: position) else {
            print("Error, label not in collectionView")
            return
        }
        
        let tappedReview = reviews[index.item]
        reviewSelected = tappedReview
        
        if let cell = collectionView?.cellForItem(at: index) as? HomeReviewCell {
            let tintView = UIView()
            if sender.state == .began {
                tintView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                tintView.frame = CGRect(x: 0, y: 0, width: cell.senderProfileImageView.frame.width, height: cell.senderProfileImageView.frame.height)
                cell.senderProfileImageView.addSubview(tintView)
            } else if sender.state == .changed {
                cell.senderProfileImageView.clearSubviews()
            } else if sender.state == .ended {
                cell.senderProfileImageView.clearSubviews()
                showUserProfile()
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
        
        let tappedReview = reviews[index.item]
        reviewSelected = tappedReview
        
        if let cell = collectionView?.cellForItem(at: index) as? HomeReviewCell {
            if sender.state == .began {
                cell.senderFullnameLabel.textColor = .red
            } else if sender.state == .changed {
                cell.senderFullnameLabel.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
            } else if sender.state == .ended {
                cell.senderFullnameLabel.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
                showUserProfile()
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
        
        let tappedReview = reviews[index.item]
        reviewSelected = tappedReview
        
        if let cell = collectionView?.cellForItem(at: index) as? HomeReviewCell {
            let tintView = UIView()
            if sender.state == .began {
                tintView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                tintView.frame = CGRect(x: 0, y: 0, width: cell.receiverProfileImageView.frame.width, height: cell.receiverProfileImageView.frame.height)
                cell.receiverProfileImageView.addSubview(tintView)
            } else if sender.state == .changed {
                cell.receiverProfileImageView.clearSubviews()
            } else if sender.state == .ended {
                cell.receiverProfileImageView.clearSubviews()
                showUserProfile()
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
        
        let tappedReview = reviews[index.item]
        reviewSelected = tappedReview
        
        if let cell = collectionView?.cellForItem(at: index) as? HomeReviewCell {
            if sender.state == .began {
                cell.receiverFullnameLabel.textColor = .red
            } else if sender.state == .changed {
                cell.receiverFullnameLabel.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
            } else if sender.state == .ended {
                cell.receiverFullnameLabel.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
                showUserProfile()
            }
        } else {
            print("SO SORRY")
        }
    }
    
    
    
    func showUserProfile() {
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        
        if isFrom == true {
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
