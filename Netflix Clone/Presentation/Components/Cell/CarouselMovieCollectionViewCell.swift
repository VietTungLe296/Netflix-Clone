//
//  CarouselMovieCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 23/8/24.
//

import SDWebImage
import UIKit

final class CarouselMovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(with model: Movie) {
        posterImageView.sd_setImage(with: model.imageURL, 
                                    placeholderImage: UIImage(named: "default"),
                                    context: nil)
    }
}
