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

struct FileViewData {
    let name: String
    let iconName: String
}

protocol HomeViewType: AnyObject {
}

final class FileBrowserViewController<T: FileBrowserViewModelType>: BaseViewController<T> {
    
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
        
        collectionAdapter = CollectionViewAdapter(collection: collectionView)
        
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
//            cell.setup(with: item)
//
//        }.disposed(by: disposableBag)
        
        viewModel.filesData
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: setItems(_:))
            .disposed(by: disposableBag)
        
        viewModel.folderPath
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                self.title = $0
            }).disposed(by: disposableBag)
        
        viewModel.dataRequestState
            .observeOn(MainScheduler.instance)
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: requestState(_:))
            .disposed(by: disposableBag)
        
        
        collectionView.dataSource = collectionAdapter
        collectionView.delegate = collectionAdapter
        
        collectionView.rx.itemSelected.subscribe(onNext: { self.viewModel.selectedFile(at: $0) }).disposed(by: disposableBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        collectionView.showAnimatedGradientSkeleton()
    }
    
    func requestState(_ requestState: DataRequestState) {
        switch requestState {
        case .loading:
            collectionAdapter.loading()
        case .error:
            break
        case .normal:
            collectionAdapter.hideLoading()
            break
        }
    }
    
    func setItems(_ items: [FileViewData]) {
        collectionAdapter.setItems(items)
        collectionView.reloadData()
    }
    
    deinit {
        debugPrint("‼️ files VC deinit")
    }
}

extension FileBrowserViewController: HomeViewType {
}

import SkeletonView

final class CollectionViewAdapter: NSObject, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource {
    
    var items = [FileViewData]()
    weak var collectionView: UICollectionView?
    
    init(collection: UICollectionView) {
        self.collectionView = collection
        super.init()
    }
    
    func setItems(_ items: [FileViewData]) {
        self.items = items
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func loading() {
        DispatchQueue.main.async {
            self.collectionView?.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
//            self.collectionView?.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            self.collectionView?.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        "SkeletonCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
//        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCollectionViewCell", for: indexPath) as! FileCollectionViewCell
        cell.setup(with: items[indexPath.row])
//        cell.setup(with: FileViewData(name: "sample", iconName: "folder"))
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
