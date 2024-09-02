//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import UIKit

protocol UpcomingDisplayLogic: AnyObject {
    func displayFetchedMovieList(_ movieList: [Movie], totalPages: Int)
    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool)
}

final class UpcomingViewController: UIViewController {
    var interactor: UpcomingBusinessLogic?
    var router: UpcomingRoutingLogic?
    
    @IBOutlet weak var upcomingTableView: UITableView!
    
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
   
    // MARK: Fetch Upcoming

    private func fetchDataOnLoad() {
        interactor?.fetchUpcomingMovieList(page: currentPage)
    }
    
    // MARK: SetupUI
    
    private func setupView() {
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = "Upcoming".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupTableView() {
        upcomingTableView.dataSource = self
        upcomingTableView.delegate = self
        upcomingTableView.registerCell(MovieTitleTableViewCell.self)
    }
    
    private func fetchMovies(page: Int) {
        if isFetchingMore || movieList.count > 30 {
            return
        }
        
        isFetchingMore = true
        interactor?.fetchUpcomingMovieList(page: page)
    }
}

extension UpcomingViewController: UpcomingDisplayLogic {
    func displayFetchedMovieList(_ movieList: [Movie], totalPages: Int) {
        self.movieList.append(contentsOf: movieList)
        self.totalPages = totalPages
        isFetchingMore = false
        
        DispatchQueue.main.async { [weak self] in
            self?.upcomingTableView.reloadData()
        }
    }
    
    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool) {
        router?.goToPreviewScreen(of: movie, with: videoId, isAutoPlay: isAutoplay)
    }
}

extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(MovieTitleTableViewCell.self, at: indexPath)
        cell.bind(with: movieList[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        interactor?.fetchYoutubeTrailer(for: movieList[indexPath.row], isAutoplay: false)
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

extension UpcomingViewController: MovieTitleTableViewCellDelegate {
    func didTapMovie(_ movie: Movie, isAutoplay: Bool) {
        interactor?.fetchYoutubeTrailer(for: movie, isAutoplay: isAutoplay)
    }
}
