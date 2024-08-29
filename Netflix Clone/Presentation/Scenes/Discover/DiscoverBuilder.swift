//
//  DiscoverBuilder.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

final class DiscoverBuilder {
    // MARK: The builder of DiscoverViewController

    class func build() -> DiscoverViewController {
        // MARK: builds ViewController and injects dependency of components.

        let viewController = DiscoverViewController()
        let presenter = DiscoverPresenter(viewController: viewController)
        let router = DiscoverRouter(viewController: viewController)
        let interactor = DiscoverInteractor(presenter: presenter)

        viewController.interactor = interactor
        viewController.router = router

        return viewController
    }
}
