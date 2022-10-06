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
    let provider: Provider
    init(provider: Provider) {
        self.provider = provider
    }
    
    private let cache = NSCache<NSURL, UIImage>()
    private var prefetches: [UUID] = []
    private var completions: [NSURL: [ImageCompletion]]? = [:]
    
    func prefetchImage(item: Item) {
        guard let url = URL(string: item.imageURL) else {
            return
        }
        
        let nsUrl = url as NSURL
        guard cachedImage(for: nsUrl) == nil,
              !prefetches.contains(item.identifier) else {
            return
        }
        
        provider.request(with: item.imageURL) { [weak self] result in
            guard let _self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                guard let image = SDImageAWebPCoder.shared.decodedImage(with: data) else {
                    return
                }
                _self.cache.setObject(image, forKey: nsUrl)
                _self.prefetches.removeAll {
                    $0 == item.identifier
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadImage(item: Item, completion: @escaping ImageCompletion) {
        guard let url = URL(string: item.imageURL) else {
            return
        }
        
        let nsUrl = url as NSURL
        if let image = cachedImage(for: nsUrl) {
            completion(item, image)
        }
        
        if completions?[nsUrl] != nil {
            completions?[nsUrl]?.append(completion)
            return
        } else {
            completions?[nsUrl] = [completion]
        }
        
        provider.request(with: item.imageURL) { [weak self] result in
            guard let _self = self else {
                return
            }
            switch result {
            case .success(let data):
                guard let image = SDImageAWebPCoder.shared.decodedImage(with: data) else {
                    return
                }
                
                guard let completions = _self.completions?[nsUrl] else {
                    completion(item, nil)
                    return
                }
                
                _self.cache.setObject(image, forKey: nsUrl)
            case .failure(let error):
                print(error)
                completion(item, nil)
            }
            
            _self.completions?.removeValue(forKey: nsUrl)
        }
    }
    
    func reset() {
        completions?.removeAll()
        prefetches.removeAll()
        cache.removeAllObjects()
    }
    
    private func cachedImage(for url: NSURL) -> UIImage? {
        cache.object(forKey: url)
    }
}


//typealias ImageCompletion = (Item, UIImage?) -> Void
//
//class ImageCache {
//    let provider: Provider
//    init(provider: Provider) {
//        self.provider = provider
//    }
//
//    private let cache = NSCache<NSURL, UIImage>()
//    private var prefetches: [UUID] = []
//    private var completions: [NSURL: [ImageCompletion]]? = [:]
//
//    // Prefetch
//
//    func prefetchImage(for item: Item) {
//        let url = item.imageUrl as NSURL
//        guard cachedImage(for: url) == nil, !prefetches.contains(item.identifier) else { return }
//        prefetches.append(item.identifier)
//
//        provider.request(item.imageUrl) { [weak self] result in
//            switch result {
//            case .success(let data):
//                guard let image = UIImage(data: data) else { return }
//                self?.cache.setObject(image, forKey: url)
//                self?.prefetches.removeAll { $0 == item.identifier }
//            default: break
//            }
//        }
//    }
//
//    // Load
//
//    func loadImage(for item: Item, completion: @escaping ImageCompletion) {
//        let url = item.imageUrl as NSURL
//        if let image = cachedImage(for: url) {
//            completion(item, image)
//            return
//        }
//
//        if completions?[url] != nil {
//            completions?[url]?.append(completion)
//            return
//        } else {
//            completions?[url] = [completion]
//        }
//
//        provider.request(item.imageUrl) { [weak self] result in
//            switch result {
//            case .success(let data):
//                guard let image = UIImage(data: data) else { return }
//
//                guard let completions = self?.completions?[url] else {
//                    completion(item, nil)
//                    return
//                }
//
//                self?.cache.setObject(image, forKey: url)
//
//                completions.forEach { completion in
//                    completion(item, image)
//                }
//            case .failure(let error):
//                print(error)
//                completion(item, nil)
//            }
//
//            self?.completions?.removeValue(forKey: url)
//        }
//    }
//
//    // Reset
//
//    func reset() {
//        completions?.removeAll()
//        prefetches.removeAll()
//        cache.removeAllObjects()
//    }
//
//    // Cache
//
//    private func cachedImage(for url: NSURL) -> UIImage? {
//        cache.object(forKey: url)
//    }
//}
