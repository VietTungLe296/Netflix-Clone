//
//  ComingSoonInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import Foundation

protocol ComingSoonBusinessLogic: AnyObject {
    func fetchUpcomingMovieList()
}

final class ComingSoonInteractor: ComingSoonBusinessLogic {
    private let presenter: ComingSoonPresentationLogic

    init(presenter: ComingSoonPresentationLogic) {
        self.presenter = presenter
    }

    func fetchUpcomingMovieList() {
        presenter.showLoading()

        Task {
            do {
                defer {
                    presenter.popLoading()
                }

                let response = try await NetworkManager.shared.fetchUpcomingMovieList()

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
