//
//  SearchGifViewController.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/17.
//

import Foundation
import UIKit

final class SearchGifViewController: UIViewController {
    
    private let searchGifViewModel = SearchGifViewModel()
    
    private let searchBar: UISearchController = {
        let sb = UISearchController()
        sb.searchBar.placeholder = "Enter the GIF name"
        sb.searchBar.searchBarStyle = .minimal
        return sb
    }()
    
    private let gridFlowLayout: GridCollectionViewFlowLayout = {
        let layout = GridCollectionViewFlowLayout()
        layout.cellSpacing = 8
        layout.numberOfColumns = 2
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.gridFlowLayout)
        view.delegate = self
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(SearchGifCollectionViewCell.self, forCellWithReuseIdentifier: SearchGifCollectionViewCell.id)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.prefetchDataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
        setupSearchBar()
        setupCollectionView()
    }
    
    private func configureUI() {
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchBar
        searchBar.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        let cellRegistration = UICollectionView.CellRegistration
        <SearchGifCollectionViewCell, Gif> { (cell, indexPath, gif) in
            cell.configure(gif)
        }
        
        self.searchGifViewModel.dataSource = UICollectionViewDiffableDataSource
        <Section, Gif> (collectionView: self.collectionView)
        { collectionView, indexPath, gif -> SearchGifCollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: gif)
        }
    }
}

extension SearchGifViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        searchGifViewModel.searchGif(with: text)
    }
}

extension SearchGifViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? GridCollectionViewFlowLayout,
              flowLayout.numberOfColumns > 0
        else {
            fatalError()
        }
        
        let widthOfCells = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
        let widthOfSpacing = CGFloat(flowLayout.numberOfColumns - 1) * flowLayout.cellSpacing
        let width = (widthOfCells - widthOfSpacing) / CGFloat(flowLayout.numberOfColumns)
        return CGSize(width: width, height: width * flowLayout.ratio)
    }
}

extension SearchGifViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let totalHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let currentYOffset = scrollView.contentOffset.y
        let remainFromBottom = totalHeight - currentYOffset

        if remainFromBottom < frameHeight * 2 {
//            searchGifViewModel.paginationGif()
        }
    }
}

extension SearchGifViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("😈😈😈😈😈😈😈😈test")
        if !indexPaths.isEmpty {
            for index in indexPaths {
                print(index.row, terminator: " ")
            }
        }
    }
}


