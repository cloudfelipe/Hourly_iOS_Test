//
//  SignInCoordinator.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit
import SwiftyDropbox

protocol SignInCoordinatorType {
    func openDropBoxSignIn()
    func dismiss()
}

protocol SignInCoordinatorDependencyType {
    
}
struct SignInCoordinatorDependency: SignInCoordinatorDependencyType {
    
}

final class SignInCoordinator: SignInCoordinatorType {
    
    weak var router: UINavigationController?
    let dependencies: SignInCoordinatorDependencyType
    
    init(router: UINavigationController, dependencies: SignInCoordinatorDependencyType) {
        self.router = router
        self.dependencies = dependencies
    }
    
    func start() {
        let input = SignInViewModel.InputDependencies(coordinator: self, isUserLoggedIn: DI().isUserLoggedInInteractor)
        let viewModel = SignInViewModel(dependencies: input)
        let viewController = SignInViewController(viewModel: viewModel)
        router?.pushViewController(viewController, animated: true)
    }
    
    func openDropBoxSignIn() {
        let scopeRequest = ScopeRequest(scopeType: .user,
                                        scopes: ["account_info.read",
                                                 "files.metadata.read",
                                                 "files.content.read"],
                                        includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: router?.viewControllers.first,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in
                UIApplication.shared.open(url)
            },
            scopeRequest: scopeRequest
        )
    }
    
    
    
    func dismiss() {
        router?.dismiss(animated: true, completion: nil)
    }
}
