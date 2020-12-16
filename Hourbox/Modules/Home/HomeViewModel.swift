//
//  HomeViewModel.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

protocol HomeViewModelType {
    func getData()
    func selectedFile(at index: IndexPath)
}

final class HomeViewModel: HomeViewModelType {
    let dependencies: InputDependencies
    weak var view: HomeViewType?
    
    init(dependencies: InputDependencies) {
        self.dependencies = dependencies
    }
    
    func bind(view: HomeViewType) {
        self.view = view
    }
    
    func getData() {
        DispatchQueue.global(qos: .background).async {
            self.dependencies.getFilesInteractor.getFiles { [weak self] (result) in
                switch result {
                case .success(let files):
                    self?.prepareData(files: files)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    func prepareData(files: Files) {
        self.view?.setFilesData(with: files.entries.map { $0.dataView() })
    }
    
    func selectedFile(at index: IndexPath) {
        
    }
}

extension HomeViewModel {
    struct InputDependencies {
        let getFilesInteractor: GetHomeFilesInteractorType
    }
}

extension Entry {
    func dataView() -> FileViewData {
        return FileViewData(name: name, iconName: tag.iconName)
    }
}
