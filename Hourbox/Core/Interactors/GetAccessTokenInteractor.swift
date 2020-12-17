//
//  GetAccessToken.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

protocol GetAccessTokenInteractorType {
    func token() -> String?
}

final class GetAccessTokenInteractor: GetAccessTokenInteractorType {
    let repository: AccessTokenRepositoryType
    
    init(repository: AccessTokenRepositoryType) {
        self.repository = repository
    }
    
    func token() -> String? {
        repository.getToken()
    }
}
