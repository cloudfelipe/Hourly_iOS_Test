//
//  APIRequestTests.swift
//  NetworkingTests
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import XCTest

typealias JSON = [String: Any]

struct RESTEndpointMock: RESTEndpointType {
    public let method: HTTPMethod
    public let baseUrl: String
    public let path: RESTEndpointPath
    public let dicParameters: JSON?
    public let contentType: APIContentType
    
    var parameters: Data? {
        guard let dicParameters: JSON = dicParameters else { return nil }
        XCTAssertNoThrow(try JSONSerialization.data(withJSONObject: dicParameters, options: []))
        return try! JSONSerialization.data(withJSONObject: dicParameters, options: [])
    }
}

final class APIRequestTests: XCTestCase {
    
    struct ResponseDummy: Codable {
        let title: String = "one"
    }
    
    func testAPIRequest_whenCreatedWithEndpoint_thenReturnAValidURLRequest() throws {
        let endpoint: RESTEndpointMock = RESTEndpointMock(method: .get,
                                                          baseUrl: "https://example.com/",
                                                          path: .relativePath("test"),
                                                          dicParameters: ["title": "one"],
                                                          contentType: .json)
        
        let apiRequest: APIRequest = APIRequest<ResponseDummy>(endpoint: endpoint)
        
        XCTAssertNoThrow(try apiRequest.request())
        
        let request: URLRequest = try apiRequest.request()
        
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "example.com")
        XCTAssertEqual(request.url?.path, "/test")
        XCTAssertEqual(request.url?.query, "title=one")
    }
    
    func testAPIRequest_whenCreatedWithPOSTEndpoint_thenReturnAValidURLRequestWithoutParamsButBody() throws {
        let endpoint: RESTEndpointMock = RESTEndpointMock(method: .post,
                                                          baseUrl: "https://example.com/",
                                                          path: .relativePath("test"),
                                                          dicParameters: ["title": "one", "subtitle": "2"],
                                                          contentType: .json)
        
        let apiRequest: APIRequest = APIRequest<ResponseDummy>(endpoint: endpoint)
        
        XCTAssertNoThrow(try apiRequest.request())
        
        let request: URLRequest = try apiRequest.request()
        
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "example.com")
        XCTAssertEqual(request.url?.path, "/test")
        XCTAssertNil(request.url?.query)
        XCTAssertNotNil(request.httpBody)
    }
    
    func testAPIRequest_whenParseData_thenReturnDecodableObject() throws {
        let endpoint: RESTEndpointMock = RESTEndpointMock(method: .post,
                                                          baseUrl: "https://example.com/",
                                                          path: .relativePath("test"),
                                                          dicParameters: nil,
                                                          contentType: .json)
        
        let apiRequest: APIRequest = APIRequest<ResponseDummy>(endpoint: endpoint)
        
        let dummy: ResponseDummy = ResponseDummy()
        let dataFromDummy: Data = try JSONEncoder().encode(dummy)
        let mappedParsedObject: ResponseDummy = try apiRequest.parseResponse(data: dataFromDummy)
        
        XCTAssertEqual(mappedParsedObject.title, dummy.title)
    }
}
