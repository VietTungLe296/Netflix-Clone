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
}

final class PreviewInteractor: PreviewBusinessLogic {
    private let presenter: PreviewPresentationLogic
    private let dependencies: PreviewBuilder.Dependencies

    init(presenter: PreviewPresentationLogic, dependencies: PreviewBuilder.Dependencies) {
        self.presenter = presenter
        self.dependencies = dependencies
    }

    func getMovieTitle() -> String? {
        return dependencies.movie.originalTitle ?? dependencies.movie.originalName
    }

    func getMovieOverview() -> String? {
        return dependencies.movie.overview
    }

    func getTrailerUrl() -> URL? {
        guard let videoId = dependencies.videoId.videoId else { return nil }
        return URL(string: "\(AppConstants.YOUTUBE_EMBED)\(videoId)")
    }
}
