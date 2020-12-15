//
//  WebService.swift
//  Networking
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

public protocol BaseURLProviderType {
    var baseURL: String { get }
}

public class WebService {
    
    internal let client: WebClientType
    internal let baseUrl: BaseURLProviderType
    
    public init(baseUrlProvider: BaseURLProviderType, client: WebClientType) {
        self.client = client
        self.baseUrl = baseUrlProvider
    }
}
