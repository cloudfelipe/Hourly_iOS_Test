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
}

import Networking
import KeychainAccess

class DI {
    private var accessTokenRepository: AccessTokenRepositoryType {
        Keychain(service: "com.felipeco.Hourbox")
    }
    private var tokenProvider: AuthProvider { AuthProvider() }
    private var dropboxClient: DropboxClient { DropboxClient(accessToken: "uQGtRzNwT60AAAAAAAAAAaqSLwcTHK2RSzirh3JqtbNr7RcKoc2iq090L52S0h9Q") }
    private var client: WebClient { WebClient(authProvider: tokenProvider) }
    private var service: FilesServices { FilesServices(baseUrlProvider: URLProvider(), client: client) }
    private var downloadService: DownloadService { DownloadService(client: dropboxClient) }
    private var repo: FilesRepository { FilesRepository(service: service, downloadService: downloadService) }
   
    var getFilesInteractor: GetFilesInteractor { GetFilesInteractor(repository: repo) }
    var downloadFileInteractor: DownloadFileInteractorType { DownloadFileInteractor(repository: repo) }
    var isUserLoggedInInteractor: IsUserLoggedInInteractorType { IsUserLoggedInInteractor(repository: accessTokenRepository) }
    var storeAccessTokenInteractor: StoreAccessTokenInteractorType { StoreAccessTokenInteractor(repository: accessTokenRepository)}
    var removeAccessTokenInteractor: RemoveAccessTokenInteractorType { RemoveAccessTokenInteractor(repository: accessTokenRepository) }
    
    init() {
        
    }
}

final class ApplicationCoordinator: ApplicationCoordinatorType {
    
    weak var router: UINavigationController?
    let accessTokenRoot = PublishSubject<DropboxOAuthResult>()
    let depIn: DI
    
    weak var signinCoordinator: SignInCoordinator?
    
    init(router: UINavigationController) {
        self.router = router
        self.depIn = DI()
    }
    
    
    func start() {
        depIn.removeAccessTokenInteractor.remove()
        let inputDependencies = ApplicationViewModel.InputDependencies(coordinator: self,
                                                                       accessTokenRoot: accessTokenRoot,
                                                                       isUserLoggedInInteractor: depIn.isUserLoggedInInteractor,
                                                                       storeAccessTokenInteractor: depIn.storeAccessTokenInteractor)
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
        newRouter.modalPresentationStyle = .fullScreen
        let coordinator = SignInCoordinator(router: newRouter, dependencies: coordinatorDependencies)
        coordinator.start()
        signinCoordinator = coordinator
        router?.present(newRouter, animated: true, completion: nil)
    }
    
    func goToFileBrowser() {
        let coordinatorDependencies = FileBrowserCoordinator.Dependency(path: .root,
                                                                        getFilesInteractor: self.depIn.getFilesInteractor,
                                                                        down: self.depIn.downloadFileInteractor)
        let newRouter = UINavigationController()
        newRouter.modalPresentationStyle = .fullScreen
        let coordinator = FileBrowserCoordinator(router: newRouter, dependencies: coordinatorDependencies)
        coordinator.start()
        self.router?.present(newRouter, animated: true, completion: nil)
        
    }
    
}
