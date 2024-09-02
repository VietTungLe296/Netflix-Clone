//
//  PreviewViewController.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 2/9/24.
//

import UIKit
import WebKit

protocol PreviewDisplayLogic: AnyObject {}

final class PreviewViewController: UIViewController {
    var interactor: PreviewBusinessLogic?

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var downloadButton: ActionButtonView!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchDataOnLoad()
    }

    // MARK: Fetch Preview

    private func fetchDataOnLoad() {}

    // MARK: SetupUI

    private func setupView() {
        setupWebView()
        setupLabels()
    }

    private func setupWebView() {
        guard let url = interactor?.getTrailerUrl() else { return }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        webView.load(request)
    }

    private func setupLabels() {
        titleLabel.text = interactor?.getMovieTitle()
        overviewLabel.text = interactor?.getMovieOverview()
    }
}

extension PreviewViewController: PreviewDisplayLogic {}
