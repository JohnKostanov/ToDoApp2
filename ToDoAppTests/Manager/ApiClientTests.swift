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
        mockURLSession = MockURLSession()
        sut = APIClient()
        sut.urlSession = mockURLSession
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func userLogin() {
        let completionHandler = { (token: String?, error: Error?) in }
        sut.login(withName: "name", password: "qwerty", completionHandler: completionHandler)
    }
    
    func testLoginUsesCorrectHost() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponets?.host, "todoapp.com")
    }
    
    func testLoginUsesCorrectPath() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponets?.path, "/login")
    }
}

extension ApiClientTests {
    class MockURLSession: URLSessionProtocol {
        var url: URL?
        
        var urlComponets: URLComponents? {
            guard let url = url else { return nil }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            return URLSession.shared.dataTask(with: url)
        }
    }
}

