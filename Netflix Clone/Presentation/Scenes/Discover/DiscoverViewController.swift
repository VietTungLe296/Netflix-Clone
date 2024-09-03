//
//  DiscoverViewController.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

protocol DiscoverDisplayLogic: AnyObject {
    func displayFetchedMovieList(_ movieList: [Movie], totalPages: Int)
    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool)
}

final class DiscoverViewController: UIViewController {
    var interactor: DiscoverBusinessLogic?
    var router: DiscoverRoutingLogic?
    
    @IBOutlet weak var discoverTableView: UITableView!
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: DiscoverSearchResultBuilder.build())
        controller.searchBar.placeholder = "Type here to begin your search...".localized
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private var debounceWorkItem: DispatchWorkItem?
    
    private var movieList = [Movie]()

    private var currentPage = 1
    private var totalPages = 1
    private var isFetchingMore = false
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchDataOnLoad()
    }
   
    // MARK: Fetch Search

    private func fetchDataOnLoad() {
        interactor?.fetchDiscoverMovies(page: currentPage, includeVideos: false, includeAdult: true, sortType: .popularityDesc)
    }
    
    // MARK: SetupUI

    private func setupView() {
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = "Discover".localized
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        
        if let resultController = searchController.searchResultsController as? DiscoverSearchResultViewController {
            resultController.delegate = self
        }
    }
    
    private func setupTableView() {
        discoverTableView.dataSource = self
        discoverTableView.delegate = self
        discoverTableView.registerCell(MovieTitleTableViewCell.self)
    }
    
    private func fetchMovies(page: Int) {
        if isFetchingMore || movieList.count > 50 {
            return
        }
        
        isFetchingMore = true
        interactor?.fetchDiscoverMovies(page: page, includeVideos: false, includeAdult: true, sortType: .popularityDesc)
    }
}

extension DiscoverViewController: DiscoverDisplayLogic {
    func displayFetchedMovieList(_ movieList: [Movie], totalPages: Int) {
        self.movieList.append(contentsOf: movieList)
        self.totalPages = totalPages
        isFetchingMore = false
         
        DispatchQueue.main.async { [weak self] in
            self?.discoverTableView.reloadData()
        }
    }
    
    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool) {
        router?.goToPreviewScreen(of: movie, with: videoId, isAutoplay: isAutoplay)
    }
}

extension DiscoverViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(MovieTitleTableViewCell.self, at: indexPath)
        cell.bind(with: movieList[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        interactor?.fetchYoutubeTrailer(for: movieList[indexPath.row], isAutoplay: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let movie = movieList[indexPath.row]
        
        let config = UIContextMenuConfiguration(actionProvider: { _ in
            let downloadAction = UIAction(title: "Download".localized,
                                          image: UIImage(systemName: "arrow.down.circle.fill"))
            { [weak self] _ in
                self?.interactor?.downloadMovie(movie)
            }
            
            return UIMenu(options: [.displayInline], children: [downloadAction])
        })
        
        return config
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
            
        if offsetY > contentHeight - height - 100 && !isFetchingMore && currentPage < totalPages {
            currentPage += 1
            fetchMovies(page: currentPage)
        }
    }
}

extension DiscoverViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        debounceWorkItem?.cancel()

        let workItem = DispatchWorkItem {
            guard let keyword = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  keyword.count >= 3
            else {
                return
            }
            
            NotificationCenter.default.post(name: .updateDiscoverSearchKeyword, object: nil, userInfo: ["keyword": keyword])
        }

        debounceWorkItem = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: workItem)
    }
}

extension DiscoverViewController: MovieTitleTableViewCellDelegate, DiscoverSearchResultDelegate {
    func didTapMovie(_ movie: Movie, isAutoplay: Bool) {
        interactor?.fetchYoutubeTrailer(for: movie, isAutoplay: isAutoplay)
    }
    
    func didDownloadMovie(_ movie: Movie) {
        interactor?.downloadMovie(movie)
    }
}
