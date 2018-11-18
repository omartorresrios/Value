//
//  SignUpController.swift
//  Value
//
//  Created by Omar Torres on 11/17/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import Locksmith

class SignUpController: UIViewController, UINavigationControllerDelegate {
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.isEmpty == false && fullnameTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let fullnameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        button.isEnabled = false
        
        return button
    }()
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let username = fullnameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        guard let fcmToken = FIRInstanceID.instanceID().token() else { return }
        
        let parameters = ["fullname": username, "email": email, "fcm_token": fcmToken, "password": password]
        
        let url = "\(BASE_URL)/users/signup"
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluate(with: email) == true { // Valid email
            
            Alamofire.request(url, method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success:
                    
                    self.updateUserLoggedInFlag()
                    //                        print("THE USER DATA: ", response)
                    
                    if let JSON = response.result.value as? NSDictionary {
                        let authToken = JSON["authentication_token"] as! String
                        let userId = JSON["id"] as! Int
                        let userName = JSON["fullname"] as! String
                        let userEmail = JSON["email"] as! String
                        let avatarUrl = JSON["avatar_url"] as? String ?? ""
                        print("userJSON: \(JSON)")
                        
                        self.saveApiTokenInKeychain(tokenString: authToken, idInt: userId, nameString: userName, emailString: userEmail, avatarString: avatarUrl)
                        
                        print("authToken: \(authToken)")
                        print("userId: \(userId)")
                    }
                    
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    
                    mainTabBarController.setupViewControllers(completion: { (success) in
                        if success {
                            print("YAYYYYY")
                            
                        }
                    })
                    
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    
                    print("Failed to sign in with email:", error)
//                    self.loader.stopAnimating()
//                    self.messageLabel.text = "La contraseña no es válida."
                    return
                }
            }
            
        } else { // Invalid email
//            self.loader.stopAnimating()
//            self.messageLabel.text = "Introduce un correo válido por favor."
            
        }
        
        
        
    }
    
    func updateUserLoggedInFlag() {
        // Update the NSUserDefaults flag
        let defaults = UserDefaults.standard
        defaults.set("loggedIn", forKey: "userLoggedIn")
        defaults.synchronize()
    }
    
    func saveApiTokenInKeychain(tokenString: String, idInt: Int, nameString: String, emailString: String, avatarString: String) {
        // save API AuthToken in Keychain
        do {
            try Locksmith.saveData(data: ["authenticationToken": tokenString], forUserAccount: "AuthToken")
        } catch {
            
        }
        do {
            try Locksmith.saveData(data: ["id": idInt], forUserAccount: "currentUserId")
        } catch {
            
        }
        do {
            try Locksmith.saveData(data: ["name": nameString], forUserAccount: "currentUserName")
        } catch {
            
        }
        do {
            try Locksmith.saveData(data: ["email": emailString], forUserAccount: "currentUserEmail")
        } catch {
            
        }
        do {
            try Locksmith.saveData(data: ["avatar": avatarString], forUserAccount: "currentUserAvatar")
        } catch {
            
        }
        
        print("AuthToken recién guardado: \(Locksmith.loadDataForUserAccount(userAccount: "AuthToken")!)")
        print("currentUserId recién guardado: \(Locksmith.loadDataForUserAccount(userAccount: "currentUserId")!)")
        print("currentUserName recién guardado: \(Locksmith.loadDataForUserAccount(userAccount: "currentUserName")!)")
        print("currentUserEmail recién guardado: \(Locksmith.loadDataForUserAccount(userAccount: "currentUserEmail")!)")
        print("currentUserAvatar recién guardado: \(Locksmith.loadDataForUserAccount(userAccount: "currentUserAvatar")!)")
        
    }
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)
            ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAlreadyHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.backgroundColor = .white
        
        
        
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, fullnameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
    
}
