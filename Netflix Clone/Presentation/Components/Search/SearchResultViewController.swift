//
//  SearchResultViewController.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

protocol SearchResultUpdating: AnyObject {
    func updateSearchResults(with keyword: String)
}

protocol SearchResultDisplayLogic: AnyObject {
    func displayFetchedMovieList(_ movieList: [Movie])
}

final class SearchResultViewController: UIViewController, SearchResultUpdating {
    var interactor: SearchResultBusinessLogic?
    var router: SearchResultRoutingLogic?

    @IBOutlet weak var includeAdultSwitch: UISwitch!
    @IBOutlet weak var includeAdultLabel: UILabel!
    @IBOutlet weak var searchCollectionView: UICollectionView!

    private var movieList = [Movie]()
    private var displayMovieList = [Movie]()

    private var keyword = ""
    private var isIncludeAdult = false {
        didSet {
            if isIncludeAdult {
                displayMovieList = movieList
            } else {
                displayMovieList = movieList.filter { $0.adult == false }
            }

            DispatchQueue.main.async { [weak self] in
                self?.searchCollectionView.reloadData()
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchDataOnLoad()
    }

    // MARK: Fetch SearchResult

    private func fetchDataOnLoad() {}

    // MARK: SetupUI

    private func setupView() {
        setupSwitchView()
        setupCollectionView()
    }

    private func setupSwitchView() {
        includeAdultLabel.text = "Hide/Show adult content".localized
    }

    private func setupCollectionView() {
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.registerCell(CarouselMovieCollectionViewCell.self)
    }

    @IBAction func didTapSwitch(_ sender: UISwitch) {
        isIncludeAdult.toggle()
    }

    func updateSearchResults(with keyword: String) {
        self.keyword = keyword

        interactor?.searchMovies(with: keyword, includeAdult: true)
    }
}

extension SearchResultViewController: SearchResultDisplayLogic {
    func displayFetchedMovieList(_ movieList: [Movie]) {
        self.movieList = movieList.filter { $0.imageURL != nil }
        isIncludeAdult = includeAdultSwitch.isOn
    }
}

extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayMovieList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(CarouselMovieCollectionViewCell.self, at: indexPath)
        cell.bind(with: displayMovieList[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
