//
//  ComingSoonBuilder.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import UIKit

final class ComingSoonBuilder {
    // MARK: The builder of ComingSoonViewController

    class func build() -> ComingSoonViewController {
        // MARK: builds ViewController and injects dependency of components.

        let viewController = ComingSoonViewController()
        let presenter = ComingSoonPresenter(viewController: viewController)
        let router = ComingSoonRouter(viewController: viewController)
        let interactor = ComingSoonInteractor(presenter: presenter)

        viewController.interactor = interactor
        viewController.router = router

        return viewController
    }
}
