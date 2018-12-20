//
//  UserProfileHeader.swift
//  Value
//
//  Created by Omar Torres on 11/8/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import Locksmith

protocol UserProfileHeaderDelegate {
    func didChangeToSenderView()
    func didChangeToReceiverView()
    func didTapToWriteController()
    func didTapToEditProfileController()
}

class UserProfileHeader: UICollectionViewCell {

    var delegate: UserProfileHeaderDelegate?

    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            
            fullnameLabel.text = user?.fullname
            jobDescriptionLabel.text = user?.job_description
            emailLabel.text = user?.email
            positionLabel.text = user?.position
            departmentLabel.text = user?.departmentName
            
            setupEditWriteButton()
            
            setupBottomToolbar()
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 80 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let fullnameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
        label.font = UIFont(name: "SFUIDisplay-Bold", size: 20)
        label.textAlignment = .left
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        label.textAlignment = .left
        return label
    }()
    
    let positionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        label.textAlignment = .left
        return label
    }()
    
    let jobDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        label.textAlignment = .left
        return label
    }()
    
    let departmentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        label.textAlignment = .left
        return label
    }()
    
    lazy var writeReviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dejar reseña", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.mainBlue(), for: .normal)
        button.titleLabel?.font = UIFont(name: "SFUIDisplay-Semibold", size: 15)
        button.layer.borderColor = UIColor.mainBlue().cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleShowWriteEditProfile), for: .touchUpInside)
        return button
    }()
    
    lazy var receiverButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "ranking_unselected"), for: .normal)
        button.setTitle("Recibidos", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.addTarget(self, action: #selector(handleChangeToReceiverView), for: .touchUpInside)
        return button
    }()
    
    func setupEditWriteButton() {
        guard let userIdToKeyChain = Locksmith.loadDataForUserAccount(userAccount: employeeKeychainIdAccount) else { return }
        let currentUserId = userIdToKeyChain["id"] as! Int
        
        guard let userId = user?.id else { return }
        
        if currentUserId == userId {
            writeReviewButton.setTitle("Editar perfil", for: .normal)
        } else {
            writeReviewButton.setTitle("Dejar reseña", for: .normal)
        }
    }
    
    @objc func handleShowWriteEditProfile() {
        if writeReviewButton.titleLabel?.text == "Dejar reseña" {
            delegate?.didTapToWriteController()
        } else {
            delegate?.didTapToEditProfileController()
        }
    }
    
    @objc func handleChangeToReceiverView() {
        print("Changing to receiver view")
        receiverButton.tintColor = .mainBlue()
        receiverButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToReceiverView()
    }
    
    lazy var senderButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "ranking_selected"), for: .normal)
        
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Enviados", for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToSenderView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToSenderView() {
        print("Changing to sender view")
        senderButton.tintColor = .mainBlue()
        senderButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToSenderView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        
        addSubview(writeReviewButton)
        writeReviewButton.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 40)
        writeReviewButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        addSubview(fullnameLabel)
        fullnameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        addSubview(emailLabel)
        emailLabel.anchor(top: fullnameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        addSubview(positionLabel)
        positionLabel.anchor(top: emailLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        addSubview(jobDescriptionLabel)
        jobDescriptionLabel.anchor(top: positionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        addSubview(departmentLabel)
        departmentLabel.anchor(top: jobDescriptionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
    }
    
    fileprivate func setupBottomToolbar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [receiverButton, senderButton])
        stackView.backgroundColor = .red
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: departmentLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
