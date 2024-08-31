//
//  UpcomingInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import Foundation

protocol UpcomingBusinessLogic: AnyObject {
    func fetchUpcomingMovieList(page: Int)
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
}
