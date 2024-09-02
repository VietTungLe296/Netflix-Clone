//
//  UpcomingRouter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import UIKit

protocol UpcomingRoutingLogic: AnyObject {
    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoPlay: Bool)
}

final class UpcomingRouter: UpcomingRoutingLogic {
    private weak var viewController: UpcomingViewController?

    init(viewController: UpcomingViewController?) {
        self.viewController = viewController
    }

    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoPlay: Bool) {
        let destinationVC = PreviewBuilder.build(with: .init(movie: movie, videoId: videoId, isAutoplay: isAutoPlay))
        viewController?.push(to: destinationVC)
    }
}
