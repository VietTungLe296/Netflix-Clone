//
//  UpcomingRouter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import UIKit

protocol UpcomingRoutingLogic: AnyObject {}

final class UpcomingRouter: UpcomingRoutingLogic {
    private weak var viewController: UpcomingViewController?

    init(viewController: UpcomingViewController?) {
        self.viewController = viewController
    }
}
