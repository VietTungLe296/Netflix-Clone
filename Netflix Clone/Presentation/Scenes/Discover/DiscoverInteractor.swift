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
}

final class DiscoverInteractor: DiscoverBusinessLogic {
    private let presenter: DiscoverPresentationLogic

    init(presenter: DiscoverPresentationLogic) {
        self.presenter = presenter
    }

    func fetchDiscoverMovies(page: Int, includeVideos: Bool, includeAdult: Bool, sortType: DiscoverSortType) {
        presenter.showLoading()

        Task {
            do {
                defer {
                    presenter.hideLoading()
                }

                let response = try await NetworkManager.shared.fetchDiscoverMovies(page: page,
                                                                                   includeVideos: includeVideos,
                                                                                   includeAdult: includeAdult,
                                                                                   sortType: sortType)

                await MainActor.run {
                    presenter.didFetchMovieSuccess(response.movieList, totalPages: response.totalPages)
                }
            } catch {
                await MainActor.run {
                    presenter.didFetchMovieFailure(error: error)
                }
            }
        }
    }
    
    func fetchYoutubeTrailer(for movie: Movie, isAutoplay: Bool) {
        guard let title = movie.originalTitle ?? movie.originalName else {
            return
        }

        Task {
            do {
                await MainActor.run {
                    presenter.showLoading(maskType: .gradient)
                }

                let response = try await NetworkManager.shared.fetchYoutubeTrailer(with: title)

                await MainActor.run {
                    presenter.popLoading()

                    guard let videoId = response.videoList.first?.id else {
                        return
                    }

                    presenter.didFetchYoutubeTrailer(for: movie, videoId: videoId, isAutoplay: isAutoplay)
                }
            } catch {
                await MainActor.run {
                    presenter.popLoading()
                    presenter.didFetchMovieFailure(error: error)
                }
            }
        }
    }
}
