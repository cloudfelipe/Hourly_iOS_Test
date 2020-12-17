//
//  SignInViewModel.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignInViewModelType: BaseViewModelType {
    func binding(startSignIn: Driver<Void>)
}

final class SignInViewModel: BaseViewModel, SignInViewModelType {
    
    private let dependencies: InputDependencies
    
    init(dependencies: InputDependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    func binding(startSignIn: Driver<Void>) {
        startSignIn
            .drive(onNext: {[weak self] in
                self?.start()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewAppearStateDidChange(_ state: ViewAppearState) {
        switch state {
        case .didAppear:
            checkUserState()
        default:
            break
        }
    }
    
    func checkUserState() {
        if dependencies.isUserLoggedIn.isLoggedIn() {
            dependencies.coordinator.dismiss()
        }
    }
    
    func start() {
        dependencies.coordinator.openDropBoxSignIn()
    }
}

extension SignInViewModel {
    struct InputDependencies {
        let coordinator: SignInCoordinatorType
        let isUserLoggedIn: IsUserLoggedInInteractorType
    }
}
