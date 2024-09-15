//
//  BannerHeaderView.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 11/08/2024.
//

import SkeletonView
import UIKit

protocol BannerHeaderViewDelegate: AnyObject {
    func didTapMovie(_ movie: Movie, isAutoplay: Bool)
    func didDownloadMovie(_ movie: Movie)
}

final class BannerHeaderView: UIView {
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var playButton: ActionButtonView!
    @IBOutlet weak var downloadButton: ActionButtonView!
    @IBOutlet weak var carouselPageControl: UIPageControl!
    
    weak var delegate: BannerHeaderViewDelegate?
    
    private var movieList = [Movie]()
    
    private var currentPage = 0
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    deinit {
        stopTimer()
    }

    private func commonInit() {
        _ = fromNib()
        setupButtons()
        setupCollectionView()
    }
    
    private func setupButtons() {
        playButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPlay)))
        downloadButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDownload)))
    }
    
    private func setupCollectionView() {
        let layout = SnappingCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: bounds.width, height: bounds.height)
        
        carouselCollectionView.collectionViewLayout = layout
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.registerCell(CarouselMovieCollectionViewCell.self)
    }
    
    func setTimer() {
        if timer == nil && !movieList.isEmpty {
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updatePageControlAndScroll), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func didTapPlay() {
        guard let currentIndexPath = carouselCollectionView.currentCenteredItemIndex() else {
            return
        }
        
        delegate?.didTapMovie(movieList[currentIndexPath.row], isAutoplay: true)
    }
    
    @objc private func didTapDownload() {
        guard let currentIndexPath = carouselCollectionView.currentCenteredItemIndex() else {
            return
        }
        
        delegate?.didDownloadMovie(movieList[currentIndexPath.row])
    }
    
    @objc private func updatePageControlAndScroll() {
        var nextPage = carouselPageControl.currentPage + 1
        
        if nextPage >= movieList.count {
            nextPage = 0
        }
        
        carouselPageControl.currentPage = nextPage
        
        let indexPath = IndexPath(item: nextPage, section: 0)
        carouselCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func bind(with movieList: [Movie]) {
        self.movieList = movieList
        
        carouselPageControl.numberOfPages = movieList.count
        setTimer()
        
        DispatchQueue.main.async { [weak self] in
            self?.carouselCollectionView.reloadData()
        }
    }
}

extension BannerHeaderView: SkeletonCollectionViewDataSource, UICollectionViewDelegate {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: CarouselMovieCollectionViewCell.self)
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(CarouselMovieCollectionViewCell.self, at: indexPath)
        cell.bind(with: movieList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        delegate?.didTapMovie(movieList[indexPath.row], isAutoplay: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let indexPath = carouselCollectionView.indexPathForItem(at: visiblePoint) {
            carouselPageControl.currentPage = indexPath.item
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stopTimer()
    }
}
