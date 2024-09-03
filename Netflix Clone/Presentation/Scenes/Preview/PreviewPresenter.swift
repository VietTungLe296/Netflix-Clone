//
//  PreviewPresenter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 2/9/24.
//

import UIKit

protocol PreviewPresentationLogic: Presentable {}

final class PreviewPresenter: PreviewPresentationLogic {
    private weak var viewController: PreviewDisplayLogic?

    init(viewController: PreviewDisplayLogic?) {
        self.viewController = viewController
    }
}
