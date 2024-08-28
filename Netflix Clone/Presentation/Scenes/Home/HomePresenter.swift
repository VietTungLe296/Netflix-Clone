//
//  HomePresenter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import UIKit

protocol HomePresentationLogic: Presentable {
    func didFetchMovieSuccess(_ movieList: [Movie], section: MovieSection)
    func didFetchMovieFailure(error: Error)
}

final class HomePresenter: HomePresentationLogic {
    private weak var viewController: HomeDisplayLogic?

    init(viewController: HomeDisplayLogic?) {
        self.viewController = viewController
    }
    
    func didFetchMovieSuccess(_ movieList: [Movie], section: MovieSection) {
        viewController?.displayFetchedMovieList(movieList, forSection: section)
    }
    
    func didFetchMovieFailure(error: any Error) {
        print(error.localizedDescription)
    }
}
