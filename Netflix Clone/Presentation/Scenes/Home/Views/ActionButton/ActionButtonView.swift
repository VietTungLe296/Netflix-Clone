//
//  ActionButtonView.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 31/8/24.
//

import UIKit

final class ActionButtonView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        _ = fromNib()
        layer.cornerRadius = 8
    }

    func setup(backgroundColor: UIColor,
               title: String, titleColor: UIColor,
               image: UIImage, imageTintColor: UIColor)
    {
        self.backgroundColor = backgroundColor

        titleLabel.text = title
        titleLabel.textColor = titleColor

        imageView.image = image
        imageView.tintColor = imageTintColor
    }
}
