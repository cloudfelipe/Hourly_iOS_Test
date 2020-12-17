//
//  RemoveAccessTokenInteractor.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

protocol RemoveAccessTokenInteractorType {
    func remove()
}

final class RemoveAccessTokenInteractor: RemoveAccessTokenInteractorType {
    let repository: AccessTokenRepositoryType
    
    init(repository: AccessTokenRepositoryType) {
        self.repository = repository
    }
    
    func remove() {
        repository.removeToken()
    }
}
