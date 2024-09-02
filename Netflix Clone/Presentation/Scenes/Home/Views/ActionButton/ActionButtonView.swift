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

    @IBInspectable
    var title: String? {
        didSet {
            titleLabel.text = title?.localized
        }
    }

    @IBInspectable
    var titleColor: UIColor? {
        didSet {
            titleLabel.textColor = titleColor
        }
    }

    @IBInspectable
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    @IBInspectable
    var imageTintColor: UIColor? {
        didSet {
            imageView.tintColor = imageTintColor
        }
    }
}
