//
//  YoutubeVideo.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 2/9/24.
//

import Foundation

struct YoutubeVideoId: Codable {
    let kind: String
    let videoId: String?
}

struct YoutubeVideo: Codable {
    let id: YoutubeVideoId
}

struct FetchYoutubeVideosResponse: Codable {
    let videoList: [YoutubeVideo]

    enum CodingKeys: String, CodingKey {
        case videoList = "items"
    }
}
