//
//  UpcomingInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import Foundation

protocol UpcomingBusinessLogic: AnyObject {
    func fetchUpcomingMovieList(page: Int)
    func fetchYoutubeTrailer(for movie: Movie, isAutoplay: Bool)
}

final class UpcomingInteractor: UpcomingBusinessLogic {
    private let presenter: UpcomingPresentationLogic

    init(presenter: UpcomingPresentationLogic) {
        self.presenter = presenter
    }

    func fetchUpcomingMovieList(page: Int) {
        presenter.showLoading()

        Task {
            do {
                defer {
                    presenter.popLoading()
                }

                let response = try await NetworkManager.shared.fetchUpcomingMovieList(page: page)

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
