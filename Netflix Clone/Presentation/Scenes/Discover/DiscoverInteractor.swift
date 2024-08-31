//
//  DiscoverInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import Foundation

protocol DiscoverBusinessLogic: AnyObject {
    func fetchDiscoverMovies(includeVideos: Bool, includeAdult: Bool, sortType: DiscoverSortType)
}

final class DiscoverInteractor: DiscoverBusinessLogic {
    private let presenter: DiscoverPresentationLogic

    init(presenter: DiscoverPresentationLogic) {
        self.presenter = presenter
    }
    
    func fetchDiscoverMovies(includeVideos: Bool, includeAdult: Bool, sortType: DiscoverSortType) {
        presenter.showLoading()

        Task {
            do {
                defer {
                    presenter.hideLoading()
                }

                let movieList = try await NetworkManager.shared.fetchDiscoverMovies(includeVideos: includeVideos,
                                                                                    includeAdult: includeAdult,
                                                                                    sortType: sortType)

                await MainActor.run {
                    presenter.didFetchMovieSuccess(movieList)
                }
            } catch {
                await MainActor.run {
                    presenter.didFetchMovieFailure(error: error)
                }
            }
        }
    }
}
