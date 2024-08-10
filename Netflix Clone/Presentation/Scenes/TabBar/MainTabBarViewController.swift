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
        setupTabBarAppearance()
        setupScenes()
    }

    private func setupTabBarAppearance() {
        UINavigationBar.appearance().tintColor = .systemGreen

        let tabbarAppearance = UITabBarAppearance()
        setTabBarItemColors(tabbarAppearance.stackedLayoutAppearance)
        setTabBarItemColors(tabbarAppearance.inlineLayoutAppearance)
        setTabBarItemColors(tabbarAppearance.compactInlineLayoutAppearance)

        tabBar.standardAppearance = tabbarAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabbarAppearance
        }
    }

    private func setupScenes() {
        let homeNC = UINavigationController(rootViewController: UIViewController())
        homeNC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        viewControllers = [homeNC]
    }

    @available(iOS 13.0, *)
    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = .lightGray
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]

        itemAppearance.selected.iconColor = .systemGreen
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
    }
}
