//
//  SearchResultRouter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

protocol SearchResultRoutingLogic: AnyObject {}

final class SearchResultRouter: SearchResultRoutingLogic {
    private weak var viewController: SearchResultViewController?

    init(viewController: SearchResultViewController?) {
        self.viewController = viewController
    }
}
