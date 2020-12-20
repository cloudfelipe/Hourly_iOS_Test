//
//  LogoutInteractor.swift
//  Hourbox
//
//  Created by Felipe Correa on 19/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

protocol LogoutInteractorType {
    func logout()
}

final class LogoutInteractor: LogoutInteractorType {
    func logout() {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
}
