//
//  DiscoverInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import Foundation

protocol DiscoverBusinessLogic: AnyObject {
    func fetchDiscoverMovies(page: Int, includeVideos: Bool, includeAdult: Bool, sortType: DiscoverSortType)
    func fetchYoutubeTrailer(for movie: Movie, isAutoplay: Bool)
    func downloadMovie(_ movie: Movie)
}

final class DiscoverInteractor: DiscoverBusinessLogic {
    private let presenter: DiscoverPresentationLogic

    init(presenter: DiscoverPresentationLogic) {
        self.presenter = presenter
    }

    func fetchDiscoverMovies(page: Int, includeVideos: Bool, includeAdult: Bool, sortType: DiscoverSortType) {
        Task {
            do {
                let response = try await NetworkManager.shared.fetchDiscoverMovies(page: page,
                                                                                   includeVideos: includeVideos,
                                                                                   includeAdult: includeAdult,
                                                                                   sortType: sortType)

                await MainActor.run {
                    presenter.didFetchMovieSuccess(response.movieList, totalPages: response.totalPages)
                }
            } catch let error as APIError {
                await MainActor.run {
                    presenter.showBottomAlert(type: .error, message: error.message)
                }
            }
        }
    }

    func fetchYoutubeTrailer(for movie: Movie, isAutoplay: Bool) {
        Task {
            do {
                await MainActor.run {
                    presenter.showLoading(maskType: .gradient)
                }

                let response = try await NetworkManager.shared.fetchYoutubeTrailer(with: movie.displayTitle)

                await MainActor.run {
                    presenter.hideLoading()

                    guard let videoId = response.videoList.first?.id else {
                        return
                    }

                    presenter.didFetchYoutubeTrailer(for: movie, videoId: videoId, isAutoplay: isAutoplay)
                }
            } catch let error as APIError {
                await MainActor.run {
                    presenter.hideLoading()
                    presenter.showBottomAlert(type: .error, message: error.message)
                }
            }
        }
    }

    func downloadMovie(_ movie: Movie) {
        DataPersistenceManager.shared.downloadMovie(movie) { [weak self] result in
            switch result {
            case .success:
                self?.presenter.showBottomAlert(type: .success, message: String(format: "Saved %@ successfully".localized, movie.displayTitle))
                NotificationCenter.default.post(name: .updateDownloadedMovieTab, object: nil, userInfo: nil)
            case .failure(let failure):
                self?.presenter.showBottomAlert(type: .error, message: failure.message)
            }
        }
    }
}
