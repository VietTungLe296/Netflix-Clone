//
//  DiscoverSearchResultViewController.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

protocol DiscoverSearchResultDelegate: AnyObject {
    func didTapMovie(_ movie: Movie, isAutoplay: Bool)
}

protocol DiscoverSearchResultDisplayLogic: AnyObject {
    func displayFetchedMovieList(_ movieList: [Movie])
}

final class DiscoverSearchResultViewController: UIViewController {
    var interactor: DiscoverSearchResultBusinessLogic?

    @IBOutlet weak var includeAdultSwitch: UISwitch!
    @IBOutlet weak var includeAdultLabel: UILabel!
    @IBOutlet weak var searchCollectionView: UICollectionView!

    weak var delegate: DiscoverSearchResultDelegate?

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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Fetch SearchResult

    private func fetchDataOnLoad() {}

    // MARK: SetupUI

    private func setupView() {
        setupSwitchView()
        setupCollectionView()
        setupObservers()
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

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateSearchKeyword(_:)), name: .updateDiscoverSearchKeyword, object: nil)
    }

    @objc private func updateSearchKeyword(_ notification: Notification) {
        guard let keyword = notification.userInfo?["keyword"] as? String else {
            return
        }

        self.keyword = keyword
        interactor?.searchMovies(with: keyword, includeAdult: true)
    }
}

extension DiscoverSearchResultViewController: DiscoverSearchResultDisplayLogic {
    func displayFetchedMovieList(_ movieList: [Movie]) {
        self.movieList = movieList
        isIncludeAdult = includeAdultSwitch.isOn
    }
}

extension DiscoverSearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayMovieList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(CarouselMovieCollectionViewCell.self, at: indexPath)
        cell.bind(with: displayMovieList[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        delegate?.didTapMovie(movieList[indexPath.row], isAutoplay: false)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
