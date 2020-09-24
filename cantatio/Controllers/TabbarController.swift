//
//  TabbarController.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/12/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

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

        let favoritesVC = FavSongView()
        let navController1 = UIHostingController(rootView:favoritesVC)
        navController1.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_favorite"), tag: 0)

        let HomeVC = Top50View()
//        let HomeVC = Top50VC()
//        let navController2 = UINavigationController(rootViewController:HomeVC)
        let navController2 = UIHostingController(rootView:HomeVC)
        navController2.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_home"), tag: 1)
        
        let ProfileVC = ProfileContentView()
        let navController3 = UIHostingController(rootView:ProfileVC)
        navController3.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_profile"), tag: 2)


        viewControllers = [navController1, navController2, navController3]

    }

}

struct TabbarController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
