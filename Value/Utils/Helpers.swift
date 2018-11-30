//
//  Helpers.swift
//  Value
//
//  Created by Omar Torres on 11/29/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit

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
            
            if let cell = collectionView.cellForItem(at: index) as? HomeReviewCell {
                
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
            
            if let cell = collectionView.cellForItem(at: index) as? HomeReviewCell {
                
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
    
}
