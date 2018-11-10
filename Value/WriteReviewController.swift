//
//  WriteReviewController.swift
//  Value
//
//  Created by Omar Torres on 11/7/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit

class WriteReviewController: UICollectionViewController {
    
    var userReceiverId: String?
    
    var userReceiverFullname: String? {
        didSet {
            fullnameLabel.text = userReceiverFullname
        }
    }
    
    var userReceiverImageUrl: String? {
        didSet {
            guard let profileImageUrl = userReceiverImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let fullnameLabel: UILabel = {
        let ul = UILabel()
        ul.font = UIFont(name: "SFUIDisplay-Medium", size: 14)
        return ul
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_button"), for: .normal)
        button.isUserInteractionEnabled = true
        button.tintColor = UIColor.mainBlue()
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .brown
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel_button"), style: .done, target: self, action: #selector(exitWriteReviewController))
    }
    
    @objc func exitWriteReviewController() {
        dismiss(animated: true, completion: nil)
    }
}
