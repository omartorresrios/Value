//
//  MainViewController.swift
//  Value
//
//  Created by Omar Torres on 12/8/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "adminLoggedIn") != nil {
            DispatchQueue.main.async {
                let viewController = AdminMainViewController(collectionViewLayout: UICollectionViewFlowLayout())
                let navController = UINavigationController(rootViewController: viewController)
                UIApplication.shared.keyWindow?.rootViewController = navController
            }
        } else {
            if defaults.object(forKey: "userLoggedIn") == nil {
                
                DispatchQueue.main.async {
                    let loginController = LoginController()
                    let navController = UINavigationController(rootViewController: loginController)
                    self.present(navController, animated: true, completion: nil)
                }
                return
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
                }
            }
        }
        
    }
    
}
