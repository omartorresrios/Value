//
//  AuthService.swift
//  Value
//
//  Created by Omar Torres on 11/3/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith
import Firebase

class AuthService {
    
    static let instance = AuthService()
    
    func signinUser(isEmployee: Bool, email: String, password: String, completion: @escaping Callback) {
        
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespaces)
        let parameters = ["email": finalEmail, "password": password]
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluate(with: email) == true {
            
            Alamofire.request(SIGNIN_URL, method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success:
                    
                    if isEmployee {
                        self.updateLoggedInFlag(isEmployee: true)
                        
                        if let JSON = response.result.value as? NSDictionary {
                            let authToken = JSON["authentication_token"] as! String
                            let userId = JSON["id"] as! Int
                            let userName = JSON["fullname"] as! String
                            let userEmail = JSON["email"] as! String
                            let avatarUrl = JSON["avatar_url"] as? String ?? ""
                            print("userJSON: \(JSON)")
                            
                            self.saveApiTokenInKeychain(isEmployee: true, tokenString: authToken, idInt: userId, nameString: userName, emailString: userEmail, avatarString: avatarUrl)
                            
                            print("authToken: \(authToken)")
                            print("userId: \(userId)")
                        }
                        
                        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
                        completion(true)
                        
                    } else {
                        
                        self.updateLoggedInFlag(isEmployee: false)
                        
                        if let JSON = response.result.value as? NSDictionary {
                            let adminAuthToken = JSON["authentication_token"] as! String
                            let adminId = JSON["id"] as! Int
                            let adminName = JSON["fullname"] as! String
                            let adminEmail = JSON["email"] as! String
                            let adminAvatarUrl = JSON["avatar_url"] as? String ?? ""
                            let adminIsAdminCondition = JSON["is_admin"] as! Int
                            
                            if adminIsAdminCondition == 1 {
                                
                                self.saveApiTokenInKeychain(isEmployee: false, tokenString: adminAuthToken, idInt: adminId, nameString: adminName, emailString: adminEmail, avatarString: adminAvatarUrl)
                                
                                let adminMainViewController = AdminMainViewController(collectionViewLayout: UICollectionViewFlowLayout())
                                let navController = UINavigationController(rootViewController: adminMainViewController)
                                UIApplication.shared.keyWindow?.rootViewController = navController
                                completion(true)
                            } else {
                                //                            self.messageLabel.text = "So Sorry!!!!! you are not the admin."
                            }
                        }
                    }
                    
                case .failure(let error):
                    completion(false)
                    print("Failed to sign in with email:", error)
                    return
                }
            }
            
        } else {
            completion(false)
            print("Invalid email")
        }
    }
    
    func signupUser(fullname: String, email: String, password: String, completion: @escaping Callback) {
        
        guard let fcmToken = Messaging.messaging().fcmToken else { return }
        
        let parameters = ["fullname": fullname, "email": email, "fcm_token": fcmToken, "password": password]
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluate(with: email) == true {
            
            Alamofire.request(SIGNUP_URL, method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success:
                    
                    self.updateLoggedInFlag(isEmployee: true)
                    
                    if let JSON = response.result.value as? NSDictionary {
                        let authToken = JSON["authentication_token"] as! String
                        let userId = JSON["id"] as! Int
                        let userName = JSON["fullname"] as! String
                        let userEmail = JSON["email"] as! String
                        let avatarUrl = JSON["avatar_url"] as? String ?? ""
                        
                        self.saveApiTokenInKeychain(isEmployee: true, tokenString: authToken, idInt: userId, nameString: userName, emailString: userEmail, avatarString: avatarUrl)
                        
                    }
                    
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    
                    mainTabBarController.setupViewControllers(completion: { (success) in
                        if success {
                            completion(true)
                        }
                    })
                    
                case .failure(let error):
                    completion(false)
                    return
                }
            }
            
        } else {
            
        }
        
    }
    
    func updateLoggedInFlag(isEmployee: Bool) {
        let defaults = UserDefaults.standard
        
        if isEmployee {
            defaults.set(employeeDefaultsValue, forKey: employeeDefaultsKey)
        } else {
            defaults.set(adminDefaultsValue, forKey: adminDefaultsKey)
        }
        defaults.synchronize()
    }
    
    func saveApiTokenInKeychain(isEmployee: Bool, tokenString: String, idInt: Int, nameString: String, emailString: String, avatarString: String) {
        do {
            if isEmployee {
                try Locksmith.saveData(data: [employeeKeychainAuthData: tokenString], forUserAccount: employeeKeychainAuthAccount)
                try Locksmith.saveData(data: [employeeKeychainIdData: idInt], forUserAccount: employeeKeychainIdAccount)
                try Locksmith.saveData(data: [employeeKeychainNameData: nameString], forUserAccount: employeeKeychainNameAccount)
                try Locksmith.saveData(data: [employeeKeychainEmailData: emailString], forUserAccount: employeeKeychainEmailAccount)
                try Locksmith.saveData(data: [employeeKeychainAvatarData: avatarString], forUserAccount: employeeKeychainAvatarAccount)
            } else {
                try Locksmith.saveData(data: [adminKeychainAuthData: tokenString], forUserAccount: adminKeychainAuthAccount)
                try Locksmith.saveData(data: [adminKeychainIdData: idInt], forUserAccount: adminKeychainIdAccount)
                try Locksmith.saveData(data: [adminKeychainNameData: nameString], forUserAccount: adminKeychainNameAccount)
                try Locksmith.saveData(data: [adminKeychainEmailData: emailString], forUserAccount: adminKeychainEmailAccount)
                try Locksmith.saveData(data: [adminKeychainAvatarData: avatarString], forUserAccount: adminKeychainAvatarAccount)
            }
        } catch {
            print("Can't save values to Keychain")
        }
    }
    
}

