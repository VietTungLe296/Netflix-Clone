//
//  UIImageView+Extensions.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 11/9/24.
//

import SDWebImage
import UIKit

extension UIImageView {
    func fetchImage(url: URL?, placeholderImage: UIImage?, _ completion: ((Bool) -> Void)? = nil) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: url, placeholderImage: placeholderImage, options: SDWebImageOptions(rawValue: 0), completed: { image, error, _, _ in
            self.image = error == nil ? image : placeholderImage
            completion?(error == nil)
        })
    }
}
