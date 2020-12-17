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
    
    private var collectionAdapter = CollectionViewAdapter()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: "FileCollectionViewCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
        viewModel.filesData
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: "FileCollectionViewCell", cellType: FileCollectionViewCell.self)) { index,item,cell in
            cell.setup(with: item)
        }.disposed(by: disposableBag)
        
        viewModel.folderPath
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                self.title = $0
            }).disposed(by: disposableBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: { self.viewModel.selectedFile(at: $0) }).disposed(by: disposableBag)
                
        collectionView.rx.setDelegate(collectionAdapter).disposed(by: disposableBag)
    }
    
    deinit {
        debugPrint("‼️ files VC deinit")
    }
}

extension FileBrowserViewController: HomeViewType {
}

final class CollectionViewAdapter: NSObject, UICollectionViewDelegateFlowLayout {
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
