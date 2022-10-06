//
//  MockURLSession.swift
//  GifSearchAppTests
//
//  Created by chmini on 2022/09/25.
//

import Foundation
@testable import GifSearchApp

class MockURLSession: URLSessionable {
    var makeRequestFail: Bool = false
    init(makeRequestFail: Bool = false) {
        self.makeRequestFail = makeRequestFail
    }
    
    var sessionDataTask: MockURLSessionDataTask?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let endpoint = APIEndpoints.getGifSearchInfo(with: .init(gifName: "hello"))
        
        let successResponse = HTTPURLResponse(url: try! endpoint.makeURL(),
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        
        let failResponse = HTTPURLResponse(url: try! endpoint.makeURL(),
                                           statusCode: 301,
                                           httpVersion: "2",
                                           headerFields: nil)
        
        let sessionDataTask = MockURLSessionDataTask()
        
        sessionDataTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failResponse, nil)
            } else {
                completionHandler(endpoint.sampleData!, successResponse, nil)
            }
        }
        
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let sessionDataTask = MockURLSessionDataTask()
        return sessionDataTask
    }
}
