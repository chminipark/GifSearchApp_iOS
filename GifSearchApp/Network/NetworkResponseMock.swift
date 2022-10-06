//
//  NetworkResponseMock.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/25.
//

import Foundation

struct NetworkResponseMock {
    static let gifSearchData: Data = """
    {
      "data" : [{
                  "type" : "gif",
                  "title": "Pick Up Hello GIF by The Drew Barrymore Show",
                  "images": {
                        "fixed_height": {
                                "webp": "https://media4.giphy.com/media/5FDfOtafB4Gnwr9dBm/200.webp?cid=0d519b9agr6nmknnvbzguibnxptyts9fksbfdjib5bb39vut&rid=200.webp&ct=g"
                            }
                    }
               }],
      "pagination" : {
                    "offset" : 1,
                    "count" : 1
                }
    }
""".data(using: .utf8)!
}
