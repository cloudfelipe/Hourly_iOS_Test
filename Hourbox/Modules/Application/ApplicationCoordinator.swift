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
    
    private let accessTokenRoot = PublishSubject<DropboxOAuthResult>()
    private let dependenciesContainer: DependencyInversionType
    
    private weak var router: UINavigationController?
    private weak var signinCoordinator: SignInCoordinator?
    
    init(router: UINavigationController, di: DependencyInversionType) {
        self.router = router
        self.dependenciesContainer = di
    }
    
    func start() {
        let inputDependencies = ApplicationViewModel.InputDependencies(coordinator: self,
                                                                       accessTokenRoot: accessTokenRoot,
                                                                       isUserLoggedInInteractor: dependenciesContainer.isUserLoggedInInteractor,
                                                                       storeAccessTokenInteractor: dependenciesContainer.storeAccessTokenInteractor,
                                                                       removeAccessTokenInteractor: dependenciesContainer.removeAccessTokenInteractor)
        let viewModel = ApplicationViewModel(dependencies: inputDependencies)
        let viewController = ApplicationViewController(viewModel: viewModel)
        router?.isNavigationBarHidden = true
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
                                                                        downloadFileInteractor: dependenciesContainer.downloadFileInteractor,
                                                                        getThumbnailInteractor: dependenciesContainer.getThumbnailInteractor,
                                                                        logoutInteractor: dependenciesContainer.logoutInteractor)
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
        let alert = UIAlertController(title: Texts.Logout.title,
                                      message: Texts.Logout.message,
                                      defaultActionButtonTitle: Texts.General.ok)
        router?.topPresentedViewController.present(alert, animated: true, completion: nil)
    }
}
