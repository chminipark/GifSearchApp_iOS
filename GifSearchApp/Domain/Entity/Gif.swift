//
//  Gif.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/25.
//

import Foundation
import UIKit

class Gif: Item {
    var image: UIImage?
    var imageURL: String
    let identifier = UUID()
    
    init(image: UIImage? = nil, imageURL: String) {
        self.image = image
        self.imageURL = imageURL
    }
}

extension Gif: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        
    }
    
    static func == (lhs: Gif, rhs: Gif) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
