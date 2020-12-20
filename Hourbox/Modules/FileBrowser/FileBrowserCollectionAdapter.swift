//
//  FileBrowserCollectionAdapter.swift
//  Hourbox
//
//  Created by Felipe Correa on 19/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation
import SkeletonView
import DZNEmptyDataSet

protocol CollectionViewAdapterDelegate: AnyObject {
    func complementaryViewTapped(at indexPath: IndexPath)
}

final class FileBrowserCollectionAdapter: NSObject, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource, DZNEmptyDataSetSource {
    
    weak var delegate: CollectionViewAdapterDelegate?
    private(set) var items = [FileViewData]()
    private(set) weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        self.collectionView?.dataSource = self
        self.collectionView?.emptyDataSetSource = self
        self.collectionView?.delegate = self
    }
    
    func setItems(_ items: [FileViewData]) {
        self.items = items
        reload()
    }
    
    func loading() {
        DispatchQueue.main.async {
            self.collectionView?.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.collectionView?.hideSkeleton()
        }
    }
    
    func reload() {
        UIView.transition(with: self.collectionView!,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.collectionView!.reloadData()
        })
    }
    
    // MARK: - SkeletonCollectionViewDataSource
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        String(describing: SkeletonCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FileCollectionViewCell.self, for: indexPath)
        cell.setup(with: items[indexPath.row], moreInfoAction: { [weak delegate] in delegate?.complementaryViewTapped(at: indexPath)})
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 20, height: collectionView.frame.height / 5 - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    // MARK: - DZNEmptyDataSetSource
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "empty")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: Texts.EmptyState.title,
                                  attributes: [.font : UIFont.boldSystemFont(ofSize: 20.0),
                                               .foregroundColor: UIColor.black])
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: Texts.EmptyState.description,
                                  attributes: [.font : UIFont.systemFont(ofSize: 18.0),
                                               .foregroundColor: UIColor.black])
    }
}
