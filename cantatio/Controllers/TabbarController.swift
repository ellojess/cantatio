//
//  TabbarController.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/12/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit

class TabbarController: UITabBarController, UITabBarControllerDelegate{
    
    var firstItemImageView: UIImageView!
    var secondItemImageView: UIImageView!
    var thirdItemImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupViewControllers()
        setupTabBarIcons()
        self.navigationItem.hidesBackButton = true
    }
    
    func setupTabBarIcons(){

        let firstItemView = self.tabBar.subviews[0]
        let secondItemView = self.tabBar.subviews[1]
        let thirdItemView = self.tabBar.subviews[2]

        self.firstItemImageView = (firstItemView.subviews.first as! UIImageView)
        self.firstItemImageView.contentMode = .center

        self.secondItemImageView = (secondItemView.subviews.first as! UIImageView)
        self.secondItemImageView.contentMode = .center
        
        self.thirdItemImageView = (thirdItemView.subviews.first as! UIImageView)
        self.thirdItemImageView.contentMode = .center
    }
    
    func setupViewControllers(){

        let favoritesVC = FavoriteSongsVC()
        let navController1 = UINavigationController(rootViewController:favoritesVC)
        favoritesVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_favorite"), tag: 0)

        let HomeVC = Top50VC()
        let navController2 = UINavigationController(rootViewController:HomeVC)
        HomeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_home"), tag: 1)
        
        let ProfileVC = UserProfileVC()
        let navController3 = UINavigationController(rootViewController:ProfileVC)
        ProfileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_profile"), tag: 1)


        viewControllers = [navController1, navController2, navController3]

    }

}
