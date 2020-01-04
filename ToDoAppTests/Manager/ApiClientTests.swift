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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginUsesCorrectHost() {
        let mockURLSession = MockURLSession()
        let sut = APIClient()
        sut.urlSession = mockURLSession
        
        let completionHandler = { (token: String?, error: Error?) in }
        sut.login(withName: "name", password: "qwerty", completionHandler: completionHandler)
        
        guard let url = mockURLSession.url else {
            XCTFail()
            return
        }
        
        let urlComponets = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponets?.host, "todoapp.com")
    }
}

extension ApiClientTests {
    class MockURLSession: URLSessionProtocol {
        var url: URL?
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            return URLSession.shared.dataTask(with: url)
        }
    }
}

