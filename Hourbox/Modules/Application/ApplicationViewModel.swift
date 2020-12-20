//
//  ApplicationViewModel.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation
import SwiftyDropbox
import RxSwift

protocol ApplicationViewModelType: BaseViewModelType { }

final class ApplicationViewModel: BaseViewModel, ApplicationViewModelType {
    struct InputDependencies {
        let coordinator: ApplicationCoordinatorType
        let accessTokenRoot: PublishSubject<DropboxOAuthResult>
        let isUserLoggedInInteractor: IsUserLoggedInInteractorType
        let storeAccessTokenInteractor: StoreAccessTokenInteractorType
        let removeAccessTokenInteractor: RemoveAccessTokenInteractorType
    }
    
    private let dependencies: InputDependencies
    
    init(dependencies: InputDependencies) {
        self.dependencies = dependencies
        super.init()
        
        dependencies.accessTokenRoot
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: processIncomingAuthResult(_:))
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(.logout)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: logout(_:))
            .disposed(by: disposeBag)
    }
    
    @objc func logout(_ notification: Notification) {
        dependencies.removeAccessTokenInteractor.remove()
        dependencies.coordinator.logout()
    }
    
    override func viewAppearStateDidChange(_ state: ViewAppearState) {
        switch state {
        case .didAppear:
            self.grantAccess()
        default:
            break
        }
    }
    
    private func processIncomingAuthResult(_ authResult: DropboxOAuthResult) {
        switch authResult {
        case .success(let token):
            dependencies.storeAccessTokenInteractor.store(token: token.accessToken)
        default:
            break
        }
    }
    
    private func grantAccess() {
        if dependencies.isUserLoggedInInteractor.isLoggedIn() {
            dependencies.coordinator.goToFileBrowser()
        } else {
            dependencies.coordinator.goToSignIn()
        }
    }
}
