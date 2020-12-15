//
//  AuthProviderMock.swift
//  NetworkingTests
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

struct AuthProviderMock: AuthProviderType {
    var token: String {
        return UUID().uuidString
    }
}
