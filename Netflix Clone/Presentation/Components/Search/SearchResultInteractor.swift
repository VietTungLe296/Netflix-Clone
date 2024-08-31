//
//  SearchResultInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import Foundation

protocol SearchResultBusinessLogic: AnyObject {
    func searchMovies(with keyword: String, includeAdult: Bool)
}

final class SearchResultInteractor: SearchResultBusinessLogic {
    private let presenter: SearchResultPresentationLogic

    init(presenter: SearchResultPresentationLogic) {
        self.presenter = presenter
    }
    
    func searchMovies(with keyword: String, includeAdult: Bool) {
        presenter.showLoading()

        Task {
            do {
                defer {
                    presenter.hideLoading()
                }

                let response = try await NetworkManager.shared.searchMovies(with: keyword, includeAdult: includeAdult)

                await MainActor.run {
                    presenter.didFetchMovieSuccess(response.movieList)
                }
            } catch {
                await MainActor.run {
                    presenter.didFetchMovieFailure(error: error)
                }
            }
        }
    }
}
