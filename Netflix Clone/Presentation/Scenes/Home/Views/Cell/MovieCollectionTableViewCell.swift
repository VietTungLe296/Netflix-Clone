//
//  MovieCollectionTableViewCell.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 11/08/2024.
//

import SkeletonView
import UIKit

protocol MovieCollectionTableCellDelegate: AnyObject {
    func didTapMovie(_ movie: Movie, isAutoplay: Bool)
    func didDownloadMovie(_ movie: Movie)
}

final class MovieCollectionTableViewCell: UITableViewCell {
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    weak var delegate: MovieCollectionTableCellDelegate?
    
    private var movieList = [Movie]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        
        showAnimatedGradientSkeleton()
    }
    
    private func setupCollectionView() {
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.registerCell(CarouselMovieCollectionViewCell.self)
    }
    
    func bind(with movieList: [Movie]) {
        self.movieList = movieList
        
        DispatchQueue.main.async { [weak self] in
            self?.hideSkeleton()
            self?.movieCollectionView.reloadData()
        }
    }
}

extension MovieCollectionTableViewCell: SkeletonCollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: CarouselMovieCollectionViewCell.self)
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let movie = movieList[indexPath.row]
        
        let config = UIContextMenuConfiguration(actionProvider: { _ in
            let downloadAction = UIAction(title: "Download".localized,
                                          image: UIImage(systemName: "arrow.down.circle.fill"))
            { [weak self] _ in
                self?.delegate?.didDownloadMovie(movie)
            }
            
            return UIMenu(options: [.displayInline], children: [downloadAction])
        })
        
        return config
    }
}
