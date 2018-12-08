//
//  MainTabBarController.swift
//  Value
//
//  Created by Omar Torres on 11/2/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isStatusBarHidden = false
        
        let backgroundImage = UIImageView(image: UIImage(named: "friends.jpg")!)
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.size.width, height: view.frame.size.height)
        
        self.delegate = self
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "userLoggedIn") == nil {
            
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        setupViewControllers { (success) in
            print("setup success")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBar.isHidden = false
    }
    
    func setupViewControllers(completion: @escaping Callback) {
        
        // Feed
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "ranking_unselected"), selectedImage: #imageLiteral(resourceName: "ranking_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Search
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Ranking
        let layout = UICollectionViewFlowLayout()
        let myProfileController = MyProfileController(collectionViewLayout: layout)
        
        let myProfileNavController = UINavigationController(rootViewController: myProfileController)
        
        myProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "user_profile")
        myProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "user_profile")
        
        tabBar.tintColor = UIColor.mainBlue()
        
        viewControllers = [homeNavController, searchNavController, myProfileNavController]
        
        completion(true)
        
        //modify tab bar item insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
