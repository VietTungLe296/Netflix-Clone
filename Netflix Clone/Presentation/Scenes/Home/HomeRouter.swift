//
//  HomeRouter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import UIKit

protocol HomeRoutingLogic: AnyObject {
    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool)
}

final class HomeRouter: HomeRoutingLogic {
    private weak var viewController: HomeViewController?

    init(viewController: HomeViewController?) {
        self.viewController = viewController
    }

    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool) {
        let destinationVC = PreviewBuilder.build(with: .init(movie: movie, videoId: videoId, isAutoplay: isAutoplay))
        viewController?.push(to: destinationVC)
    }
}
