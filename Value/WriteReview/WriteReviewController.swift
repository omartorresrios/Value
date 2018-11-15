//
//  WriteReviewController.swift
//  Value
//
//  Created by Omar Torres on 11/7/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import Locksmith

class WriteReviewController: UIViewController, UITextViewDelegate {
    
    var userReceiverId: Int?
    
    var userReceiverFullname: String? {
        didSet {
            userReceiverFullnameLabel.text = userReceiverFullname
        }
    }
    
    var userReceiverImageUrl: String? {
        didSet {
            guard let profileImageUrl = userReceiverImageUrl else { return }
            userReceiverProfileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    let userReceiverProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 30 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let userReceiverFullnameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.rgb(red: 22, green: 22, blue: 22)
        label.font = UIFont(name: "SFUIDisplay-Semibold", size: 14)
        label.textAlignment = .left
        return label
    }()
    
    var userReceiverDataViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ranking_selected"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return button
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ranking_selected"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return button
    }()
    
    let writeReviewTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        tv.autocorrectionType = .no
        tv.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 0)
        return tv
    }()
    
    let valueView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    static let updateUserProfileFeedNotificationName = NSNotification.Name(rawValue: "UpdateUserProfileFeed")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBarElements()
        setupViews()
    }
    
    func setupNavBarElements() {
        
        let navBarLeftButton = UIBarButtonItem(customView: closeButton)
        self.navigationItem.leftBarButtonItem = navBarLeftButton
        navBarLeftButton.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exitWriteReviewController)))
        
        let navBarRightButton = UIBarButtonItem(customView: sendButton)
        self.navigationItem.rightBarButtonItem = navBarRightButton
        navBarRightButton.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendReview)))
        
        view.addSubview(titleView)
        
        titleView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 44)
        
        titleView.addSubview(userReceiverProfileImageView)
        userReceiverProfileImageView.anchor(top: nil, left: titleView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        userReceiverProfileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        titleView.addSubview(userReceiverFullnameLabel)
        userReceiverFullnameLabel.anchor(top: nil, left: userReceiverProfileImageView.rightAnchor, bottom: nil, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
        userReceiverFullnameLabel.centerYAnchor.constraint(equalTo: userReceiverProfileImageView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    func setupViews() {
        let navBarHeight = (navigationController?.navigationBar.frame.size.height)!
        
        view.addSubview(writeReviewTextView)
        writeReviewTextView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: navBarHeight + 20, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 100)
        
        writeReviewTextView.text = "Placeholder"
        writeReviewTextView.textColor = UIColor.lightGray
        
        self.writeReviewTextView.delegate = self
        
        writeReviewTextView.becomeFirstResponder()
        writeReviewTextView.selectedTextRange = writeReviewTextView.textRange(from: writeReviewTextView.beginningOfDocument, to: writeReviewTextView.beginningOfDocument)
        
        view.addSubview(valueView)
        valueView.anchor(top: writeReviewTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    @objc func exitWriteReviewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendReview() {
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            print("the current user token: \(authToken)")
            
            DataService.instance.sendReview(authToken: authToken, userId: userReceiverId!, reviewText: writeReviewTextView.text) { (success) in
                if success {
                    print("Review sended!")
                    NotificationCenter.default.post(name: WriteReviewController.updateUserProfileFeedNotificationName, object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let isFormValid = writeReviewTextView.text?.count ?? 0 > 10
        
        if isFormValid {
            //            sendReviewButton.isEnabled = true
            //            keyboardToolbar.barTintColor = .mainBlue()
        } else {
            //            sendReviewButton.isEnabled = false
            //            keyboardToolbar.barTintColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
}
