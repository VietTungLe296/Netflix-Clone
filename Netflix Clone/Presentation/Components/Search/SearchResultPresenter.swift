//
//  SearchResultPresenter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

protocol SearchResultPresentationLogic: Presentable {
    func didFetchMovieSuccess(_ movieList: [Movie])
    func didFetchMovieFailure(error: any Error)
}

final class SearchResultPresenter: SearchResultPresentationLogic {
    private weak var viewController: SearchResultDisplayLogic?

    init(viewController: SearchResultDisplayLogic?) {
        self.viewController = viewController
    }
    
    func didFetchMovieSuccess(_ movieList: [Movie]) {
        viewController?.displayFetchedMovieList(movieList)
    }

    func didFetchMovieFailure(error: any Error) {
        print(error.localizedDescription)
    }
}
