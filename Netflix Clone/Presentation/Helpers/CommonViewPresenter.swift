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

    func showBottomAlert(type: AlertType, message: String, completion: (() -> Void)? = nil) {
        guard let currentVC = UIApplication.topViewController(), let view = currentVC.view else {
            return
        }

        let alertView = BottomAlertView()
        alertView.setup(type: type, message: message)
        alertView.didTapClose = {
            alertView.removeFromSuperview()
        }

        let maxWidth = view.frame.size.width - 16
        let maxHeight = alertView.messageLabel.text?.height(withConstrainedWidth: maxWidth - 40 * 2,
                                                            font: .preferredFont(forTextStyle: .callout)) ?? 0

        alertView.frame = CGRect(x: (view.frame.size.width - maxWidth) / 2,
                                 y: view.frame.size.height,
                                 width: maxWidth,
                                 height: maxHeight + 16)

        view.addSubview(alertView)

        let closeCompletion = {
            UIView.animate(withDuration: 0.5, animations: {
                alertView.frame.origin.y = view.frame.size.height
            }, completion: { _ in
                alertView.removeFromSuperview()
            })

            completion?()
        }

        alertView.didTapClose = {
            closeCompletion()
        }

        UIView.animate(withDuration: 0.5, animations: {
            alertView.frame.origin.y = view.frame.size.height - maxHeight - 128
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                closeCompletion()
            }
        })
    }
}
