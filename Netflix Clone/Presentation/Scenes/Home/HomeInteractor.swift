//
//  HomeInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import Foundation

protocol HomeBusinessLogic: AnyObject {
    func fetchTrendingMovieList(type: TrendingType, section: MovieSection)
    func fetchTrendingTvs(type: TrendingType, section: MovieSection)
    func fetchPopularMovieList(section: MovieSection)
    func fetchUpcomingMovieList(section: MovieSection)
    func fetchTopRatedMovieList(section: MovieSection)
}

final class HomeInteractor: HomeBusinessLogic {
    private let presenter: HomePresentationLogic

    init(presenter: HomePresentationLogic) {
        self.presenter = presenter
    }

    private func fetchMovieList(fetchFunction: @escaping () async throws -> [Movie], section: MovieSection) {
        presenter.showLoading()

        Task {
            do {
                defer {
                    presenter.popLoading()
                }

                let movieList = try await fetchFunction()

                await MainActor.run {
                    presenter.didFetchMovieSuccess(movieList, section: section)
                }
            } catch {
                await MainActor.run {
                    presenter.didFetchMovieFailure(error: error)
                }
            }
        }
    }

    func fetchTrendingMovieList(type: TrendingType, section: MovieSection) {
        fetchMovieList(fetchFunction: { try await NetworkManager.shared.fetchTrendingMovieList(type: type) }, section: section)
    }

    func fetchTrendingTvs(type: TrendingType, section: MovieSection) {
        fetchMovieList(fetchFunction: { try await NetworkManager.shared.fetchTrendingTVs(type: type) }, section: section)
    }

    func fetchPopularMovieList(section: MovieSection) {
        fetchMovieList(fetchFunction: { try await NetworkManager.shared.fetchPopularMovieList() }, section: section)
    }

    func fetchUpcomingMovieList(section: MovieSection) {
        fetchMovieList(fetchFunction: { try await NetworkManager.shared.fetchUpcomingMovieList() }, section: section)
    }

    func fetchTopRatedMovieList(section: MovieSection) {
        fetchMovieList(fetchFunction: { try await NetworkManager.shared.fetchTopRatedMovieList() }, section: section)
    }
}
