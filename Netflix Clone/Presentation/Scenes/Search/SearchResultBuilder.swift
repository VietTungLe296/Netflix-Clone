//
//  SearchResultBuilder.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

final class SearchResultBuilder {
    // MARK: The builder of SearchResultViewController

    class func build() -> SearchResultViewController {
        // MARK: builds ViewController and injects dependency of components.

        let viewController = SearchResultViewController()
        let presenter = SearchResultPresenter(viewController: viewController)
        let router = SearchResultRouter(viewController: viewController)
        let interactor = SearchResultInteractor(presenter: presenter)

        viewController.interactor = interactor
        viewController.router = router

        return viewController
    }
}
