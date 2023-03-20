//
//  RootViewController.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/17.
//

import UIKit

class RootViewController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let vc = SearchGifViewController()
    vc.title = "GifSearch"
    vc.navigationItem.largeTitleDisplayMode = .always
    self.setViewControllers([vc], animated: false)
    self.navigationBar.prefersLargeTitles = true
  }
}
