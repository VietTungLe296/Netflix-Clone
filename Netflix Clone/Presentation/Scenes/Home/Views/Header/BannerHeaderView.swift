//
//  BannerHeaderView.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 11/08/2024.
//

import UIKit

final class BannerHeaderView: UIView {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
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
        setupButtons()
    }
    
    private func setupButtons() {
        playButton.setTitle("Play".localized, for: .normal)
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = 1
        playButton.layer.cornerRadius = 6
        
        downloadButton.setTitle("Download".localized, for: .normal)
        downloadButton.layer.borderColor = UIColor.white.cgColor
        downloadButton.layer.borderWidth = 1
        downloadButton.layer.cornerRadius = 6
    }
}
