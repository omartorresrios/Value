//
//  FeedReviewCell.swift
//  Value
//
//  Created by Omar Torres on 11/14/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit

class FeedReviewCell: UICollectionViewCell {
    
    var review: Review? {
        didSet {
            guard let senderProfileImageUrl = review?.fromProfileImageUrl else { return }
            senderProfileImageView.loadImage(urlString: senderProfileImageUrl)
            
            senderFullnameLabel.text = review?.fromFullname
            senderEmailLabel.text = review?.fromEmail
            
            messageLabel.text = review?.body
            
            guard let receiverProfileImageUrl = review?.toProfileImageUrl else { return }
            receiverProfileImageView.loadImage(urlString: receiverProfileImageUrl)
            
            let attributedText = NSMutableAttributedString(string: "\(review!.toFullname)\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
            
            attributedText.append(NSAttributedString(string: "\(review!.toEmail)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
            
            receiverUserDataLabel.attributedText = attributedText
            
        }
    }
    
    let receiverProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 50 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let senderProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 50 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let senderFullnameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)//UIFont(name: "SFUIDisplay-Semibold", size: 10)
        label.textAlignment = .left
        return label
    }()
    
    let senderEmailLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)//UIFont(name: "SFUIDisplay-Semibold", size: 10)
        label.textAlignment = .left
        return label
    }()
    
    let receiverUserDataLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    let arrowDown: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "arrow").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .gray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        addSubview(senderProfileImageView)
        senderProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        addSubview(senderFullnameLabel)
        senderFullnameLabel.anchor(top: senderProfileImageView.topAnchor, left: senderProfileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        addSubview(senderEmailLabel)
        senderEmailLabel.anchor(top: senderFullnameLabel.bottomAnchor, left: senderFullnameLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        addSubview(messageLabel)
        messageLabel.anchor(top: senderEmailLabel.bottomAnchor, left: senderFullnameLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        addSubview(receiverProfileImageView)
        receiverProfileImageView.anchor(top: messageLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        addSubview(receiverUserDataLabel)
        receiverUserDataLabel.anchor(top: nil, left: receiverProfileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        receiverUserDataLabel.centerYAnchor.constraint(equalTo: receiverProfileImageView.centerYAnchor).isActive = true
        
        //        addSubview(arrowDown)
        //        arrowDown.anchor(top: topAnchor, left: nil, bottom: messageLabel.bottomAnchor, right: nil, paddingTop: 66, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 20, height: 0)
        //        arrowDown.centerXAnchor.constraint(equalTo: senderProfileImageView.centerXAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

