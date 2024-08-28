//
//  HomeInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import Foundation

protocol HomeBusinessLogic: AnyObject {
    func fetchTrendingMovies(type: TrendingType, section: MovieSection)
    func fetchTrendingTvs(type: TrendingType, section: MovieSection)
    func fetchPopularMovies(section: MovieSection)
    func fetchUpcomingMovies(section: MovieSection)
    func fetchTopRatedMovies(section: MovieSection)
}

final class HomeInteractor: HomeBusinessLogic {
    private let presenter: HomePresentationLogic

    init(presenter: HomePresentationLogic) {
        self.presenter = presenter
    }

    private func fetchMovies(fetchFunction: @escaping () async throws -> [Movie], section: MovieSection) {
        presenter.showLoading()

        Task {
            do {
                defer {
                    presenter.popLoading()
                }

                let movies = try await fetchFunction()

                await MainActor.run {
                    presenter.didFetchMovieSuccess(movies, section: section)
                }
            } catch {
                await MainActor.run {
                    presenter.didFetchMovieFailure(error: error)
                }
            }
        }
    }

    func fetchTrendingMovies(type: TrendingType, section: MovieSection) {
        fetchMovies(fetchFunction: { try await NetworkManager.shared.fetchTrendingMovies(type: type) }, section: section)
    }

    func fetchTrendingTvs(type: TrendingType, section: MovieSection) {
        fetchMovies(fetchFunction: { try await NetworkManager.shared.fetchTrendingTVs(type: type) }, section: section)
    }

    func fetchPopularMovies(section: MovieSection) {
        fetchMovies(fetchFunction: { try await NetworkManager.shared.fetchPopularMovies() }, section: section)
    }

    func fetchUpcomingMovies(section: MovieSection) {
        fetchMovies(fetchFunction: { try await NetworkManager.shared.fetchUpcomingMovies() }, section: section)
    }

    func fetchTopRatedMovies(section: MovieSection) {
        fetchMovies(fetchFunction: { try await NetworkManager.shared.fetchTopRatedMovies() }, section: section)
    }
}
