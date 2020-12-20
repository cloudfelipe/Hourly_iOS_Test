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
    var userPermissions: [String] { get }
}

struct SignInCoordinatorDependency: SignInCoordinatorDependencyType {
    var userPermissions: [String] = ["account_info.read",
                                     "files.metadata.read",
                                     "files.content.read"]
}

final class SignInCoordinator: SignInCoordinatorType {
    
    private weak var router: UINavigationController?
    private let dependencies: SignInCoordinatorDependencyType
    
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
                                        scopes: dependencies.userPermissions,
                                        includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: router?.viewControllers.first,
            loadingStatusDelegate: nil,
            openURL: {_ in},
            scopeRequest: scopeRequest
        )
    }

    func dismiss() {
        router?.dismiss(animated: true, completion: nil)
    }
}
