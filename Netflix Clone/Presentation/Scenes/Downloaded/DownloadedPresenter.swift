//
//  DownloadedPresenter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 3/9/24.
//

import UIKit

protocol DownloadedPresentationLogic: Presentable {
    func didFetchMovieSuccess(_ movieList: [Movie])
    func didFetchYoutubeTrailer(for movie: Movie, videoId: YoutubeVideoId, isAutoplay: Bool)
}

final class DownloadedPresenter: DownloadedPresentationLogic {
    private weak var viewController: DownloadedDisplayLogic?

    init(viewController: DownloadedDisplayLogic?) {
        self.viewController = viewController
    }

    func didFetchMovieSuccess(_ movieList: [Movie]) {
        viewController?.displayFetchedMovieList(movieList)
    }

    func didFetchYoutubeTrailer(for movie: Movie, videoId: YoutubeVideoId, isAutoplay: Bool) {
        viewController?.goToPreviewScreen(of: movie, with: videoId, isAutoplay: isAutoplay)
    }
}
