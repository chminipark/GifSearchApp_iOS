//
//  ImageCache.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/27.
//

import UIKit
import SDWebImage

protocol Item {
  var image: UIImage? { get set }
  var imageURL: String { get set }
  var identifier: UUID { get }
}

typealias ImageCompletion = (Item, UIImage?) -> Void

class ImageCache {
  private let provider: Provider
  
  private let cache = NSCache<NSURL, UIImage>()
  private var completions: [NSURL : [ImageCompletion]]? = [:]
  private let decoder = SDImageAWebPCoder.shared
  
  private var prefetches = [UUID]()
  
  init(provider: Provider) {
    self.provider = provider
  }
  
  func loadData(for item: Item, completion: @escaping ImageCompletion) {
    guard let url = URL(string: item.imageURL) as? NSURL else {
      return
    }
    
    if let gifData = cache.object(forKey: url) {
      completion(item, gifData)
      return
    }
    
    if completions?[url] != nil {
      completions?[url]?.append(completion)
      return
    } else {
      completions?[url] = [completion]
    }
    
    provider.request(with: item.imageURL) { [weak self] result in
      guard let _self = self else {
        return
      }
      
      switch result {
      case .success(let data):
        guard let decodedData = _self.decoder.decodedImage(with: data) else {
          return
        }
        
        guard let completions = _self.completions?[url] else {
          completion(item, nil)
          return
        }
        
        _self.cache.setObject(decodedData, forKey: url)
        
        completions.forEach { completion in
          completion(item, decodedData)
        }
      case .failure(let error):
        print(error)
      }
      _self.completions?.removeValue(forKey: url)
    }
  }
  
  func prefetchGif(for item: Item) {
    guard let url = URL(string: item.imageURL) as? NSURL else {
      return
    }
    
    guard cache.object(forKey: url) == nil,
          !prefetches.contains(item.identifier)
    else {
      return
    }
    
    prefetches.append(item.identifier)
    
    provider.request(with: item.imageURL) { [weak self] result in
      guard let _self = self else {
        return
      }
      
      switch result {
      case .success(let data):
        guard let decodedData = _self.decoder.decodedImage(with: data) else {
          return
        }
        _self.cache.setObject(decodedData, forKey: url)
        _self.prefetches.removeAll { $0 == item.identifier }
      case .failure(let error):
        print(error)
      }
    }
  }
}
