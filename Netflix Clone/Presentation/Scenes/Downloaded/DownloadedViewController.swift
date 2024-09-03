//
//  DownloadedViewController.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 3/9/24.
//

import UIKit

protocol DownloadedDisplayLogic: AnyObject {
    func displayFetchedMovieList(_ movieList: [Movie])
    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool)
}

final class DownloadedViewController: UIViewController {
    var interactor: DownloadedBusinessLogic?
    var router: DownloadedRoutingLogic?

    @IBOutlet weak var downloadedTableView: UITableView!
    
    private var movieList = [Movie]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchDataOnLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    // MARK: Fetch Upcoming

    @objc private func fetchDataOnLoad() {
        interactor?.fetchDownloadedMovie()
    }
    
    // MARK: SetupUI
    
    private func setupView() {
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = "Downloaded".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupTableView() {
        downloadedTableView.dataSource = self
        downloadedTableView.delegate = self
        downloadedTableView.registerCell(MovieTitleTableViewCell.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDataOnLoad), name: .updateDownloadedMovieTab, object: nil)
    }
}

extension DownloadedViewController: DownloadedDisplayLogic {
    func displayFetchedMovieList(_ movieList: [Movie]) {
        self.movieList = movieList
        
        DispatchQueue.main.async { [weak self] in
            self?.downloadedTableView.reloadData()
        }
    }
    
    func goToPreviewScreen(of movie: Movie, with videoId: YoutubeVideoId, isAutoplay: Bool) {
        router?.goToPreviewScreen(of: movie, with: videoId, isAutoplay: isAutoplay)
    }
}

extension DownloadedViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            interactor?.deleteMovie(movieList[indexPath.row]) { [weak self] in
                DispatchQueue.main.async {
                    self?.movieList.remove(at: indexPath.row)
                    self?.downloadedTableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        default:
            break
        }
    }
}

extension DownloadedViewController: MovieTitleTableViewCellDelegate {
    func didTapMovie(_ movie: Movie, isAutoplay: Bool) {
        interactor?.fetchYoutubeTrailer(for: movie, isAutoplay: isAutoplay)
    }
}
