//
//  HomeInteractor.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import Foundation

protocol HomeBusinessLogic: AnyObject {}

final class HomeInteractor: HomeBusinessLogic {
    private let presenter: HomePresentationLogic
    private weak var router: HomeRoutingLogic!

    init(presenter: HomePresentationLogic, router: HomeRoutingLogic) {
        self.presenter = presenter
        self.router = router
    }
}
