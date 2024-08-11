//
//  HomePresenter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import UIKit

protocol HomePresentationLogic: AnyObject {}

final class HomePresenter: HomePresentationLogic {
    private weak var viewController: HomeDisplayLogic?

    init(viewController: HomeDisplayLogic?) {
        self.viewController = viewController
    }
}
