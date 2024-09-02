//
//  UpcomingPresenter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import UIKit

protocol UpcomingPresentationLogic: Presentable {
    func didFetchMovieSuccess(_ movieList: [Movie], totalPages: Int)
    func didFetchMovieFailure(error: any Error)
    func didFetchYoutubeTrailer(for movie: Movie, videoId: YoutubeVideoId, isAutoplay: Bool)
}

final class UpcomingPresenter: UpcomingPresentationLogic {
    private weak var viewController: UpcomingDisplayLogic?

    init(viewController: UpcomingDisplayLogic?) {
        self.viewController = viewController
    }

    func didFetchMovieSuccess(_ movieList: [Movie], totalPages: Int) {
        viewController?.displayFetchedMovieList(movieList, totalPages: totalPages)
    }

    func didFetchMovieFailure(error: any Error) {
        print(error.localizedDescription)
    }
    
    func didFetchYoutubeTrailer(for movie: Movie, videoId: YoutubeVideoId, isAutoplay: Bool) {
        viewController?.goToPreviewScreen(of: movie, with: videoId, isAutoplay: isAutoplay)
    }
}
