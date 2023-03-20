//
//  GifSearchRequestDTO.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/25.
//

import Foundation

struct GifSearchRequestDTO: Encodable {
  let api_key: String = "P2kg7aKOp3czI1WrOqvQ9h38Rrq97dEi"
  let gifName: String
  let limit: Int = 25
  let offset: Int
  
  enum CodingKeys: String, CodingKey {
    case api_key
    case gifName = "q"
    case limit
    case offset
  }
}
