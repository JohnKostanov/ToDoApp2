//
//  ApiClientTests.swift
//  ToDoAppTests
//
//  Created by  Джон Костанов on 04/01/2020.
//  Copyright © 2020 John Kostanov. All rights reserved.
//

import XCTest
@testable import ToDoApp

class ApiClientTests: XCTestCase {
    
    var sut: APIClient!
    var mockURLSession: MockURLSession!

    override func setUp() {
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut = APIClient()
        sut.urlSession = mockURLSession
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func userLogin() {
        let completionHandler = { (token: String?, error: Error?) in }
        sut.login(withName: "name", password: "%qwerty", completionHandler: completionHandler)
    }
    
    func testLoginUsesCorrectHost() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponets?.host, "todoapp.com")
    }
    
    func testLoginUsesCorrectPath() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponets?.path, "/login")
    }
    
    func testLoginUsesExpectedQueryParameters() {
        userLogin()
        
        guard let queryItems = mockURLSession.urlComponets?.queryItems else {
            XCTFail()
            return
        }
        
        let urlQueryItemName = URLQueryItem(name: "name", value: "name")
        let urlQueryItemPassword = URLQueryItem(name: "password", value: "%qwerty")
        
        XCTAssertTrue(queryItems.contains(urlQueryItemName))
        XCTAssertTrue(queryItems.contains(urlQueryItemPassword))
    }
    
    // token -> Data -> completionHandler -> DataTask  -> urlSession
    func testSuccessfullLoginCreatesToken() {
        let jsonDataStub = "{\"token\":\"tokenString\"}".data(using: .utf8)
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        let tokenExpectation = expectation(description: "Token expectation")
        var caughtToken: String?
        sut.login(withName: "login", password: "password") { token, _ in
            caughtToken = token
            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(caughtToken, "tokenString")
        }
    }
    
    func testLoginInvalidJSONReturnsError() {
        mockURLSession = MockURLSession(data: Data(), urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { token, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
}

extension ApiClientTests {
    class MockURLSession: URLSessionProtocol {
        var url: URL?
        private let mockDataTask: MockURLSessionDataTask
        
        var urlComponets: URLComponents? {
            guard let url = url else { return nil }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            mockDataTask = MockURLSessionDataTask(data: data, urlResponse: urlResponse, responseError: responseError)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
//            return URLSession.shared.dataTask(with: url)
            mockDataTask.completionHandler = completionHandler
            return mockDataTask
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(
                    self.data,
                    self.urlResponse,
                    self.responseError
                )
            }
        }
    }
}
