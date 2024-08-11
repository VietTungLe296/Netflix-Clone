//
//  HomeRouter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import UIKit

protocol HomeRoutingLogic: AnyObject {}

final class HomeRouter: NSObject, HomeRoutingLogic {
    weak var viewController: HomeViewController?

    init(viewController: HomeViewController?) {
        self.viewController = viewController
    }
}
