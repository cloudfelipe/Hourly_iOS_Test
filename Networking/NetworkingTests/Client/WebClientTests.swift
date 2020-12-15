//
//  WebClientTests.swift
//  NetworkingTests
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import XCTest

final class WebClientTests: XCTestCase {
    
    struct RequestMock: Encodable {
        let nameTest: String = "SampleTest"
    }
    
    struct ResponseMock: Decodable, Equatable {
        let title: String
    }
    
    var webClient: WebClient!
    
    override func setUp() {
        super.setUp()
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let urlSession: URLSession = URLSession(configuration: configuration)
        webClient = WebClient(urlSession: urlSession, authProvider: AuthProviderMock())
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolMock.requestHandler = nil
        webClient = nil
    }
    
    func testWebClient_whenRequestIsLoaded_thenRequestSentWithResponseObjectSuccessfully() {
        let mockJSONData: Data = "{\"title\":\"Sampe\"}".data(using: .utf8)!
        
        URLProtocolMock.requestHandler = { request in
            XCTAssertEqual(request.url?.query?.contains("nameTest=SampleTest"), true)
            return (HTTPURLResponse(), mockJSONData)
        }
        
        let expectation: XCTestExpectation = XCTestExpectation(description: "response")
        
        let endpoint: RESTEndpointType = RESTEndpoint(method: .get,
                                                      baseUrl: "https://example.com/",
                                                      path: .relativePath("tests"),
                                                      requestParameters: RequestMock(),
                                                      contentType: .json)
        let apiRequest: APIRequest = APIRequest<ResponseMock>(endpoint: endpoint)
        
        webClient.loadAPIRequest(endpoint: apiRequest) { result in
            switch result {
            case .success(let responseObject):
                XCTAssertEqual(responseObject, ResponseMock(title: "Sampe"))
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWebClient_whenRequestIsLoadedWithArrayObject_thenRequesSentAndResponseFailureWithDecodingError() {
        let mockJSONData: Data = "[{\"title\":\"Sampe\"}]".data(using: .utf8)!
        
        URLProtocolMock.requestHandler = { request in
            XCTAssertEqual(request.url?.query?.contains("nameTest=SampleTest"), true)
            return (HTTPURLResponse(), mockJSONData)
        }
        
        let expectation: XCTestExpectation = XCTestExpectation(description: "response")
        
        let endpoint: RESTEndpointType = RESTEndpoint(method: .get,
                                                      baseUrl: "https://example.com/",
                                                      path: .relativePath("tests"),
                                                      requestParameters: RequestMock(),
                                                      contentType: .json)
        let apiRequest: APIRequest = APIRequest<ResponseMock>(endpoint: endpoint)
        
        webClient.loadAPIRequest(endpoint: apiRequest) { result in
            switch result {
            case .success:
                XCTFail("Expected failure instead")
            case .failure(let error):
                switch error {
                case .decodableError(error: _):
                    expectation.fulfill()
                default:
                    XCTFail("Unexpected error type \(error)")
                }
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWebClient_whenRequestIsLoaded_thenRequestSentWithArrayResponseObjectSuccessfully() {
        let mockJSONData: Data = "[{\"title\":\"Sample1\"}, {\"title\":\"Sample2\"}]".data(using: .utf8)!
        
        URLProtocolMock.requestHandler = { request in
            XCTAssertEqual(request.url?.query?.contains("nameTest=SampleTest"), true)
            return (HTTPURLResponse(), mockJSONData)
        }
        
        let expectation: XCTestExpectation = XCTestExpectation(description: "response")
        
        let endpoint: RESTEndpointType = RESTEndpoint(method: .get,
                                                      baseUrl: "https://example.com/",
                                                      path: .relativePath("tests"),
                                                      requestParameters: RequestMock(),
                                                      contentType: .json)
        let apiRequest: APIRequest = APIRequest<[ResponseMock]>(endpoint: endpoint)
        
        webClient.loadAPIRequest(endpoint: apiRequest) { result in
            switch result {
            case .success(let responseObject):
                XCTAssertNotNil(responseObject)
                XCTAssertEqual(responseObject.count, 2)
                XCTAssertEqual(responseObject[0].title, "Sample1")
                XCTAssertEqual(responseObject[1].title, "Sample2")
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

