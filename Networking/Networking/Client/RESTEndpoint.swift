//
//  RESTEndpoint.swift
//  Hourbox
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

public enum RESTEndpointPath {
    case relativePath(String)
    case fullPath(String)
    
    var path: String {
        switch self {
        case .fullPath(let path), .relativePath(let path):
            return path
        }
    }
}

public protocol RESTEndpointType {
    var method: HTTPMethod { get }
    var baseUrl: String { get }
    var path: RESTEndpointPath { get }
    var parameters: Data? { get }
    var contentType: APIContentType { get }
}

struct RESTEndpoint<RequestDataType: Encodable>: RESTEndpointType {
    public let method: HTTPMethod
    public let baseUrl: String
    public let path: RESTEndpointPath
    public let requestParameters: RequestDataType?
    public let contentType: APIContentType
    
    var parameters: Data? {
        return parseRequest(data: requestParameters)
    }
    
    func parseRequest(data: RequestDataType?) -> Data? {
        return try? JSONEncoder().encode(data)
    }
}
