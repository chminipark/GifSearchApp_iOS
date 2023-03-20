//
//  Requestable.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/20.
//

import Foundation

protocol Requestable {
  var baseURL: String { get }
  var path: String { get }
  var method: HttpMethod { get }
  var queryParameters: Encodable? { get }
  var bodyParameters: Encodable? { get }
  var headers: [String: String]? { get }
  var sampleData: Data? { get }
}

extension Requestable {
  func makeURLRequest() throws -> URLRequest {
    let url = try makeURL()
    var urlRequest = URLRequest(url: url)
    
    urlRequest.httpMethod = method.rawValue
    
    if let bodyParameters = try? bodyParameters?.toDictionary() {
      if !bodyParameters.isEmpty {
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters)
      }
    }
    
    headers?.forEach {
      urlRequest.setValue($1, forHTTPHeaderField: $0)
    }
    
    return urlRequest
  }
  
  func makeURL() throws -> URL {
    guard var urlComponent = URLComponents(string: baseURL) else {
      throw NetworkError.urlComponentError
    }
    
    urlComponent.path = path
    var queryItems = [URLQueryItem]()
    if let queryParameters = try queryParameters?.toDictionary() {
      queryParameters.forEach {
        queryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
      }
    }
    urlComponent.queryItems = !queryItems.isEmpty ? queryItems : nil
    
    guard let url = urlComponent.url else {
      throw NetworkError.urlComponentError
    }
    
    return url
  }
}

extension Encodable {
  func toDictionary() throws -> [String: Any]? {
    let data = try JSONEncoder().encode(self)
    let jsonData = try JSONSerialization.jsonObject(with: data)
    return jsonData as? [String: Any]
  }
}


enum HttpMethod: String {
  case get = "GET"
  case put = "PUT"
  case post = "POST"
  case delete = "DELETE"
}
