//
//  APIEndpoints.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/25.
//

import Foundation

struct APIEndpoints {
    static func getGifSearchInfo(with gifSearchRequestDTO: GifSearchRequestDTO) -> Endpoint<GifSearchResponseDTO> {
        return Endpoint(
            baseURL: "https://api.giphy.com/",
            path: "/v1/gifs/search",
            method: .get,
            queryParameters: gifSearchRequestDTO,
            sampleData: NetworkResponseMock.gifSearchData
            )
    }
}
