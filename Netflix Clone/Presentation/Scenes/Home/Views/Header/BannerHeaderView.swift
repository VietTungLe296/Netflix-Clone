//
//  BannerHeaderView.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 11/08/2024.
//

import UIKit

final class BannerHeaderView: UIView {
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var playButton: ActionButtonView!
    @IBOutlet weak var downloadButton: ActionButtonView!
    @IBOutlet weak var carouselPageControl: UIPageControl!
    
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
        timer?.invalidate()
    }

    private func commonInit() {
        _ = fromNib()
        setupButtons()
        setupCollectionView()
        setupTimer()
    }
    
    private func setupButtons() {
        playButton.setup(backgroundColor: .red,
                         title: "Play".localized, titleColor: .white,
                         image: UIImage(systemName: "play.circle.fill")!, imageTintColor: .white)
        
        downloadButton.setup(backgroundColor: .white,
                             title: "Download".localized, titleColor: .black,
                             image: UIImage(systemName: "arrow.down.circle.fill")!, imageTintColor: .black)
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
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updatePageControlAndScroll), userInfo: nil, repeats: true)
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
        
        DispatchQueue.main.async { [weak self] in
            self?.carouselCollectionView.reloadData()
        }
    }
}

extension BannerHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(CarouselMovieCollectionViewCell.self, at: indexPath)
        cell.bind(with: movieList[indexPath.row])
        return cell
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
        setupTimer()
    }
}
