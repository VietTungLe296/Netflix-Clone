//
//  DiscoverSearchResultBuilder.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

final class DiscoverSearchResultBuilder {
    // MARK: The builder of DiscoverSearchResultViewController

    class func build() -> DiscoverSearchResultViewController {
        // MARK: builds ViewController and injects dependency of components.

        let viewController = DiscoverSearchResultViewController()
        let presenter = DiscoverSearchResultPresenter(viewController: viewController)
        let interactor = DiscoverSearchResultInteractor(presenter: presenter)

        viewController.interactor = interactor

        return viewController
    }
}
