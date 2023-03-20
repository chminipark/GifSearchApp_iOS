//
//  SearchGifCollectionViewCell.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/17.
//

import Foundation
import UIKit
import SDWebImage

final class SearchGifCollectionViewCell: UICollectionViewCell {
  static let id = "gifCell"
  
  private let imageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let indicatorView: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView()
    indicator.style = UIActivityIndicatorView.Style.large
    indicator.startAnimating()
    return indicator
  }()
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.contentView.addSubview(imageView)
    NSLayoutConstraint.activate([
      self.imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
      self.imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
      self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    ])
    
    self.contentView.addSubview(indicatorView)
    indicatorView.center = self.contentView.center
  }
  
  func displayImage(image: UIImage) {
    self.indicatorView.stopAnimating()
    self.indicatorView.isHidden = true
    self.imageView.image = image
  }
  
  func loadImage() {
    self.imageView.image = UIImage()
    self.indicatorView.startAnimating()
    self.indicatorView.isHidden = false
  }
  
  func configure(_ gif: Gif) {
    if let image = gif.image {
      displayImage(image: image)
    } else {
      loadImage()
    }
  }
}
