//
//  GifAPITests.swift
//  GifSearchAppTests
//
//  Created by chmini on 2022/09/25.
//

import XCTest
@testable import GifSearchApp

class GifAPITests: XCTestCase {
    var sut: Provider!
    
    override func setUpWithError() throws {
        sut = ProviderImpl(session: MockURLSession())
    }
    
    func test_GifSearch_whenSuccess() {
        let expectation = XCTestExpectation()
        let endpoint = APIEndpoints.getGifSearchInfo(with: .init(gifName: "hello", offset: 0))
        let responseMock = try? JSONDecoder().decode(GifSearchResponseDTO.self, from: endpoint.sampleData!)
        
        sut.request(with: endpoint) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.data.first?.type, responseMock?.data.first?.type)
            case .failure(let error):
                print("😡😡😡😡")
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}
