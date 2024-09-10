//
//  MovieTitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 29/8/24.
//

import SkeletonView
import UIKit

protocol MovieTitleTableViewCellDelegate: AnyObject {
    func didTapMovie(_ movie: Movie, isAutoplay: Bool)
}

final class MovieTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: MovieTitleTableViewCellDelegate?
    
    private var movie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(with movie: Movie) {
        self.movie = movie
        
        posterImageView.fetchImage(url: movie.imageURL, placeholderImage: UIImage(named: "default"))
        
        titleLabel.text = movie.displayTitle
    }
    
    @IBAction func didTapPlay(_ sender: Any) {
        guard let movie else { return }
        
        delegate?.didTapMovie(movie, isAutoplay: true)
    }
}
