//
//  DiscoverRouter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

protocol DiscoverRoutingLogic: AnyObject {}

final class DiscoverRouter: DiscoverRoutingLogic {
    private weak var viewController: DiscoverViewController?

    init(viewController: DiscoverViewController?) {
        self.viewController = viewController
    }
}
