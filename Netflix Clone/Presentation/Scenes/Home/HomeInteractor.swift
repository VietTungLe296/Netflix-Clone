//
//  HomeInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import Foundation

protocol HomeBusinessLogic: AnyObject {
    func fetchMovieData()
    func fetchYoutubeTrailer(for movie: Movie, isAutoplay: Bool)
    func downloadMovie(_ movie: Movie)
}

final class HomeInteractor: HomeBusinessLogic {
    private let presenter: HomePresentationLogic

    init(presenter: HomePresentationLogic) {
        self.presenter = presenter
    }

    func fetchMovieData() {
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    self.fetchTrendingMovieList(type: .day, section: .trendingMovies)
                }
                group.addTask {
                    self.fetchTrendingTvs(type: .day, section: .trendingTvs)
                }
                group.addTask {
                    self.fetchPopularMovieList(section: .popular)
                }
                group.addTask {
                    self.fetchUpcomingMovieList(section: .upcoming)
                }
                group.addTask {
                    self.fetchTopRatedMovieList(section: .topRated)
                }
            }
        }
    }

    func downloadMovie(_ movie: Movie) {
        DataPersistenceManager.shared.downloadMovie(movie) { [weak self] result in
            switch result {
            case .success:
                self?.presenter.showAlert(message: String(format: "Saved %@ successfully".localized,
                                                          movie.originalTitle ?? movie.originalName ?? "movie".localized))
                {
                    NotificationCenter.default.post(name: .updateDownloadedMovieTab, object: nil, userInfo: nil)
                }
            case .failure(let failure):
                self?.presenter.showAlert(message: failure.localizedDescription)
            }
        }
    }

    private func fetchTrendingMovieList(type: TrendingType, section: MovieSection) {
        fetchMovieList(fetchFunction: { try await NetworkManager.shared.fetchTrendingMovieList(type: type) }, section: section)
    }

    private func fetchTrendingTvs(type: TrendingType, section: MovieSection) {
        fetchMovieList(fetchFunction: { try await NetworkManager.shared.fetchTrendingTVs(type: type) }, section: section)
    }

    private func fetchPopularMovieList(section: MovieSection) {
        fetchMovieList(fetchFunction: { try await NetworkManager.shared.fetchPopularMovieList() }, section: section)
    }

    private func fetchUpcomingMovieList(section: MovieSection) {
        fetchMovieList(fetchFunction: { try await NetworkManager.shared.fetchUpcomingMovieList(page: 1) }, section: section)
    }

    private func fetchTopRatedMovieList(section: MovieSection) {
        fetchMovieList(fetchFunction: { try await NetworkManager.shared.fetchTopRatedMovieList() }, section: section)
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

    private func fetchMovieList(fetchFunction: @escaping () async throws -> FetchMoviesResponse, section: MovieSection) {
        Task {
            do {
                await MainActor.run {
                    presenter.showLoading()
                }

                let response = try await fetchFunction()

                await MainActor.run {
                    presenter.popLoading()
                    presenter.didFetchMovieSuccess(response.movieList.filter { $0.imageURL != nil }, section: section)
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
