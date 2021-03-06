//
//  ReceiverReviewCell.swift
//  Value
//
//  Created by Omar Torres on 11/8/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    var reviewViewModel: ReviewViewModel! {
        didSet {
            
            valueLabel.text = reviewViewModel.value
            
            senderProfileImageView.loadImage(urlString: reviewViewModel.fromProfileImageUrl)
            
            senderFullnameLabel.text = reviewViewModel.fromFullname
            senderEmailLabel.text = reviewViewModel.fromEmail
            
            messageLabel.text = reviewViewModel.body
            
            receiverProfileImageView.loadImage(urlString: reviewViewModel.toProfileImageUrl)
            
            receiverEmailLabel.text = reviewViewModel.toEmail
            receiverFullnameLabel.text = reviewViewModel.toFullname
        }
    }
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.sizeToFit()
        label.textColor = UIColor.rgb(red: 54, green: 139, blue: 85)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFUIDisplay-Bold", size: 15)
        label.textAlignment = .left
        return label
    }()
    
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
        label.sizeToFit()
        label.backgroundColor = .red
        label.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFUIDisplay-Semibold", size: 13)
        label.textAlignment = .left
        return label
    }()
    
    let senderEmailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 13)
        label.textAlignment = .left
        return label
    }()
    
    let receiverFullnameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.sizeToFit()
        label.backgroundColor = .red
        label.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFUIDisplay-Semibold", size: 13)
        label.textAlignment = .right
        return label
    }()
    
    let receiverEmailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 13)
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
    
    let arrowDown: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "arrow").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .gray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(valueLabel)
        valueLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        valueLabel.widthAnchor.constraint(lessThanOrEqualToConstant: self.frame.width - 24).isActive = true
        
        addSubview(senderProfileImageView)
        senderProfileImageView.anchor(top: valueLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(senderFullnameLabel)
        senderFullnameLabel.anchor(top: senderProfileImageView.topAnchor, left: senderProfileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        senderFullnameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: self.frame.width - 72).isActive = true
        
        addSubview(senderEmailLabel)
        senderEmailLabel.anchor(top: senderFullnameLabel.bottomAnchor, left: senderFullnameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        senderEmailLabel.widthAnchor.constraint(lessThanOrEqualToConstant: self.frame.width - 72).isActive = true
        
        addSubview(messageLabel)
        messageLabel.anchor(top: senderEmailLabel.bottomAnchor, left: senderFullnameLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        addSubview(receiverProfileImageView)
        receiverProfileImageView.anchor(top: messageLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 40, height: 40)
        
        addSubview(receiverEmailLabel)
        receiverEmailLabel.anchor(top: nil, left: nil, bottom: receiverProfileImageView.bottomAnchor, right: receiverProfileImageView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        receiverEmailLabel.widthAnchor.constraint(lessThanOrEqualToConstant: self.frame.width - 72).isActive = true
        
        addSubview(receiverFullnameLabel)
        receiverFullnameLabel.anchor(top: nil, left: nil, bottom: receiverEmailLabel.topAnchor, right: receiverEmailLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        receiverFullnameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: self.frame.width - 72).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
