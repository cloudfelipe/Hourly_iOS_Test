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
    func showImage(with data: Data)
    func showFileDetail(with file: Entry)
    func showErrorMessage()
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
        let viewer = PDFViewerViewController(data: data)
        push(viewer, animated: true)
    }
    
    func showImage(with data: Data) {
        let viewer = ImageViewerViewController(imageData: data)
        present(viewer, animated: true)
    }
    
    func showFileDetail(with file: Entry) {
        let inputDep = FileInformationDetailViewModel.InputDependencies(file: file)
        let viewModel = FileInformationDetailViewModel(dependencies: inputDep)
        let viewController = FileInformationDetailViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            self.router?.pushViewController(viewController, animated: animated)
        }
    }
    
    func pop() {
        DispatchQueue.main.async {
            self.router?.popViewController(animated: true)
        }
    }
    
    func present(_ viewController: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            self.router?.present(viewController, animated: animated, completion: nil)
        }
    }
    
    func showErrorMessage() {
        let alert = UIAlertController(title: "Error", message: "Something went wrong. Please try again later", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .destructive, handler: { [weak self] (_) in
            self?.pop()
        }))
        present(alert, animated: true)
    }
    
    deinit {
        debugPrint("‼️ Child file browser coordinator deinit")
    }
}
