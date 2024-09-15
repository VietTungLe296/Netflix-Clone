//
//  CarouselMovieCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 23/8/24.
//

import SkeletonView
import UIKit

final class CarouselMovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(with movie: Movie) {
        posterImageView.fetchImage(url: movie.imageURL, placeholderImage: UIImage(named: "default"))
    }
}
