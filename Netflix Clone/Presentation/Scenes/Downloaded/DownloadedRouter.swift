//
//  DownloadedRouter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 3/9/24.
//

import UIKit

protocol DownloadedRoutingLogic: AnyObject {
    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool)
}

final class DownloadedRouter: DownloadedRoutingLogic {
    private weak var viewController: DownloadedViewController?

    init(viewController: DownloadedViewController?) {
        self.viewController = viewController
    }

    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool) {
        let destinationVC = PreviewBuilder.build(with: .init(movie: movie, videoId: videoId, isAutoplay: isAutoplay))
        viewController?.push(to: destinationVC)
    }
}
