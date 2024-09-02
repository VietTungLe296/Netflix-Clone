//
//  PreviewBuilder.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 2/9/24.
//

import UIKit

final class PreviewBuilder {
    struct Dependencies {
        let movie: Movie
        let videoId: YoutubeVideoId
        let isAutoplay: Bool
    }
    
    // MARK: The builder of PreviewViewController

    class func build(with dependencies: Dependencies) -> PreviewViewController {
        // MARK: builds ViewController and injects dependency of components.

        let viewController = PreviewViewController()
        let presenter = PreviewPresenter(viewController: viewController)
        let interactor = PreviewInteractor(presenter: presenter, dependencies: dependencies)

        viewController.interactor = interactor
        viewController.isAutoplay = dependencies.isAutoplay
        return viewController
    }
}
