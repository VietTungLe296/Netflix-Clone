//
//  DiscoverPresenter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

protocol DiscoverPresentationLogic: Presentable {
    func didFetchMovieSuccess(_ movieList: [Movie], totalPages: Int)
    func didFetchMovieFailure(error: any Error)
}

final class DiscoverPresenter: DiscoverPresentationLogic {
    private weak var viewController: DiscoverDisplayLogic?

    init(viewController: DiscoverDisplayLogic?) {
        self.viewController = viewController
    }
    
    func didFetchMovieSuccess(_ movieList: [Movie], totalPages: Int) {
        viewController?.displayFetchedMovieList(movieList, totalPages: totalPages)
    }

    func didFetchMovieFailure(error: any Error) {
        print(error.localizedDescription)
    }
}
