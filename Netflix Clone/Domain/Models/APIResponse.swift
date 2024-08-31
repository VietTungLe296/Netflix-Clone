//
//  APIResponse.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 31/8/24.
//

import Foundation

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
