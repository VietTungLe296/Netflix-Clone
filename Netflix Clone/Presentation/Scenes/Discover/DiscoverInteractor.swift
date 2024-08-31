//
//  DiscoverInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import Foundation

protocol DiscoverBusinessLogic: AnyObject {
    func fetchDiscoverMovies(page: Int, includeVideos: Bool, includeAdult: Bool, sortType: DiscoverSortType)
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
}
