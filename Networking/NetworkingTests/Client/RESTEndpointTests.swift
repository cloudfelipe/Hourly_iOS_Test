//
//  RESTEndpointTests.swift
//  NetworkingTests
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import XCTest

final class RESTEndpointTests: XCTestCase {
    
    struct RequestDataStub: Codable {
        let param1: String
        let param2: Double
        let param3: Bool?
    }
    
    func testRESTEndpoint_whenCreatedWithEncodableParameters_thenEnableToReturnParametersAsData() throws {
        
        let params: RequestDataStub = RequestDataStub(param1: "Test",
                                                      param2: 1.2345,
                                                      param3: false)
        
        let endpoint: RESTEndpoint = RESTEndpoint(method: .get,
                                                    baseUrl: "http://example.com",
                                                    path: .relativePath("sample"),
                                                    requestParameters: params,
                                                    contentType: .json)
        
        let encodedParams: Data? = endpoint.parameters
        XCTAssertNotNil(encodedParams, "Parameters must be not nil")
        
        let invertMapParams: RequestDataStub = try JSONDecoder().decode(RequestDataStub.self, from: encodedParams!)
        
        XCTAssertEqual(params.param1, invertMapParams.param1)
        XCTAssertEqual(params.param2, invertMapParams.param2)
        XCTAssertEqual(params.param3, invertMapParams.param3)
    }
}
