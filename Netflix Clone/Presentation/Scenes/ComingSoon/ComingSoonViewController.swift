//
//  ComingSoonViewController.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 28/8/24.
//

import UIKit

protocol ComingSoonDisplayLogic: AnyObject {
    func displayFetchedMovieList(_ movieList: [Movie])
}

final class ComingSoonViewController: UIViewController {
    var interactor: ComingSoonBusinessLogic?
    var router: ComingSoonRoutingLogic?
    
    @IBOutlet weak var upcomingTableView: UITableView!
    
    private var movieList = [Movie]()

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchDataOnLoad()
    }
   
    // MARK: Fetch ComingSoon

    private func fetchDataOnLoad() {
        interactor?.fetchUpcomingMovieList()
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
    }
    
    private func setupTableView() {
        upcomingTableView.dataSource = self
        upcomingTableView.delegate = self
        upcomingTableView.registerCell(UpcomingMovieTableViewCell.self)
    }
}

extension ComingSoonViewController: ComingSoonDisplayLogic {
    func displayFetchedMovieList(_ movieList: [Movie]) {
        self.movieList = movieList
        upcomingTableView.reloadData()
    }
}

extension ComingSoonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UpcomingMovieTableViewCell.self, at: indexPath)
        cell.bind(with: movieList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
