//
//  AccessTokenRepository.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation
import KeychainAccess

protocol AccessTokenRepositoryType {
    func store(token: String)
    func getToken() -> String?
    func removeToken()
}

extension Keychain: AccessTokenRepositoryType {
    func store(token: String) {
        self["AUTH-TOKEN"] = token
    }
    
    func getToken() -> String? {
        self["AUTH-TOKEN"]
    }
    
    func removeToken() {
        self["AUTH-TOKEN"] = nil
    }
}
