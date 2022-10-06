//
//  MockURLSessionDataTask.swift
//  GifSearchAppTests
//
//  Created by chmini on 2022/09/25.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    
    var resumeDidCall: (() -> ())?
    
    override func resume() {
        resumeDidCall?()
    }
}
