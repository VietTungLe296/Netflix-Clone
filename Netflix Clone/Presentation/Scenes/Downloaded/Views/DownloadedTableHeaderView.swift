//
//  DownloadedTableHeaderView.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 3/9/24.
//

import UIKit

protocol DownloadedTableHeaderViewDelegate: AnyObject {
    func didChangeSortType(_ sortType: SortType)
}

final class DownloadedTableHeaderView: UIView {
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var sortIconImageView: UIImageView!

    weak var delegate: DownloadedTableHeaderViewDelegate?

    private var sortType: SortType = .nameAscending

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        _ = fromNib()

        sortLabel.text = "Sort".localized
        sortIconImageView.image = UIImage(named: "a-z")?.withRenderingMode(.alwaysTemplate)
    }

    @IBAction func didTapSort(_ sender: Any) {
        if sortType == .nameAscending {
            sortIconImageView.image = UIImage(named: "z-a")?.withRenderingMode(.alwaysTemplate)
            sortType = .nameDescending
        } else {
            sortIconImageView.image = UIImage(named: "a-z")?.withRenderingMode(.alwaysTemplate)
            sortType = .nameAscending
        }

        delegate?.didChangeSortType(sortType)
    }
}
