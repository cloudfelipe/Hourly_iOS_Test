//
//  ErrorProcessor.swift
//  Hourbox
//
//  Created by Felipe Correa on 17/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

protocol ErrorProcessorType: AnyObject {
    func process(error: Error) -> ErrorCategory
}

final class ErrorProcessor: ErrorProcessorType {
    func process(error: Error) -> ErrorCategory {
        let errorCategory = error.resolveCategory()
        switch errorCategory {
        case .requiresLogout:
            NotificationCenter.default.post(name: .logout, object: nil)
        default:
            break
        }
        return error.resolveCategory()
    }
}
