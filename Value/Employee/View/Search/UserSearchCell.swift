//
//  UserSearchCell.swift
//  Value
//
//  Created by Omar Torres on 11/6/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var userViewModel: UserViewModel! {
        didSet {
            
            guard let fullnameFont = UIFont(name: "SFUIDisplay-Semibold", size: 13) else { return }
            guard let emailFont = UIFont(name: "SFUIDisplay-Regular", size: 13) else { return }
            
            let attributedText = NSMutableAttributedString(string: userViewModel.fullname, attributes: [NSAttributedStringKey.font: fullnameFont, NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 22, green: 22, blue: 22)])
            
            let userEmail = userViewModel.email
            attributedText.append(NSAttributedString(string: "\n\(userEmail)", attributes: [NSAttributedStringKey.font: emailFont, NSAttributedStringKey.foregroundColor: UIColor.gray]))
            
            userNameEmailLabel.attributedText = attributedText
            
            profileImageView.loadImage(urlString: userViewModel.profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .red
        iv.layer.cornerRadius = 40 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let userNameEmailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(profileImageView)
        addSubview(userNameEmailLabel)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        userNameEmailLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        userNameEmailLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
