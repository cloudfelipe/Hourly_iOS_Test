//
//  FileBrowserViewModel.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

protocol FileBrowserViewModelType: BaseViewModelType {
    func selectedFile(at index: IndexPath)
    
    var filesData: Observable<[FileViewData]> { get }
    var dataRequestState: Observable<DataRequestState> { get }
}

final class FileBrowserViewModel: BaseViewModel, FileBrowserViewModelType {
    
    var filesData: Observable<[FileViewData]> {
        files.map { $0.map { $0.dataView() } }
    }
    
    var dataRequestState: Observable<DataRequestState> {
        return requestState.asObservable()
    }
    
    private let files = BehaviorRelay<[Entry]>(value: [])
    private let requestState = BehaviorRelay<DataRequestState>(value: .normal)
    private let dependencies: InputDependencies
    
    
    init(dependencies: InputDependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func viewAppearStateDidChange(_ state: ViewAppearState) {
        switch state {
        case .didLoad:
            DispatchQueue.global(qos: .background).async {
                self.getData()
            }
        default:
            break
        }
    }
    
    func getData() {
        requestState.accept(.loading)
        dependencies.getFilesInteractor.getFiles(param: dependencies.path) { [weak self] (result) in
            switch result {
            case .success(let files):
                self?.prepareData(files: files)
                self?.requestState.accept(.normal)
            case .failure(let error):
                debugPrint(error)
                self?.requestState.accept(.error)
            }
        }
    }
    
    func prepareData(files: Files) {
        self.files.accept(files.entries)
    }
    
    func selectedFile(at index: IndexPath) {
        let item = files.value[index.row]
        dependencies.coordinator.navigateToDirectory(with: .custom(item.pathLower))
    }
    
    deinit {
        debugPrint("‼️ files presenter deinit")
    }
}

extension FileBrowserViewModel {
    struct InputDependencies {
        let coordinator: FileBrowserCoordinatorType
        let path: FilePath
        let getFilesInteractor: GetFilesInteractorType
    }
}

enum DataRequestState {
    case loading
    case error
    case normal
}

extension Entry {
    func dataView() -> FileViewData {
        return FileViewData(name: name, iconName: tag.iconName)
    }
}
