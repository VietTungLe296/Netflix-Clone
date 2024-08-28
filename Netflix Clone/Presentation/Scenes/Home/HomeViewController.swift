//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayFetchedMovies(_ movies: [Movie], forSection section: MovieSection)
}

final class HomeViewController: UIViewController {
    var interactor: HomeBusinessLogic?
    var router: HomeRoutingLogic?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var feedTableView: UITableView!
    
    private let sectionCategories = ["Trending Movies".localized, "Trending TV".localized, "Popular".localized, "Upcoming".localized, "Top Rated".localized]
    private var movieCaches = [Int: [Movie]]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchDataOnLoad()
    }
   
    // MARK: Fetch Home

    private func fetchDataOnLoad() {
        // NOTE: Ask the Interactor to do some work
        interactor?.fetchTrendingMovies(type: .day, section: .trendingMovies)
        interactor?.fetchTrendingTvs(type: .day, section: .trendingTvs)
        interactor?.fetchPopularMovies(section: .popular)
        interactor?.fetchUpcomingMovies(section: .upcoming)
        interactor?.fetchTopRatedMovies(section: .topRated)
    }
    
    // MARK: SetupUI

    private func setupView() {
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        let logoButton = UIButton(type: .custom)
        logoButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        logoButton.setImage(UIImage(named: "netflix-logo"), for: .normal)
        let logoItem = UIBarButtonItem(customView: logoButton)
        logoItem.customView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        logoItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        navigationItem.leftBarButtonItem = logoItem
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupTableView() {
        feedTableView.dataSource = self
        feedTableView.delegate = self
        feedTableView.registerCell(MovieCollectionTableViewCell.self)
        feedTableView.tableHeaderView = BannerHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
    }
}

extension HomeViewController: HomeDisplayLogic {
    func displayFetchedMovies(_ movies: [Movie], forSection section: MovieSection) {
        movieCaches[section.rawValue] = movies
        let indexPath = IndexPath(row: 0, section: section.rawValue)
        
        DispatchQueue.main.async { [weak self] in
            self?.feedTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCategories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionCategories[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
        header.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(MovieCollectionTableViewCell.self, at: indexPath)
        cell.selectionStyle = .none
        
        if let movieCaches = movieCaches[indexPath.section] {
            cell.bind(with: movieCaches)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Check the scroll direction
        let offsetY = scrollView.contentOffset.y

        if offsetY > 0 {
            // Scrolling up, hide the navigation bar
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else if offsetY < 0 {
            // Scrolling down, show the navigation bar
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
