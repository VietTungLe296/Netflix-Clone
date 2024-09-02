//
//  CommonViewPresenter.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 12/8/24.
//

import SVProgressHUD
import UIKit

final class CommonViewPresenter {
    static let shared = CommonViewPresenter()

    func hideLoadingView() {
        SVProgressHUD.dismiss()
    }

    func showLoadingView(maskType: SVProgressHUDMaskType = .none) {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.automatic)
        SVProgressHUD.setDefaultMaskType(maskType)
        SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.1))
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.6))
        SVProgressHUD.setForegroundColor(.white)
    }

    func popLoadingView() {
        SVProgressHUD.popActivity()
    }
}
