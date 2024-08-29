//
//  MovieTitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 29/8/24.
//

import UIKit

final class MovieTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(with model: Movie) {
        posterImageView.sd_setImage(with: model.imageURL,
                                    placeholderImage: UIImage(named: "default"),
                                    context: nil)
        
        titleLabel.text = model.originalTitle ?? model.originalName
    }
}
