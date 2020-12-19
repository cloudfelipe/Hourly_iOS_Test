//
//  FileBrowserViewController.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import SVProgressHUD

struct FileViewData {
    let name: String
    let iconName: String
}

protocol HomeViewType: AnyObject {
}

final class FileBrowserViewController<T: FileBrowserViewModelType>: BaseViewController<T>, CollectionViewAdapterDelegate {
    
    override init(viewModel: T) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var collectionAdapter: CollectionViewAdapter!
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: "FileCollectionViewCell")
        collectionView.register(SkeletonCell.self, forCellWithReuseIdentifier: "SkeletonCell")
        collectionView.backgroundColor = .white
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        
        collectionAdapter = CollectionViewAdapter(collectionView: collectionView)
        collectionAdapter.delegate = self
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
                
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
//        viewModel.filesData
//            .observeOn(MainScheduler.instance)
//            .bind(to: collectionView.rx.items(cellIdentifier: "FileCollectionViewCell", cellType: FileCollectionViewCell.self)) { index,item,cell in
//                cell.setup(with: item, moreInfoAction: {})
//
//        }.disposed(by: disposableBag)
        
        viewModel.filesData
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.setItems($0) })
            .disposed(by: disposableBag)
        
        viewModel.folderPath
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.title = $0 })
            .disposed(by: disposableBag)
        
        viewModel.dataRequestState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.requestState($0) })
            .disposed(by: disposableBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] in self?.viewModel.selectedFile(at: $0) }).disposed(by: disposableBag)
    }
    
    func complementaryViewTapped(at indexPath: IndexPath) {
        let optionsSheet = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
        ExtraOptions.allCases.forEach { option in
            optionsSheet.addAction(title: option.name, style: .default, handler: { [weak self] action in
                self?.viewModel.extraOptionsTapped(option, for: indexPath)
            })
        }
        optionsSheet.addAction(title: "Cancel", style: .destructive, handler: nil)
        self.present(optionsSheet, animated: true, completion: nil)
    }
    
    func requestState(_ requestState: DataRequestState) {
        DispatchQueue.main.async {
            switch requestState {
            case .loading:
                self.collectionAdapter.loading()
            case .error:
                self.collectionAdapter.hideLoading()
                SVProgressHUD.dismiss()
            case .normal:
                self.collectionAdapter.hideLoading()
            case .downloading:
                SVProgressHUD.show()
            case .downloadedFile:
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func setItems(_ items: [FileViewData]) {
        collectionAdapter.setItems(items)
//        collectionView.reloadData()
    }
    
    deinit {
        debugPrint("‼️ files VC deinit")
    }
}

extension FileBrowserViewController: HomeViewType {
}

import SkeletonView

protocol CollectionViewAdapterDelegate: AnyObject {
    func complementaryViewTapped(at indexPath: IndexPath)
}

final class CollectionViewAdapter: NSObject, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource, DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "This folder is empty",
                                  attributes: [.font : UIFont.boldSystemFont(ofSize: 20.0),
                                               .foregroundColor: UIColor.black])
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Your files stored on Dropbox will appear here",
                                  attributes: [.font : UIFont.systemFont(ofSize: 18.0),
                                               .foregroundColor: UIColor.black])
    }
    
    var items = [FileViewData]()
    weak var collectionView: UICollectionView?
    weak var delegate: CollectionViewAdapterDelegate?
    
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
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        "SkeletonCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCollectionViewCell", for: indexPath) as! FileCollectionViewCell
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
}
