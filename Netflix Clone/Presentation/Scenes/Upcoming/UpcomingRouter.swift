//
//  UpcomingRouter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import UIKit

protocol UpcomingRoutingLogic: AnyObject {
    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool)
}

final class UpcomingRouter: UpcomingRoutingLogic {
    private weak var viewController: UpcomingViewController?

    init(viewController: UpcomingViewController?) {
        self.viewController = viewController
    }

    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool) {
        let destinationVC = PreviewBuilder.build(with: .init(movie: movie, videoId: videoId, isAutoplay: isAutoplay))
        viewController?.push(to: destinationVC)
    }
}
