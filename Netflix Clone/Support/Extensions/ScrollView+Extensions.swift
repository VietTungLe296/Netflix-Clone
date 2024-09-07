//
//  ScrollView+Extensions.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import UIKit

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(_ anyClass: T.Type, at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: anyClass), for: indexPath) as? T else {
            fatalError("Unable to dequeue \(T.self) with identifier: \(String(describing: anyClass))")
        }
        return cell
    }

    func registerCell<T: UICollectionViewCell>(_ anyClass: T.Type, usingNib: Bool = true) {
        let identifier = String(describing: anyClass)
        usingNib
            ? register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
            : register(anyClass, forCellWithReuseIdentifier: identifier)
    }

    func registerHeaderFooter<T: UICollectionReusableView>(_ anyClass: T.Type, kind: String, usingNib: Bool = true) {
        let identifier = String(describing: anyClass)
        usingNib
            ? register(UINib(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
            : register(anyClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }

    func currentCenteredItemIndex() -> IndexPath? {
        let visiblePoint = CGPoint(x: bounds.midX + contentOffset.x, y: bounds.midY + contentOffset.y)
        return indexPathForItem(at: visiblePoint)
    }
}

extension UITableView {
    func dequeueCell<T: UITableViewCell>(_ anyClass: T.Type, at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: anyClass), for: indexPath) as? T else {
            fatalError("Unable to dequeue \(T.self) with identifier: \(String(describing: anyClass))")
        }
        return cell
    }

    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ anyClass: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: String(describing: anyClass)) as? T else {
            fatalError("Unable to dequeue \(T.self) with identifier: \(String(describing: anyClass))")
        }
        return view
    }

    func registerCell<T: UITableViewCell>(_ anyClass: T.Type, usingNib: Bool = true) {
        let identifier = String(describing: anyClass)
        usingNib
            ? register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            : register(anyClass, forCellReuseIdentifier: identifier)
    }

    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ anyClass: T.Type, usingNib: Bool = true) {
        let identifier = String(describing: anyClass)
        usingNib
            ? register(UINib(nibName: identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
            : register(anyClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
