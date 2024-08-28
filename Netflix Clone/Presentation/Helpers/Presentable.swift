//
//  Presentable.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 12/8/24.
//

import Foundation

protocol Presentable: AnyObject {
    func showLoading()
    func hideLoading()
    func popLoading()
}

extension Presentable {
    func showLoading() {
        CommonViewPresenter.shared.showLoadingView()
    }
    
    func hideLoading() {
        CommonViewPresenter.shared.hideLoadingView()
    }
    
    func popLoading() {
        CommonViewPresenter.shared.popLoadingView()
    }
}
