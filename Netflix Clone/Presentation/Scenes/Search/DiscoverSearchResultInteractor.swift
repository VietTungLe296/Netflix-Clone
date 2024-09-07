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
            } catch let error as APIError {
                await MainActor.run {
                    presenter.hideLoading()
                    presenter.showBottomAlert(type: .error, message: error.message)
                }
            }
        }
    }
}
