//
//  MovieCollectionTableViewCell.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 11/08/2024.
//

import UIKit

final class MovieCollectionTableViewCell: UITableViewCell {
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.registerCell(UICollectionViewCell.self, nibType: false)
    }
}

extension MovieCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(UICollectionViewCell.self, at: indexPath)
        cell.backgroundColor = .systemRed
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
}
