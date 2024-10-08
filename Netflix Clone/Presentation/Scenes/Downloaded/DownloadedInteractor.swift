//
//  DownloadedInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 3/9/24.
//

import Foundation

protocol DownloadedBusinessLogic: AnyObject {
    func fetchDownloadedMovie()
    func fetchYoutubeTrailer(for movie: Movie, isAutoplay: Bool)
    func deleteMovie(_ movie: Movie, _ completion: @escaping () -> Void)
    func updateSortType(_ sortType: SortType)
}

final class DownloadedInteractor: DownloadedBusinessLogic {
    private let presenter: DownloadedPresentationLogic

    private var sortType: SortType = .nameAscending

    init(presenter: DownloadedPresentationLogic) {
        self.presenter = presenter
    }

    func fetchDownloadedMovie() {
        DataPersistenceManager.shared.fetchDownloadedMovies { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let movieList):
                switch sortType {
                case .nameAscending:
                    self.presenter.didFetchMovieSuccess(movieList.sorted(by: { $0.displayTitle < $1.displayTitle }))
                case .nameDescending:
                    self.presenter.didFetchMovieSuccess(movieList.sorted(by: { $0.displayTitle > $1.displayTitle }))
                }
            case .failure(let failure):
                self.presenter.showBottomAlert(type: .error, message: failure.message)
            }
        }
    }

    func fetchYoutubeTrailer(for movie: Movie, isAutoplay: Bool) {
        Task {
            do {
                await MainActor.run {
                    presenter.showLoading(maskType: .gradient)
                }

                let response = try await NetworkManager.shared.fetchYoutubeTrailer(with: movie.displayTitle)

                await MainActor.run {
                    presenter.popLoading()

                    guard let videoId = response.videoList.first?.id else {
                        return
                    }

                    presenter.didFetchYoutubeTrailer(for: movie, videoId: videoId, isAutoplay: isAutoplay)
                }
            } catch let error as APIError {
                await MainActor.run {
                    presenter.popLoading()
                    self.presenter.showBottomAlert(type: .error, message: error.message)
                }
            }
        }
    }

    func deleteMovie(_ movie: Movie, _ completion: @escaping () -> Void) {
        DataPersistenceManager.shared.deleteMovie(movie) { [weak self] result in
            switch result {
            case .success:
                self?.presenter.showBottomAlert(type: .success, message: String(format: "Deleted %@ successfully".localized, movie.displayTitle))
                completion()
            case .failure(let failure):
                self?.presenter.showBottomAlert(type: .error, message: failure.message)
            }
        }
    }

    func updateSortType(_ sortType: SortType) {
        self.sortType = sortType
    }
}
