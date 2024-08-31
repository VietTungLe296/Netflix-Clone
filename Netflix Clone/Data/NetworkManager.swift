//
//  NetworkManager.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 12/8/24.
//

import Foundation

final class NetworkManager {
    private let baseURL = "https://api.themoviedb.org/3"
    static let shared = NetworkManager()
    
    func fetchTrendingMovieList(type: TrendingType) async throws -> FetchMoviesResponse {
        do {
            let request = try createGetRequest(with: "/trending/movie/\(type.rawValue)")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode(FetchMoviesResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    func fetchUpcomingMovieList() async throws -> FetchMoviesResponse {
        do {
            let request = try createGetRequest(with: "/movie/upcoming")
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
            let request = try createGetRequest(with: "/movie/top_rated")
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
            let request = try createGetRequest(with: "/movie/popular")
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
            let request = try createGetRequest(with: "/trending/tv/\(type.rawValue)")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode(FetchMoviesResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    func fetchDiscoverMovies(includeVideos: Bool, includeAdult: Bool, sortType: DiscoverSortType) async throws -> FetchMoviesResponse {
        do {
            let params = ["include_video": String(includeVideos),
                          "include_adult": String(includeAdult),
                          "sort_by": sortType.rawValue]
            
            let request = try createGetRequest(with: "/discover/movie", params: params)
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
            
            let request = try createGetRequest(with: "/search/movie", params: params)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode(FetchMoviesResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    private func createGetRequest(with path: String, params: [String: String] = [:]) throws -> URLRequest {
        guard let url = URL(string: "\(baseURL)\(path)") else {
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
            "Authorization": "Bearer \(AppConfig.shared.apiToken ?? "")"
        ]
        
        return request
    }
}
