//
//  ReceiverReviewCell.swift
//  Value
//
//  Created by Omar Torres on 11/8/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    var review: Review? {
        didSet {
            guard let senderProfileImageUrl = review?.fromProfileImageUrl else { return }
            senderProfileImageView.loadImage(urlString: senderProfileImageUrl)
            
            senderFullnameLabel.text = review?.fromFullname
            
            messageLabel.text = review?.body
            
            guard let receiverProfileImageUrl = review?.toProfileImageUrl else { return }
            receiverProfileImageView.loadImage(urlString: receiverProfileImageUrl)
            
            receiverFullnameLabel.text = review?.toFullname
            
        }
    }
    
    let receiverProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor.rgb(red: 89, green: 119, blue: 80)
        iv.layer.cornerRadius = 40 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let senderProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor.rgb(red: 89, green: 119, blue: 80)
        iv.layer.cornerRadius = 40 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let senderFullnameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
        label.font = UIFont(name: "SFUIDisplay-Semibold", size: 13)
        label.textAlignment = .left
        return label
    }()
    
    let receiverFullnameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
        label.font = UIFont(name: "SFUIDisplay-Semibold", size: 13)
        label.textAlignment = .right
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(senderProfileImageView)
        senderProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(senderFullnameLabel)
        senderFullnameLabel.anchor(top: senderProfileImageView.topAnchor, left: senderProfileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        addSubview(messageLabel)
        messageLabel.anchor(top: senderFullnameLabel.bottomAnchor, left: senderFullnameLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        addSubview(receiverProfileImageView)
        receiverProfileImageView.anchor(top: messageLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 40, height: 40)
        
        addSubview(receiverFullnameLabel)
        receiverFullnameLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: receiverProfileImageView.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        receiverFullnameLabel.centerYAnchor.constraint(equalTo: receiverProfileImageView.centerYAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
