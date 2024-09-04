//
//  DownloadedBuilder.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 3/9/24.
//

import UIKit

final class DownloadedBuilder {
    // MARK: The builder of DownloadedViewController

    class func build() -> DownloadedViewController {
        // MARK: builds ViewController and injects dependency of components.

        let viewController = DownloadedViewController()
        let presenter = DownloadedPresenter(viewController: viewController)
        let interactor = DownloadedInteractor(presenter: presenter)

        viewController.interactor = interactor

        return viewController
    }
}
