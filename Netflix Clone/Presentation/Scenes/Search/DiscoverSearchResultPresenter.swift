//
//  DiscoverSearchResultPresenter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

protocol DiscoverSearchResultPresentationLogic: Presentable {
    func didFetchMovieSuccess(_ movieList: [Movie])
}

final class DiscoverSearchResultPresenter: DiscoverSearchResultPresentationLogic {
    private weak var viewController: DiscoverSearchResultDisplayLogic?

    init(viewController: DiscoverSearchResultDisplayLogic?) {
        self.viewController = viewController
    }

    func didFetchMovieSuccess(_ movieList: [Movie]) {
        viewController?.displayFetchedMovieList(movieList)
    }
}
