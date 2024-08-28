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
        setupScenes()
        setupTabBarAppearance()
    }

    private func setupScenes() {
        let homeNC = UINavigationController(rootViewController: HomeBuilder.build())
        homeNC.tabBarItem.image = UIImage(systemName: "house")
        homeNC.title = "Home".localized

        let comingSoonNC = UINavigationController(rootViewController: ComingSoonBuilder.build())
        comingSoonNC.tabBarItem.image = UIImage(systemName: "play.circle.fill")
        comingSoonNC.title = "Upcoming".localized

        viewControllers = [homeNC, comingSoonNC]
    }

    private func setupTabBarAppearance() {
        let tabbarAppearance = UITabBarAppearance()

        setTabBarItemColors(tabbarAppearance.stackedLayoutAppearance)
        setTabBarItemColors(tabbarAppearance.inlineLayoutAppearance)
        setTabBarItemColors(tabbarAppearance.compactInlineLayoutAppearance)

        tabBar.standardAppearance = tabbarAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabbarAppearance
        }
    }

    @available(iOS 13.0, *)
    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = .lightGray
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]

        itemAppearance.selected.iconColor = .white
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}
