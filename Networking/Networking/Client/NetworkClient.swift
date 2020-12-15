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
}

public typealias RequestResultable<T> = (Result<T, WebClientError>) -> Void

public protocol WebClientType {
    func loadRequest<T:Decodable>(urlRequest: URLRequest, completion: @escaping RequestResultable<T>)
}

public protocol AuthProviderType {
    
}

final public class WebClient: WebClientType {
    
    let urlSession: URLSession
    let authProvider: AuthProviderType
    
    public init(urlSession: URLSession = .shared, authProvider: AuthProviderType) {
        self.urlSession = urlSession
        self.authProvider = authProvider
    }
    
    public func loadRequest<T:Decodable>(urlRequest: URLRequest, completion: @escaping RequestResultable<T>) {
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                do {
                    let responseObject = try JSONDecoder().decode(T.self, from: data)
                    let responseCode = (response as? HTTPURLResponse)?.statusCode ?? 404
                    switch responseCode {
                    case 200:
                        completion(.success(responseObject))
                    default:
                        completion(.failure(.noDataResponse))
                    }
                } catch {
                    completion(.failure(.noDataResponse))
                }
            } else {
                completion(.failure(.noDataResponse))
            }
        }.resume()
    }
}
