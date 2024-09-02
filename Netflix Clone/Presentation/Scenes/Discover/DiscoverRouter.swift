//
//  DiscoverRouter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

protocol DiscoverRoutingLogic: AnyObject {
    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool)
}

final class DiscoverRouter: DiscoverRoutingLogic {
    private weak var viewController: DiscoverViewController?

    init(viewController: DiscoverViewController?) {
        self.viewController = viewController
    }

    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool) {
        let destinationVC = PreviewBuilder.build(with: .init(movie: movie, videoId: videoId, isAutoplay: isAutoplay))
        viewController?.push(to: destinationVC)
    }
}
