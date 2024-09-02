//
//  MovieCollectionTableViewCell.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 11/08/2024.
//

import UIKit

protocol MovieCollectionTableCellDelegate: AnyObject {
    func didTapMovie(_ movie: Movie, isAutoplay: Bool)
}

final class MovieCollectionTableViewCell: UITableViewCell {
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    weak var delegate: MovieCollectionTableCellDelegate?
    
    private var movieList = [Movie]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.registerCell(CarouselMovieCollectionViewCell.self)
    }
    
    func bind(with movieList: [Movie]) {
        self.movieList = movieList
        
        DispatchQueue.main.async { [weak self] in
            self?.movieCollectionView.reloadData()
        }
    }
}

extension MovieCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(CarouselMovieCollectionViewCell.self, at: indexPath)
        cell.bind(with: movieList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        delegate?.didTapMovie(movieList[indexPath.row], isAutoplay: false)
    }
}
