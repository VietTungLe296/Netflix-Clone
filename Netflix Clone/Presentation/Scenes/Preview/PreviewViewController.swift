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

    var isAutoplay = false

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
        if isAutoplay {
            let embedHTML = """
            <html>
            <body style="margin: 0px; padding: 0px;">
            <iframe width="100%" height="100%" src="https://youtube.com/embed/x0XDEhP4MQs?autoplay=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
            </body>
            </html>
            """
            
            webView.loadHTMLString(embedHTML, baseURL: nil)
        } else {
            guard let url = interactor?.getTrailerUrl() else { return }
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            webView.load(request)
        }
    }

    private func setupLabels() {
        titleLabel.text = interactor?.getMovieTitle()
        overviewLabel.text = interactor?.getMovieOverview()
    }
}

extension PreviewViewController: PreviewDisplayLogic {}
