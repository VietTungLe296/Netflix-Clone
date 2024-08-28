//
//  AppConfig.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import Foundation

final class AppConfig {
    static let shared = AppConfig()

    var apiToken: String? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let token = config["API_TOKEN"] as? String
        else {
            print("INVALID API TOKEN")
            return nil
        }
        return token
    }
}
