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
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDataOnLoad), name: .updateDownloadedMovieTab, object: nil)
    }
    
    private func setupNavigationBar() {
        title = "Downloaded".localized
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupTableView() {
        downloadedTableView.dataSource = self
        downloadedTableView.delegate = self
        downloadedTableView.registerCell(MovieTitleTableViewCell.self)
        
        let headerView = DownloadedTableHeaderView(frame: .init(x: 0, y: 0, width: downloadedTableView.bounds.width, height: 25))
        headerView.delegate = self
        downloadedTableView.tableHeaderView = headerView
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
        let destinationVC = PreviewBuilder.build(with: .init(movie: movie, videoId: videoId, isAutoplay: isAutoplay))
        push(to: destinationVC)
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

extension DownloadedViewController: MovieTitleTableViewCellDelegate, DownloadedTableHeaderViewDelegate {
    func didTapMovie(_ movie: Movie, isAutoplay: Bool) {
        interactor?.fetchYoutubeTrailer(for: movie, isAutoplay: isAutoplay)
    }
    
    func didChangeSortType(_ sortType: SortType) {
        interactor?.updateSortType(sortType)
        
        switch sortType {
        case .nameAscending:
            CommonViewPresenter.shared.showBottomAlert(type: .info, message: String(format: "Sort by %@".localized, "A-Z"))
            movieList.sort(by: { $0.displayTitle < $1.displayTitle })
        case .nameDescending:
            CommonViewPresenter.shared.showBottomAlert(type: .info, message: String(format: "Sort by %@".localized, "Z-A"))
            movieList.sort(by: { $0.displayTitle > $1.displayTitle })
        }
       
        DispatchQueue.main.async { [weak self] in
            self?.downloadedTableView.reloadData()
        }
    }
}
