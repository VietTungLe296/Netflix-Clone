//
//  Movie.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 12/8/24.
//

import Foundation

struct Movie: Codable {
    let id: Int64
    let mediaType: String?
    let originalName: String?
    let originalTitle: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int64?
    let voteAverage: Double?
    let releaseDate: String?
    let adult: Bool?

    init(from model: MovieCoreDataModel) {
        self.id = model.id
        self.mediaType = model.mediaType
        self.originalName = model.originalName
        self.originalTitle = model.originalTitle
        self.posterPath = model.posterPath
        self.overview = model.overview
        self.voteCount = model.voteCount
        self.voteAverage = model.voteAverage
        self.releaseDate = model.releaseDate
        self.adult = model.adult
    }

    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case originalName = "original_name"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case overview
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case adult
    }

    var imageURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
    }
}

struct FetchMoviesResponse: Codable {
    let movieList: [Movie]
    let currentPage: Int
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case movieList = "results"
        case currentPage = "page"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
