//
//  URL+RESTEndpoint.swift
//  Hourbox
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

extension URL {
    init(endpoint: RESTEndpointType) throws {
        guard var components: URLComponents = URLComponents(string: endpoint.baseUrl) else {
            throw WebClientError.urlMalformed(url: endpoint.baseUrl)
        }
        
        guard components.host != nil, components.scheme != nil else {
            throw WebClientError.urlMalformed(url: endpoint.baseUrl)
        }
        
        components.path += endpoint.path.path
        
        if let unwrappedData: Data = endpoint.parameters {
            do {
                if let parameters = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String: Any] {
                    switch endpoint.method {
                    case .get, .delete:
                        components.queryItems = parameters.map {
                            URLQueryItem(name: $0.key, value: String(describing: $0.value))
                        }
                    default:
                        break
                    }
                }
            } catch let error {
                throw WebClientError.unableToParseDataToJSON(reason: error.localizedDescription)
            }
        }
        
        guard let urlWithQueryItems: URL = components.url else {
            throw WebClientError.urlWithQueryItemsMalformed(params: components.queryItems)
        }
        
        self = urlWithQueryItems
    }
}
