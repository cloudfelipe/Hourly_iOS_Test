//
//  AppError.swift
//  Hourbox
//
//  Created by Felipe Correa on 17/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation
import Networking

enum ErrorCategory: Error {
    case nonRetryable
    case retryable
    case requiresLogout
}

protocol CategorizedError: Error {
    var category: ErrorCategory { get }
}

extension Error {
    func resolveCategory() -> ErrorCategory {
        guard let categorized = self as? CategorizedError else {
            return .nonRetryable
        }
        return categorized.category
    }
}

extension WebClientError: CategorizedError {
    var category: ErrorCategory {
        switch self {
        case .unAuthorized:
            return .requiresLogout
        case .noInternetConnection:
            return .retryable
        case .urlMalformed:
            return .nonRetryable
        case .urlWithQueryItemsMalformed:
            return .nonRetryable
        case .errorWithCode:
            return .nonRetryable
        case .unableToParseDataToJSON:
            return .nonRetryable
        case .unableToParseJSONToData:
            return .nonRetryable
        case .undefined:
            return .nonRetryable
        case .decodableError:
            return .nonRetryable
        case .noDataResponse:
            return .nonRetryable
        case .unableDownloadFile(_):
            return .retryable
        }
    }
}
