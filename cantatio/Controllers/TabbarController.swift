//
//  TabbarController.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/12/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit

class TabbarController: UITabBarController, UITabBarControllerDelegate {
    
    var firstItemImageView: UIImageView!
    var secondItemImageView: UIImageView!
    
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

        self.firstItemImageView = (firstItemView.subviews.first as! UIImageView)
        self.firstItemImageView.contentMode = .center

        self.secondItemImageView = (secondItemView.subviews.first as! UIImageView)
        self.secondItemImageView.contentMode = .center
    
    }
    
    func setupViewControllers(){

        let favoritesVC = FavSongsVC()
        let navController1 = UINavigationController(rootViewController:favoritesVC)
        navController1.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_favorite"), tag: 0)

        let HomeVC = Top50VC()
        let navController2 = UINavigationController(rootViewController:HomeVC)
        navController2.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_home"), tag: 1)

        viewControllers = [navController1, navController2]

    }
    
    
}
