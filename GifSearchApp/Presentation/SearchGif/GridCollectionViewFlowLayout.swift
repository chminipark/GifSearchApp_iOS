//
//  GridCollectionViewFlowLayout.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/17.
//

import UIKit

class GridCollectionViewFlowLayout: UICollectionViewFlowLayout {
  var numberOfColumns = 1
  var ratio = 1.0
  
  var cellSpacing = 0.0 {
    didSet {
      self.minimumLineSpacing = cellSpacing
      self.minimumInteritemSpacing = cellSpacing
    }
  }
  
  override init() {
    super.init()
    self.scrollDirection = .vertical
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
