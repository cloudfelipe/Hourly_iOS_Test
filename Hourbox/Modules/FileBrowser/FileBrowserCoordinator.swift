//
//  FileBrowserCoordinator.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit

protocol FileBrowserCoordinatorDependencyType {
    var path: FilePath { get }
    var getFilesInteractor: GetFilesInteractorType { get }
    var down: DownloadFileInteractorType { get }
}

protocol FileBrowserCoordinatorType {
    func navigateToDirectory(with path: FilePath)
    func showPDF(with data: Data)
}

final class FileBrowserCoordinator: FileBrowserCoordinatorType {
    
    struct Dependency: FileBrowserCoordinatorDependencyType {
        let path: FilePath
        let getFilesInteractor: GetFilesInteractorType
        let down: DownloadFileInteractorType
    }
    
    weak var router: UINavigationController?
    let dependencies: FileBrowserCoordinatorDependencyType
    
    init(router: UINavigationController?, dependencies: FileBrowserCoordinatorDependencyType) {
        self.router = router
        self.dependencies = dependencies
    }
    
    func start() {
        let input = FileBrowserViewModel.InputDependencies(coordinator: self,
                                                    path: dependencies.path,
                                                    getFilesInteractor: dependencies.getFilesInteractor,
                                                    down: dependencies.down)
        let viewModel = FileBrowserViewModel(dependencies: input)
        let viewController = FileBrowserViewController(viewModel: viewModel)
        router?.pushViewController(viewController, animated: true)
    }
    
    func navigateToDirectory(with path: FilePath) {
        let childDependency = Dependency(path: path, getFilesInteractor: dependencies.getFilesInteractor, down: dependencies.down)
        let childCoordinator = FileBrowserCoordinator(router: router, dependencies: childDependency)
        childCoordinator.start()
    }
    
    func showPDF(with data: Data) {
        let viewer = ImageViewerViewController(imageData: data)
        router?.present(viewer, animated: true, completion: nil)
    }
    
    deinit {
        debugPrint("‼️ Child file browser coordinator deinit")
    }
}
