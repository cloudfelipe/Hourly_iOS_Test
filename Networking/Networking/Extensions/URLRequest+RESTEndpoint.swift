//
//  URLRequest+RESTEndpoint.swift
//  Hourbox
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

extension URLRequest {
    init(endpoint: RESTEndpointType) throws {
        self.init(url: try URL(endpoint: endpoint))
        
        httpMethod = endpoint.method.rawValue
        setValue(endpoint.contentType.rawValue, forHTTPHeaderField: "Accept")
        setValue(endpoint.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        
        if let parameters: Data = endpoint.parameters {
            switch endpoint.method {
            case .post, .put:
                httpBody = parameters
            default:
                break
            }
        }
    }
}
