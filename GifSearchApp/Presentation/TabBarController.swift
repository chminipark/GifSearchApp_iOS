//
//  TabBarController.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/17.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = SearchGifViewController()
        let vc2 = FavoriteGifViewController()
        
        vc1.title = "Search"
        vc2.title = "Favorite"
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2], animated: false)
    }
}
