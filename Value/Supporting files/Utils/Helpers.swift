//
//  Helpers.swift
//  Value
//
//  Created by Omar Torres on 11/29/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import Locksmith

class Helpers {
    
    static let shared = Helpers()
    
    func highlightItemWhenTapped(isFromHome: Bool, userId: Int? = nil, isFrom: Bool, sender: UITapGestureRecognizer, collectionView: UICollectionView, reviews: [Review]? = nil, receivedReviews: [Review]? = nil, sentReviews: [Review]? = nil, isUserProfileImage: Bool, completion: @escaping (Review) -> ()) {
        
        let position = sender.location(in: collectionView)
        guard let index = collectionView.indexPathForItem(at: position) else {
            print("Error, label not in collectionView")
            return
        }
        
        if isFrom {
            let tappedReview: Review!
            if isFromHome {
                tappedReview = reviews?[index.item]
            } else {
                tappedReview = receivedReviews?[index.item]
            }
            
            if let cell = collectionView.cellForItem(at: index) as? ReviewCell {
                
                if sender.state == .began {
                    if isUserProfileImage {
                        let tintView = UIView()
                        tintView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                        tintView.frame = CGRect(x: 0, y: 0, width: cell.senderProfileImageView.frame.width, height: cell.senderProfileImageView.frame.height)
                        cell.senderProfileImageView.addSubview(tintView)
                    } else {
                        cell.senderFullnameLabel.textColor = .red
                    }
                    
                } else if sender.state == .changed {
                    sender.cancel()
                    if isUserProfileImage {
                        cell.senderProfileImageView.clearSubviews()
                    } else {
                        cell.senderFullnameLabel.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
                    }
                    
                } else if sender.state == .ended {
                    if isUserProfileImage {
                        cell.senderProfileImageView.clearSubviews()
                        if isFromHome {
                            completion(tappedReview)
                        } else {
                            if tappedReview.fromId != userId {
                                completion(tappedReview)
                            }
                        }
                        
                    } else {
                        cell.senderFullnameLabel.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
                        if isFromHome {
                            completion(tappedReview)
                        } else {
                            if tappedReview.fromId != userId {
                                completion(tappedReview)
                            }
                        }
                        
                    }
                }
            } else {
                print("SO SORRY")
            }
            
        } else {
            
            let tappedReview: Review!
            if isFromHome {
                tappedReview = reviews?[index.item]
            } else {
                tappedReview = sentReviews?[index.item]
            }
            
            if let cell = collectionView.cellForItem(at: index) as? ReviewCell {
                
                if sender.state == .began {
                    if isUserProfileImage {
                        let tintView = UIView()
                        tintView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                        tintView.frame = CGRect(x: 0, y: 0, width: cell.receiverProfileImageView.frame.width, height: cell.receiverProfileImageView.frame.height)
                        cell.receiverProfileImageView.addSubview(tintView)
                    } else {
                        cell.receiverFullnameLabel.textColor = .red
                    }
                    
                } else if sender.state == .changed {
                    sender.cancel()
                    if isUserProfileImage {
                        cell.receiverProfileImageView.clearSubviews()
                    } else {
                        cell.receiverFullnameLabel.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
                    }
                    
                } else if sender.state == .ended {
                    if isUserProfileImage {
                        cell.receiverProfileImageView.clearSubviews()
                        if isFromHome {
                            completion(tappedReview)
                        } else {
                            if tappedReview.toId != userId {
                                completion(tappedReview)
                            }
                        }
                        
                    } else {
                        cell.receiverFullnameLabel.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
                        if isFromHome {
                            completion(tappedReview)
                        } else {
                            if tappedReview.toId != userId {
                                completion(tappedReview)
                            }
                        }
                        
                    }
                }
            } else {
                print("SO SORRY")
            }
        }
    }
    
    func calculateCellSize(review: Review, view: UIView) -> CGSize {
        
        let aproximateWidthOfLabel = view.frame.width - 72
        let size = CGSize(width: aproximateWidthOfLabel, height: 1000)
        
        let valueAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Bold", size: 15)]
        let valueEstimatedFrame = NSString(string: review.value).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: valueAttributes as [NSAttributedStringKey : Any], context: nil)
        
        let fromFullnameAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Semibold", size: 13)]
        let fullnameEstimatedFrame = NSString(string: review.fromFullname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: fromFullnameAttributes as [NSAttributedStringKey : Any], context: nil)
        
        let fromEmailAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Regular", size: 13)]
        let emailEstimatedFrame = NSString(string: review.fromEmail).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: fromEmailAttributes as [NSAttributedStringKey : Any], context: nil)
        
        let bodyAttributes = [NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Regular", size: 14)]
        let bodyEstimatedFrame = NSString(string: review.body).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: bodyAttributes as [NSAttributedStringKey : Any], context: nil)
        
        return CGSize(width: view.frame.width, height: valueEstimatedFrame.height + fullnameEstimatedFrame.height + emailEstimatedFrame.height + bodyEstimatedFrame.height + 92)
        
    }
    
    func calculateHeaderSize(user: User, view: UIView) -> CGSize {
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
        let departmentEstimatedFrame = NSString(string: user.departmentName).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: departmentAttributes as [NSAttributedStringKey : Any], context: nil)
        
        if user.job_description != "" {
            return CGSize(width: view.frame.width, height: jobDescEstimatedFrame.height + fullnameEstimatedFrame.height + emailEstimatedFrame.height + positionEstimatedFrame.height + departmentEstimatedFrame.height + 191)
        } else {
            return CGSize(width: view.frame.width, height: fullnameEstimatedFrame.height + emailEstimatedFrame.height + positionEstimatedFrame.height + departmentEstimatedFrame.height + 187 + 4) // 4 for fix the excess space
        }
        
    }
    
    func logoutUser(completion: @escaping (Bool) -> ()) {
        clearLoggedinFlagInUserDefaults()
        clearAPITokensFromKeyChain()
        
        DispatchQueue.main.async {
            completion(true)
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
}
