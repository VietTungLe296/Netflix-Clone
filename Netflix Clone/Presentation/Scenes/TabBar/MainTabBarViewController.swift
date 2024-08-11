//
//  MainTabBarViewController.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .label
        
        let homeNC = UINavigationController(rootViewController: HomeBuilder.build())
        homeNC.tabBarItem.image = UIImage(systemName: "house")
        homeNC.title = "Home".localized
        
        viewControllers = [homeNC]
    }
}
