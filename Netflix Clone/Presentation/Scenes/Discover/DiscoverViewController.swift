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
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultBuilder.build())
        controller.searchBar.placeholder = "Type here to begin your search...".localized
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    weak var searchResultUpdater: SearchResultUpdating?
    
    private var debounceWorkItem: DispatchWorkItem?
    
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
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        
        if let resultController = searchController.searchResultsController as? SearchResultUpdating {
            searchResultUpdater = resultController
        }
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

extension DiscoverViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        debounceWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            guard let keyword = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  keyword.count >= 3
            else {
                return
            }
             
            self.searchResultUpdater?.updateSearchResults(with: keyword)
        }

        debounceWorkItem = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: workItem)
    }
}
