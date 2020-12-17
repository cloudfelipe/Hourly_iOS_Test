//
//  StoreAccessToken.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

protocol StoreAccessTokenInteractorType {
    func store(token: String)
}

final class StoreAccessTokenInteractor: StoreAccessTokenInteractorType {
    let repository: AccessTokenRepositoryType
    
    init(repository: AccessTokenRepositoryType) {
        self.repository = repository
    }
    
    func store(token: String) {
        repository.store(token: token)
    }
}
