//
//  GifSearchResponseDTO.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/25.
//

import Foundation
import UIKit

struct GifSearchResponseDTO: Decodable {
  let data: [GifSearchObjectDTO]
  let pagination: GifSearchPaginationDTO
  
  struct GifSearchObjectDTO: Decodable {
    let type: String
    let title: String
    let images: ImagesDTO
    
    struct ImagesDTO: Decodable {
      let imageWithFixedHeight: ImageWithFixedHeight
      
      struct ImageWithFixedHeight: Decodable {
        let webpURL: String
        
        enum CodingKeys: String, CodingKey {
          case webpURL = "webp"
        }
      }
      
      enum CodingKeys: String, CodingKey {
        case imageWithFixedHeight = "fixed_height_downsampled"
      }
    }
  }
  
  struct GifSearchPaginationDTO: Decodable {
    let offset: Int
    let count: Int
  }
}

extension GifSearchResponseDTO {
  func toDomainGif() -> [Gif] {
    var gifs = [Gif]()
    data.forEach {
      gifs.append(
        Gif(imageURL: $0.images.imageWithFixedHeight.webpURL)
      )
    }
    return gifs
  }
  
  func toDomainPage() -> Page {
    return Page(offset: pagination.offset + pagination.count)
  }
}
