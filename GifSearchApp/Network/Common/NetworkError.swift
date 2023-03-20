//
//  NetworkError.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/20.
//

import Foundation

enum NetworkError: Error {
  case myError
  case urlComponentError
  case urlRequestError
  case encodingError
  case decodingError
  case urlError
}
