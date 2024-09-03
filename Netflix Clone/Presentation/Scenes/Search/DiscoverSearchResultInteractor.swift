//
//  DiscoverSearchResultInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import Foundation

protocol DiscoverSearchResultBusinessLogic: AnyObject {
    func searchMovies(with keyword: String, includeAdult: Bool)
}

final class DiscoverSearchResultInteractor: DiscoverSearchResultBusinessLogic {
    private let presenter: DiscoverSearchResultPresentationLogic

    init(presenter: DiscoverSearchResultPresentationLogic) {
        self.presenter = presenter
    }

    func searchMovies(with keyword: String, includeAdult: Bool) {
        Task {
            do {
                await MainActor.run {
                    presenter.showLoading()
                }

                let response = try await NetworkManager.shared.searchMovies(with: keyword, includeAdult: includeAdult)

                await MainActor.run {
                    presenter.hideLoading()
                    presenter.didFetchMovieSuccess(response.movieList.filter { $0.imageURL != nil })
                }
            } catch {
                await MainActor.run {
                    presenter.hideLoading()
                    presenter.didFetchMovieFailure(error: error)
                }
            }
        }
    }
}
