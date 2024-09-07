//
//  Presentable.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 12/8/24.
//

import Foundation
import SVProgressHUD

protocol Presentable: AnyObject {
    func showLoading(maskType: SVProgressHUDMaskType)
    func hideLoading()
    func popLoading()
    func showBottomAlert(type: AlertType, message: String, completion: (() -> Void)?)
}

extension Presentable {
    func showLoading(maskType: SVProgressHUDMaskType = .none) {
        CommonViewPresenter.shared.showLoadingView(maskType: maskType)
    }
    
    func hideLoading() {
        CommonViewPresenter.shared.hideLoadingView()
    }
    
    func popLoading() {
        CommonViewPresenter.shared.popLoadingView()
    }
    
    func showBottomAlert(type: AlertType, message: String, completion: (() -> Void)? = nil) {
        CommonViewPresenter.shared.showBottomAlert(type: type, message: message, completion: completion)
    }
}
