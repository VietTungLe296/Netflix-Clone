//
//  NetworkManager.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 12/8/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchTrendingMovieList(type: TrendingType) async throws -> FetchMoviesResponse {
        do {
            let request = try createGetMoviesRequest(with: "/trending/movie/\(type.rawValue)")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode(FetchMoviesResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    func fetchUpcomingMovieList(page: Int) async throws -> FetchMoviesResponse {
        do {
            let params = ["page": String(page)]
            
            let request = try createGetMoviesRequest(with: "/movie/upcoming", params: params)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode(FetchMoviesResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    func fetchTopRatedMovieList() async throws -> FetchMoviesResponse {
        do {
            let request = try createGetMoviesRequest(with: "/movie/top_rated")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            return try JSONDecoder().decode(FetchMoviesResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    func fetchPopularMovieList() async throws -> FetchMoviesResponse {
        do {
            let request = try createGetMoviesRequest(with: "/movie/popular")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode(FetchMoviesResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    func fetchTrendingTVs(type: TrendingType) async throws -> FetchMoviesResponse {
        do {
            let request = try createGetMoviesRequest(with: "/trending/tv/\(type.rawValue)")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode(FetchMoviesResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    func fetchDiscoverMovies(page: Int, includeVideos: Bool, includeAdult: Bool, sortType: DiscoverSortType) async throws -> FetchMoviesResponse {
        do {
            let params = ["page": String(page),
                          "include_video": String(includeVideos),
                          "include_adult": String(includeAdult),
                          "sort_by": sortType.rawValue]
            
            let request = try createGetMoviesRequest(with: "/discover/movie", params: params)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode(FetchMoviesResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    func searchMovies(with keyword: String, includeAdult: Bool) async throws -> FetchMoviesResponse {
        do {
            let params = ["query": keyword,
                          "include_adult": String(includeAdult)]
            
            let request = try createGetMoviesRequest(with: "/search/movie", params: params)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode(FetchMoviesResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    private func createGetMoviesRequest(with path: String, params: [String: String] = [:]) throws -> URLRequest {
        guard let url = URL(string: "\(AppConstants.movieDBBaseURL)\(path)") else {
            throw URLError(.badURL)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = components.queryItems ?? []
        components.queryItems?.append(URLQueryItem(name: "language", value: LanguageManager.shared.isVietnamese ? "vi-VN" : "en-US"))
        components.queryItems?.append(contentsOf: params.compactMap { URLQueryItem(name: $0.key, value: $0.value) })
        
        guard let finalURL = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(AppConfig.shared.movieDBToken ?? "")"
        ]
        
        return request
    }
}

extension NetworkManager {
    func fetchYoutubeTrailer(with keyword: String) async throws -> FetchYoutubeVideosResponse {
//        #warning("Remove this sample response")
//        return FetchYoutubeVideosResponse(videoList: [.init(id: .init(kind: "", videoId: "OzY2r2JXsDM"))])
        
        do {
            guard let url = URL(string: AppConstants.youtubeBaseURL) else {
                throw URLError(.badURL)
            }
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.queryItems = components.queryItems ?? []
            components.queryItems?.append(contentsOf: [URLQueryItem(name: "part", value: "snippet"),
                                                       URLQueryItem(name: "q", value: keyword + " trailer"),
                                                       URLQueryItem(name: "key", value: AppConfig.shared.youtubeToken)])
            
            guard let finalURL = components.url else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: finalURL)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = ["accept": "application/json"]
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode(FetchYoutubeVideosResponse.self, from: data)
        } catch {
            throw error
        }
    }
}
