//
//  EditProfileController.swift
//  Value
//
//  Created by Omar Torres on 11/18/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith

class EditProfileController: UIViewController, UITextViewDelegate {
    
    var activeTextView: UITextView!
    var viewWasMoved: Bool = false
    
    let userProfileViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 100 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = .green
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let textview1: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.backgroundColor = .black
        return tv
    }()
    let textview2: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.backgroundColor = .black
        return tv
    }()
    
    let textview3: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.backgroundColor = .black
        return tv
    }()
    
    let textview4: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.backgroundColor = .black
        return tv
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScrollView()
    }
    
    func setupView() {
        view.backgroundColor = .cyan
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .done, target: self, action: #selector(cancelView))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(updateInfo))
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        scrollView.keyboardDismissMode = .onDrag
        
        scrollView.addSubview(userProfileViewContainer)
        userProfileViewContainer.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 180)
        
        userProfileViewContainer.addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImageView.centerXAnchor.constraint(equalTo: userProfileViewContainer.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: userProfileViewContainer.centerYAnchor).isActive = true
        
        // position
        scrollView.addSubview(textview1)
        textview1.anchor(top: userProfileViewContainer.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width - 16, height: 40)
        
        // job description
        scrollView.addSubview(textview2)
        textview2.anchor(top: textview1.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width - 16, height: 40)
        
        // department
        scrollView.addSubview(textview3)
        textview3.anchor(top: textview2.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width - 16, height: 40)
        
        scrollView.addSubview(textview4)
        textview4.anchor(top: textview3.bottomAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 10, paddingRight: 8, width: view.frame.width - 16, height: 40)
        
        textview1.delegate = self
        textview2.delegate = self
        textview3.delegate = self
        textview4.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func updateInfo() {
        ApiService.shared.updateInfo(position: textview1.text, job_description: textview2.text) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.activeTextView = textView
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.activeTextView = nil
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + 60, 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height + 60
            if let activeTextView = self.activeTextView {
                let activeTextViewCGPoint = CGPoint(x: activeTextView.frame.minX, y: activeTextView.frame.maxY)
                if (!aRect.contains(activeTextViewCGPoint)) {
                    self.scrollView.scrollRectToVisible(activeTextView.frame, animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWillHidden(notification: NSNotification) {
            let contentInsets: UIEdgeInsets = .zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func cancelView() {
        dismiss(animated: true, completion: nil)
    }
}
