//
//  Common.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 22/8/24.
//

import Foundation

enum TrendingType: String {
    case day
    case week
}

enum DiscoverSortType: String {
    case popularityAsc = "popularity_asc"
    case popularityDesc = "popularity_desc"
}

enum SortType {
    case nameAscending
    case nameDescending
}

enum AlertType {
    case success
    case error
    case info
}
