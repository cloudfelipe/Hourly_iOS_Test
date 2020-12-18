//
//  NetworkClient.swift
//  Hourbox
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

public enum WebClientError: Error {
    case noInternetConnection
    case urlMalformed(url: String)
    case urlWithQueryItemsMalformed(params: [URLQueryItem]?)
    case unableToParseDataToJSON(reason: String?)
    case unableToParseJSONToData(reason: String?)
    case undefined(reason: String?)
    case decodableError(error: DecodingError)
    case noDataResponse
    case errorWithCode(Int)
    case unableDownloadFile(String)
    case unAuthorized
}

public typealias RequestResultable<T> = (Result<T, WebClientError>) -> Void

public protocol WebClientType {
    func loadAPIRequest<T: APIRequestType>(endpoint: T, completion: @escaping RequestResultable<T.ResponseDataType>)
}

public protocol AuthProviderType {
    var token: String { get }
}

final public class WebClient: WebClientType {
    
    let urlSession: URLSession
    let authProvider: AuthProviderType
    
    public init(urlSession: URLSession = .shared, authProvider: AuthProviderType) {
        self.urlSession = urlSession
        self.authProvider = authProvider
    }
    
    public func loadAPIRequest<T: APIRequestType>(endpoint: T, completion: @escaping RequestResultable<T.ResponseDataType>) {
        do {
            
            var urlRequest = try endpoint.request()
            urlRequest.addValue(authProvider.token, forHTTPHeaderField: "Authorization")
            
            urlSession.dataTask(with: urlRequest) { (data, response, error) in
                if let data = data {
//                    debugPrint("RESPONSE: ", String(data: data, encoding: .utf8)!)
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1000
                    if statusCode == 200 {
                        do {
                            let object = try endpoint.parseResponse(data: data)
                            completion(.success(object))
                        } catch let error {
                            switch error {
                            case is DecodingError:
                                completion(.failure(.decodableError(error: error as! DecodingError)))
                            default:
                                completion(.failure(.unableToParseDataToJSON(reason: error.localizedDescription)))
                            }
                        }
                    } else {
                        if statusCode == 401 {
                            completion(.failure(.unAuthorized))
                        } else {
                            completion(.failure(.errorWithCode(statusCode)))
                        }
                    }
                } else {
                    completion(.failure(.noDataResponse))
                }
            }.resume()
        } catch {
            completion(.failure(.noDataResponse))
        }
    }
    
}
