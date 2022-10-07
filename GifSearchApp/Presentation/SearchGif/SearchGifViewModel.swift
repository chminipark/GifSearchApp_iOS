//
//  SearchGifViewModel.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/26.
//

import Foundation
import UIKit
import SDWebImage

enum Section: Int, CaseIterable {
    case main
}

enum ViewState {
    case idle
    case isLoding
}

class SearchGifViewModel {
    lazy var provider: Provider = ProviderImpl()
    let decoder = SDImageAWebPCoder.shared
    var dataSource: UICollectionViewDiffableDataSource<Section, Gif>!
    var currentPage = Page()
    var searchString: String = ""
    
    var viewState: ViewState = .idle
    let dispatchGroup = DispatchGroup()
    
    func paginationGif() {
        guard viewState == .idle,
              searchString != ""
        else {
            return
        }
        fetchGifInfos()
    }
    
    func searchGif(with gifName: String) {
        guard viewState == .idle,
              gifName != ""
        else {
            return
        }
        searchString = gifName
        currentPage = Page()
        fetchGifInfos()
    }
}

extension SearchGifViewModel {
    func fetchGifInfos() {
        let gifSearchRequestDTO = GifSearchRequestDTO(gifName: searchString, offset: currentPage.offset)
        let endpoint = APIEndpoints.getGifSearchInfo(with: gifSearchRequestDTO)
        
        viewState = .isLoding
        provider.request(with: endpoint) { [weak self] result in
            guard let _self = self else {
                return
            }
            
            _self.viewState = .idle
            
            switch result {
            case .success(let data):
                _self.currentPage = data.toDomainPage()
                print(_self.currentPage.offset)
                let gifInfos = data.toDomainGif()
                var snapshot = _self.dataSource.snapshot()
                if snapshot.sectionIdentifiers.isEmpty {
                    snapshot.appendSections([.main])
                }
                snapshot.appendItems(gifInfos, toSection: .main)
                // main or global???
                DispatchQueue.global(qos: .background).async {
                    _self.dataSource.apply(snapshot)
                }
            case .failure(let error):
                print("😡😡😡😡")
                print(error)
            }
        }
    }
    
    func downloadGif(_ gif: Gif) {
        
    }
}

extension SearchGifViewModel {
    func reloadSnapshot(with gif: Gif) {
        var newSnapshot = self.dataSource.snapshot()
        newSnapshot.reloadItems([gif])
        DispatchQueue.main.async {
            self.dataSource.apply(newSnapshot)
        }
    }
    
    func applySnapshot(with gifs: [Gif], completion: @escaping () -> ()) {
        var newSnapshot = self.dataSource.snapshot()
        if newSnapshot.sectionIdentifiers.isEmpty {
            newSnapshot.appendSections([.main])
        }
        newSnapshot.appendItems(gifs, toSection: .main)
        DispatchQueue.main.async {
            self.dataSource.apply(newSnapshot)
            completion()
        }
    }
}
