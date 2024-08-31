//
//  UpcomingBuilder.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import UIKit

final class UpcomingBuilder {
    // MARK: The builder of UpcomingViewController

    class func build() -> UpcomingViewController {
        // MARK: builds ViewController and injects dependency of components.

        let viewController = UpcomingViewController()
        let presenter = UpcomingPresenter(viewController: viewController)
        let router = UpcomingRouter(viewController: viewController)
        let interactor = UpcomingInteractor(presenter: presenter)

        viewController.interactor = interactor
        viewController.router = router

        return viewController
    }
}
