//
//  ComingSoonPresenter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import UIKit

protocol ComingSoonPresentationLogic: Presentable {
    func didFetchMovieSuccess(_ movieList: [Movie])
    func didFetchMovieFailure(error: any Error)
}

final class ComingSoonPresenter: ComingSoonPresentationLogic {
    private weak var viewController: ComingSoonDisplayLogic?

    init(viewController: ComingSoonDisplayLogic?) {
        self.viewController = viewController
    }

    func didFetchMovieSuccess(_ movieList: [Movie]) {
        viewController?.displayFetchedMovieList(movieList)
    }

    func didFetchMovieFailure(error: any Error) {
        print(error.localizedDescription)
    }
}
