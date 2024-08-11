//
//  HomeBuilder.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import UIKit

final class HomeBuilder {
    // MARK: The builder of HomeViewController

    class func build() -> HomeViewController {
        // MARK: builds ViewController and injects dependency of components.

        let viewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let presenter = HomePresenter(viewController: viewController)
        let router = HomeRouter(viewController: viewController)
        let interactor = HomeInteractor(presenter: presenter, router: router)

        viewController.interactor = interactor
        viewController.router = router

        return viewController
    }
}
