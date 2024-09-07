//
//  UIViewController+Extensions.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 2/9/24.
//

import UIKit

extension UIViewController {
    func push(to destination: UIViewController,
              duration: CFTimeInterval = 0.5,
              transitionType: CATransitionType = .push,
              subtype: CATransitionSubtype = .fromRight)
    {
        guard let navigationController = navigationController else { return }

        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = transitionType
        transition.subtype = subtype

        navigationController.view.layer.add(transition, forKey: nil)
        navigationController.pushViewController(destination, animated: false)
    }
}
