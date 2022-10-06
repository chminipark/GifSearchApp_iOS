//
//  URLSessionable.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/25.
//

import Foundation

protocol URLSessionable {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionable {}
