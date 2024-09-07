//
//  BottomAlertView.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 7/9/24.
//

import UIKit

final class BottomAlertView: UIView {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var didTapClose: (() -> Void)?
    
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
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    func setup(type: AlertType, message: String) {
        messageLabel.text = message
        
        switch type {
        case .success:
            backgroundColor = UIColor(red: 102, green: 195, blue: 151, alpha: 1)
            iconImageView.image = UIImage(named: "ic_success")
        case .error:
            backgroundColor = UIColor(red: 250, green: 237, blue: 240, alpha: 1)
            iconImageView.image = UIImage(named: "ic_error")
        case .info:
            backgroundColor = UIColor(red: 236, green: 241, blue: 254, alpha: 1)
            iconImageView.image = UIImage(named: "ic_info")
        }
    }
    
    @IBAction private func didTapClose(_ sender: Any) {
        didTapClose?()
    }
}
