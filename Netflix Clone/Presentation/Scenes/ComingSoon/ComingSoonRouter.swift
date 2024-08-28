//
//  ComingSoonRouter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import UIKit

protocol ComingSoonRoutingLogic: AnyObject {}

final class ComingSoonRouter: ComingSoonRoutingLogic {
    private weak var viewController: ComingSoonViewController?

    init(viewController: ComingSoonViewController?) {
        self.viewController = viewController
    }
}
