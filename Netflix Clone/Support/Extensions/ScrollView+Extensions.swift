//
//  ScrollView+Extensions.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 10/08/2024.
//

import UIKit

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(_ anyClass: T.Type, at indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: anyClass), for: indexPath) as? T
        return cell ?? T()
    }
    
    func registerCell<T: UICollectionViewCell>(_ anyClass: T.Type, nibType: Bool = true) {
        return nibType
            ? register(UINib(nibName: String(describing: anyClass), bundle: nil),
                       forCellWithReuseIdentifier: String(describing: anyClass))
            : register(anyClass, forCellWithReuseIdentifier: String(describing: anyClass))
    }
    
    func registerHeaderFooter<T: UICollectionReusableView>(_ anyClass: T.Type, kind: String, nibType: Bool = true) {
        return nibType
            ? register(UINib(nibName: String(describing: anyClass), bundle: nil),
                       forSupplementaryViewOfKind: kind,
                       withReuseIdentifier: String(describing: anyClass))
            : register(anyClass,
                       forSupplementaryViewOfKind: kind,
                       withReuseIdentifier: String(describing: anyClass))
    }

    func currentCenteredItemIndex() -> IndexPath? {
        let visibleRect = CGRect(origin: self.contentOffset, size: self.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            
        if let indexPath = indexPathForItem(at: visiblePoint) {
            return indexPath
        }
            
        return nil
    }
}

extension UITableView {
    func dequeueCell<T: UITableViewCell>(_ anyClass: T.Type, at indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: String(describing: anyClass), for: indexPath) as? T
        return cell ?? T()
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ anyClass: T.Type) -> T {
        let view = dequeueReusableHeaderFooterView(withIdentifier: String(describing: anyClass)) as? T
        return view ?? T()
    }
    
    func registerCell<T: UITableViewCell>(_ anyClass: T.Type, nibType: Bool = true) {
        return nibType
            ? register(UINib(nibName: String(describing: anyClass), bundle: nil),
                       forCellReuseIdentifier: String(describing: anyClass))
            : register(anyClass, forCellReuseIdentifier: String(describing: anyClass))
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ anyClass: T.Type, nibType: Bool = true) {
        return nibType
            ? register(UINib(nibName: String(describing: anyClass), bundle: nil),
                       forHeaderFooterViewReuseIdentifier: String(describing: anyClass))
            : register(anyClass, forHeaderFooterViewReuseIdentifier: String(describing: anyClass))
    }
}
