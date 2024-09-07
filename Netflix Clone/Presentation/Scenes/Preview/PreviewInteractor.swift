//
//  PreviewInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 2/9/24.
//

import Foundation

protocol PreviewBusinessLogic: AnyObject {
    func getMovieTitle() -> String?
    func getMovieOverview() -> String?
    func getTrailerUrl() -> URL?
    func getVideoId() -> String?
    func isMovieDownloaded(_ completion: @escaping (Bool) -> Void)
    func downloadMovie()
}

final class PreviewInteractor: PreviewBusinessLogic {
    private let presenter: PreviewPresentationLogic
    private let dependencies: PreviewBuilder.Dependencies

    init(presenter: PreviewPresentationLogic, dependencies: PreviewBuilder.Dependencies) {
        self.presenter = presenter
        self.dependencies = dependencies
    }

    func getMovieTitle() -> String? {
        return dependencies.movie.displayTitle
    }

    func getMovieOverview() -> String? {
        return dependencies.movie.overview
    }

    func getTrailerUrl() -> URL? {
        guard let videoId = dependencies.videoId.videoId else { return nil }
        return URL(string: "\(AppConstants.YOUTUBE_EMBED)\(videoId)")
    }

    func getVideoId() -> String? {
        guard let videoId = dependencies.videoId.videoId else { return nil }
        return videoId
    }

    func isMovieDownloaded(_ completion: @escaping (Bool) -> Void) {
        DataPersistenceManager.shared.fetchDownloadedMovies { [weak self] result in
            switch result {
            case .success(let movieList):
                completion(movieList.contains(where: { $0.id == self?.dependencies.movie.id }))
            case .failure:
                completion(false)
            }
        }
    }

    func downloadMovie() {
        DataPersistenceManager.shared.downloadMovie(dependencies.movie) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                self.presenter.showBottomAlert(type: .success, message: String(format: "Saved %@ successfully".localized, dependencies.movie.displayTitle))
                NotificationCenter.default.post(name: .updateDownloadedMovieTab, object: nil, userInfo: nil)
            case .failure(let failure):
                self.presenter.showBottomAlert(type: .error, message: failure.message)
            }
        }
    }
}
