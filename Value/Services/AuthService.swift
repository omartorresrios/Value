//
//  AuthService.swift
//  Value
//
//  Created by Omar Torres on 11/3/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit

class AuthService {
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isRegistered: Bool? {
        get {
            return defaults.bool(forKey: DEFAULTS_REGISTERED) == true
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_REGISTERED)
        }
    }
    
    var isAuthenticated: Bool? {
        get {
            return defaults.bool(forKey: DEFAULTS_AUTHENTICATED) == true
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_AUTHENTICATED)
        }
    }
    
    var email: String? {
        get {
            return defaults.value(forKey: DEFAULTS_EMAIL) as? String
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_EMAIL)
        }
    }
    
    var authToken: String? {
        get {
            return defaults.value(forKey: DEFAULTS_TOKEN) as? String
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_TOKEN)
        }
    }
    
    let httpHelper = HTTPHelper()
    
    
    func updateUserLoggedInFlag() {
        // Update the NSUserDefaults flag
        let defaults = UserDefaults.standard
        defaults.set("loggedIn", forKey: "userLoggedIn")
        defaults.synchronize()
    }
    
    // Signup user
    func makeSignUpRequest(_ fullName: String, userName:String, userEmail:String, userAvatar: String, userPassword:String, completion: @escaping Callback) {
        
        guard let URL = URL(string: "\(BASE_URL)/users/signin") else {
            completion(false)
            return
        }
        
        
        // Create the URL Request and set it's method and content type.
        var request = NSMutableURLRequest(url: URL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // Create an dictionary of the info for our new project, including the selected images.
        let encrypted_password = AESCrypt.encrypt(userPassword, password: HTTPHelper.API_AUTH_PASSWORD)
        
        let json = ["fullname": fullName, "username": userName, "email": userEmail, "avatar": userAvatar, "password": encrypted_password]
        
        do {
            // Convert our dictionary to JSON and NSData
            let newProjectJSONData = try JSONSerialization.data(withJSONObject: json, options: [])
            
            // Assign the request body
            request.httpBody = newProjectJSONData
            
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    
                    // Print out response string
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Response String = \(responseString!)")
                    
                    // Check for status 200 or 409
                    if statusCode != 200 && statusCode != 409 {
                        
                        completion(false)
                        return
                    } else {
                        
                        completion(true)
                    }
                } else {
                    // Failure
                    print("URL Session Task Failed: \(error?.localizedDescription)")
                    completion(false)
                }
            }).resume()
            
            
        } catch let error {
            print(error)
        }
    }
    
    
    func makeSignInRequest(_ userEmail: String, userPassword:String, completion: @escaping Callback) {
        
        // Create HTTP request and set request Body
        let httpRequest = httpHelper.buildRequest(path: "users/signin", method: "POST", authType: HTTPRequestAuthType.HTTPBasicAuth)
        
        let encrypted_password = AESCrypt.encrypt(userPassword, password: HTTPHelper.API_AUTH_PASSWORD)
        
        let json = ["email": userEmail, "password": encrypted_password!] as [String : Any]
        //        httpRequest.httpBody = "email=\(userEmail)&password=\(encrypted_password)".data(using: String.Encoding.utf8);
        
        do {
            // Convert our dictionary to JSON and NSData
            let newProjectJSONData = try JSONSerialization.data(withJSONObject: json, options: [])
            
            // Assign the request body
            httpRequest.httpBody = newProjectJSONData
            
            // 4. Send the request
            
            URLSession.shared.dataTask(with: httpRequest as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                if error == nil {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    if statusCode != 200 {
                        // Failed
                        print("There's no a 200 status in LoginController. Failed")
                        completion(false)
                        return
                    }
                    DispatchQueue.main.async {
                        guard let data = data else {
                            completion(false)
                            return
                        }
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                            
                            guard json != nil else {
                                print("Error while parsing")
                                completion(false)
                                return
                            }
                            
                            // Print out response string
                            let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                            print("Response String = \(responseString!)")
                            
                            if let userDic = json?["user"] as? NSDictionary {
                                print("dataArray: \(userDic["authenticationToken"] as! String)")
                                self.authToken = userDic["authenticationToken"] as? String
                                completion(true)
                                print("this is the authToken: \(self.authToken)")
                            } else {
                                completion(false)
                            }
                            
                            // Updatge userLoggedInFlag
                            self.updateUserLoggedInFlag()
                            
                        } catch {
                            completion(false)
                            print("Caught an error: \(error)")
                        }
                    }
                    
                } else {
                    // Failure
                    print("URL Session Task Failed: \(error!.localizedDescription)")
                    completion(false)
                    return
                }
            }).resume()
            
        } catch let err {
            print(err)
        }
        
    }
    
}

