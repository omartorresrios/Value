//
//  AdminMainViewController.swift
//  Value
//
//  Created by Omar Torres on 12/8/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import Locksmith

class AdminMainViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .done, target: self, action: #selector(handleMenu))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(handleLogout))
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "adminLoggedIn") == nil {
            
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }   
    }
    
    lazy var adminSideMenu: AdminSideMenu = {
        let launcher = AdminSideMenu()
        launcher.adminMainController = self
        return launcher
    }()
    
    @objc func handleMenu() {
        adminSideMenu.showSideMenu()
    }
    
    func showControllerforMetric(metric: Metric) {
        let vc = Metric1()
        vc.navigationItem.title = metric.name.rawValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleLogout() {
        clearLoggedinFlagInAdminDefaults()
        clearAPITokensFromKeyChain()
        
        DispatchQueue.main.async {
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    // Clear the NSUserDefaults flag
    func clearLoggedinFlagInAdminDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "adminLoggedIn")
        defaults.synchronize()
    }
    
    // Clear API Auth token from Keychain
    func clearAPITokensFromKeyChain() {
        // clear API Auth Token
        try! Locksmith.deleteDataForUserAccount(userAccount: "AdminAuthToken")
        try! Locksmith.deleteDataForUserAccount(userAccount: "currentAdminId")
        try! Locksmith.deleteDataForUserAccount(userAccount: "currentAdminName")
        try! Locksmith.deleteDataForUserAccount(userAccount: "currentAdminEmail")
        try! Locksmith.deleteDataForUserAccount(userAccount: "currentAdminAvatar")
    }
    
}
