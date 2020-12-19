//
//  ApplicationCoordinator.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit
import SwiftyDropbox
import RxSwift

protocol ApplicationCoordinatorType {
    func goToSignIn()
    func goToFileBrowser()
    func logout()
}

final class ApplicationCoordinator: ApplicationCoordinatorType {
    
    weak var router: UINavigationController?
    let accessTokenRoot = PublishSubject<DropboxOAuthResult>()
    let dependenciesContainer: DI
    
    weak var signinCoordinator: SignInCoordinator?
    
    init(router: UINavigationController) {
        self.router = router
        self.dependenciesContainer = DI()
    }
    
    
    func start() {
        let inputDependencies = ApplicationViewModel.InputDependencies(coordinator: self,
                                                                       accessTokenRoot: accessTokenRoot,
                                                                       isUserLoggedInInteractor: dependenciesContainer.isUserLoggedInInteractor,
                                                                       storeAccessTokenInteractor: dependenciesContainer.storeAccessTokenInteractor,
                                                                       removeAccessTokenInteractor: dependenciesContainer.removeAccessTokenInteractor)
        let viewModel = ApplicationViewModel(dependencies: inputDependencies)
        let viewController = ApplicationViewController(viewModel: viewModel)
        router?.pushViewController(viewController, animated: false)
    }
    
    func dropboxAccessToken(token: DropboxOAuthResult) {
        accessTokenRoot.onNext(token)
    }
    
    func goToSignIn() {
        let coordinatorDependencies = SignInCoordinatorDependency()
        let newRouter = UINavigationController()
        newRouter.modalTransitionStyle = .crossDissolve
        newRouter.modalPresentationStyle = .fullScreen
        newRouter.isNavigationBarHidden = true
        let coordinator = SignInCoordinator(router: newRouter, dependencies: coordinatorDependencies)
        coordinator.start()
        signinCoordinator = coordinator
        router?.present(newRouter, animated: true, completion: nil)
    }
    
    func goToFileBrowser() {
        let coordinatorDependencies = FileBrowserCoordinator.Dependency(path: .root,
                                                                        getFilesInteractor: dependenciesContainer.getFilesInteractor,
                                                                        down: dependenciesContainer.downloadFileInteractor)
        let newRouter = UINavigationController()
        newRouter.modalTransitionStyle = .crossDissolve
        newRouter.modalPresentationStyle = .fullScreen
        let coordinator = FileBrowserCoordinator(router: newRouter, dependencies: coordinatorDependencies)
        coordinator.start()
        router?.present(newRouter, animated: true, completion: nil)
    }
    
    func logout() {
        self.router?.presentedViewController?.dismiss(animated: true, completion: { self.showLogoutPopup() })
    }
    
    func showLogoutPopup() {
        let alert = UIAlertController(title: "Session expired", message: "Please log in again", defaultActionButtonTitle: "Ok")
        router?.topPresentedViewController.present(alert, animated: true, completion: nil)
    }
}
