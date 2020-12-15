//
//  WebRequest.swift
//  Networking
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

public protocol APIRequestType {
    associatedtype ResponseDataType
    
    var endpoint: RESTEndpointType { get }
    
    func request() throws -> URLRequest
    
    func parseResponse(data: Data) throws -> ResponseDataType
}

public struct APIRequest<ResponseDataType: Decodable>: APIRequestType {
    
    public let endpoint: RESTEndpointType
    
    public func request() throws -> URLRequest {
        return try URLRequest(endpoint: endpoint)
    }

    public func parseResponse(data: Data) throws -> ResponseDataType {
        return try JSONDecoder().decode(ResponseDataType.self, from: data)
    }
}
