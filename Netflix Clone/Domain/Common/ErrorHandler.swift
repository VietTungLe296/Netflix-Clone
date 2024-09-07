//
//  ErrorHandler.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 7/9/24.
//

import Foundation

enum APIError: Error {
    case urlError
    case networkError
    case serverError
    case decodeError
    case others

    var message: String {
        switch self {
        case .networkError:
            return "Please check the internet connection and try again.".localized
        case .serverError:
            return "System busy. Please try again later.".localized
        case .urlError, .decodeError, .others:
            if self == .others {
                print("ERROR =>>>>>>>>>>>>>>>: ", localizedDescription)
            }

            return "An unknown error occurred. Please try again later.".localized
        }
    }
}

enum CoreDataError: Error {
    case duplicated
    case notExisted
    case others

    var message: String {
        switch self {
        case .duplicated:
            return "This movie has been downloaded.".localized
        case .notExisted:
            return "System busy. Please try again later.".localized
        case .others:
            print("ERROR =>>>>>>>>>>>>>>>: ", localizedDescription)
            return "An unknown error occurred. Please try again later.".localized
        }
    }
}
