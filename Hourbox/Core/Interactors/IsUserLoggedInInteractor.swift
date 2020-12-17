//
//  IsUserLoggedInInteractor.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

protocol IsUserLoggedInInteractorType {
    func isLoggedIn() -> Bool
}

final class IsUserLoggedInInteractor: IsUserLoggedInInteractorType {
    
    let repository: AccessTokenRepositoryType
    
    init(repository: AccessTokenRepositoryType) {
        self.repository = repository
    }
    
    func isLoggedIn() -> Bool {
        repository.getToken() != nil
    }
}
