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
