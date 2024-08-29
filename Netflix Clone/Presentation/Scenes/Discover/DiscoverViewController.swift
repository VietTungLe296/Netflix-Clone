//
//  DiscoverViewController.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 30/8/24.
//

import UIKit

protocol DiscoverDisplayLogic: AnyObject {
    func displayFetchedMovieList(_ movieList: [Movie])
}

final class DiscoverViewController: UIViewController {
    var interactor: DiscoverBusinessLogic?
    var router: DiscoverRoutingLogic?
    
    @IBOutlet weak var discoverTableView: UITableView!
    
    private var movieList = [Movie]()

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchDataOnLoad()
    }
   
    // MARK: Fetch Search

    private func fetchDataOnLoad() {
        interactor?.fetchDiscoverMovies(includeVideos: false, includeAdult: true, sortType: .popularityDesc)
    }
    
    // MARK: SetupUI

    private func setupView() {
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = "Discover".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupTableView() {
        discoverTableView.dataSource = self
        discoverTableView.delegate = self
        discoverTableView.registerCell(MovieTitleTableViewCell.self)
    }
}

extension DiscoverViewController: DiscoverDisplayLogic {
    func displayFetchedMovieList(_ movieList: [Movie]) {
        self.movieList = movieList
        
        DispatchQueue.main.async { [weak self] in
            self?.discoverTableView.reloadData()
        }
    }
}

extension DiscoverViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(MovieTitleTableViewCell.self, at: indexPath)
        cell.bind(with: movieList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
