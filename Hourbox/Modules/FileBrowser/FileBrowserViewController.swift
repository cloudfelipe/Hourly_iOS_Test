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
import SVProgressHUD

final class FileBrowserViewController<T: FileBrowserViewModelType>: BaseViewController<T>, CollectionViewAdapterDelegate {
    
    override init(viewModel: T) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var collectionAdapter: FileBrowserCollectionAdapter!
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellWithClass: FileCollectionViewCell.self)
        collectionView.register(cellWithClass: SkeletonCell.self)
        collectionView.backgroundColor = .white
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    lazy var logoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: Texts.General.logout, style: .done, target: nil, action: nil)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        
        collectionAdapter = FileBrowserCollectionAdapter(collectionView: collectionView)
        collectionAdapter.delegate = self
        
        navigationItem.rightBarButtonItem = logoutButton
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        setupBinding()
    }
    
    func setupBinding() {
        viewModel.filesData
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.setItems($0) })
            .disposed(by: disposeBag)
        
        viewModel.folderPath
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.title = $0 })
            .disposed(by: disposeBag)
        
        viewModel.dataRequestState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.requestState($0) })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] in self?.viewModel.selectedFile(at: $0) })
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .subscribe(onNext: { [weak viewModel] in
                viewModel?.performLogout()
            })
            .disposed(by: disposeBag)
    }
    
    func complementaryViewTapped(at indexPath: IndexPath) {
        viewModel.fileInformation(for: indexPath)
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
    }
}
