//
//  AdminLoginController.swift
//  Value
//
//  Created by Omar Torres on 12/8/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith

class AdminLoginController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Inicia sesión (Admin)"
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 17)
        return label
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Correo"
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.autocorrectionType = .no
        tf.borderStyle = .roundedRect
        tf.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Contraseña"
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.autocorrectionType = .no
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Inicia sesión", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "SFUIDisplay-Semibold", size: 15)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.alpha = 1.0
        return indicator
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 12)
        label.textColor = UIColor.rgb(red: 234, green: 51, blue: 94)
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // General properties of the view
        view.backgroundColor = .white
        
        // Others configurations
        emailTextField.becomeFirstResponder()
        
        // Initialize functions
        setupInputFields()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleTextInputChange() {
        messageLabel.text = ""
        loader.stopAnimating()
        
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func handleLogin() {
        view.endEditing(true)
        loader.startAnimating()
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        // Check for internet connection
        if (reachability?.isReachable)! {
            
            AuthService.instance.signinUser(isEmployee: false, email: email, password: password) { (success) in
                if success {
                    self.dismiss(animated: true, completion: nil) 
                }
            }
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Tu conexión a internet está fallando. 🤔 Intenta de nuevo.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.loader.stopAnimating()
        }
    }
    
    func goBackView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setupInputFields() {
        view.addSubview(titleLabel)
        
        titleLabel.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 35, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
        
        view.addSubview(loader)
        
        loader.anchor(top: stackView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 10, height: 10)
        loader.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        view.addSubview(messageLabel)
        
        messageLabel.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: stackView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
