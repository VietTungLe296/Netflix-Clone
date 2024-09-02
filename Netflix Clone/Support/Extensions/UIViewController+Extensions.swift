//
//  UIViewController+Extensions.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 2/9/24.
//

import UIKit

extension UIViewController {
    func push(to destination: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(destination, animated: false)
    }
}
