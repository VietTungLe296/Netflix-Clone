//
//  AppConfig.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import Foundation

final class AppConfig {
    static let shared = AppConfig()
    
    private init() {}
    
    private var config: NSDictionary? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path)
        else {
            print("INVALID CONFIGURATION")
            return nil
        }
        return config
    }
    
    private func getToken(forKey key: String) -> String? {
        guard let token = config?[key] as? String else {
            print("INVALID TOKEN FOR KEY: \(key)")
            return nil
        }
        return token
    }
    
    var movieDBToken: String? {
        return getToken(forKey: "MOVIE_DB_API_TOKEN")
    }
    
    var youtubeToken: String? {
        return getToken(forKey: "GOOGLE_YOUTUBE_API_TOKEN")
    }
}
